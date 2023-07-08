import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foundoor/trilateration/trilateration_method.dart';
import 'package:get/get.dart';

import '../../controller/main_wrapper_controller.dart';


class MapGridView extends StatefulWidget {
  final List<double> centerXList;
  final List<double> centerYList;
  final List<num> radiusList;

  const MapGridView({
    Key? key,
    required this.centerXList,
   required this.centerYList,
   required this.radiusList,
  }) : super(key: key);

  @override
  State<MapGridView> createState() => _MapGridViewState();
}

class _MapGridViewState extends State<MapGridView>
    with SingleTickerProviderStateMixin {
  final MainWrapperController mainWrapperController = Get.find();
  late AnimationController _animationController;

  var centerXList = [];
  var centerYList = [];
  List<num> radiusList = [];
  var imageUrl = '';

  @override
  void initState() {
    super.initState();
    final bleController = mainWrapperController.bluetoothController;
    final updater = mainWrapperController.uploadController;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )
      ..addListener(() => setState(() {}))
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
          centerXList = bleController.selectedDevices
              .map((device) => device.centerX)
              .toList();
          centerYList = bleController.selectedDevices
              .map((device) => device.centerY)
              .toList();
          radiusList = bleController.selectedDevices
              .map((device) => logDistancePathLoss(device.result.rssi.toString(), device.alpha))
              .toList();
          imageUrl = updater.file!;
        }
      });

  }

  num logDistancePathLoss(String rssi, double alpha) =>
      pow(10.0, ((alpha - double.parse(rssi)) / (10 * 2)));

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MapGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
      _animationController.reset();
      _animationController.forward();
    }

  @override
  Widget build(BuildContext context) {
    const double gridSize = 450;
    const double pointSize = 15;
    const double maxRadius = 8;

    return SafeArea(
     // width: gridSize,
     // height: gridSize,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child:
            Image.network(imageUrl, fit: BoxFit.cover,),
          ),
          const SizedBox(),
          CustomPaint(
            size: const Size(gridSize, gridSize),
            painter: CirclePainter(
              widget.centerXList,
              widget.centerYList,
              widget.radiusList
            ),
            child: Stack(
              children: <Widget>[
                ...List.generate(
                  centerXList.length,
                      (index) {
                    final centerX = centerXList[index];
                    final centerY = centerYList[index];

                    final pointX =
                        centerX * gridSize / maxRadius + gridSize / 2;
                    final pointY =
                        centerY * gridSize / maxRadius + gridSize / 2;

                    return Positioned(
                      left: pointX - pointSize / 2,
                      top: pointY - pointSize / 2,
                      child: GestureDetector(
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  var centerXList = [];
  var centerYList = [];
  var radiusList = [];

  CirclePainter(
      this.centerXList,
      this.centerYList,
      this.radiusList,
      );

  @override
  void paint(Canvas canvas, Size size) {
    const double gridSize = 200;
    const double maxRadius = 8;
    const double pointSize = 2;

    final Paint anchorPaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint positionPaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    final Paint pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    for (int i = 0; i < radiusList.length; i++) {
      var radius = radiusList[i] > maxRadius
          ? maxRadius
          : radiusList[i];
      final centerX = centerXList[i];
      final centerY = centerYList[i];

      final pointX = centerX * gridSize / maxRadius + gridSize / 2;
      final pointY = centerY * gridSize / maxRadius + gridSize / 2;

      canvas.drawCircle(
        Offset(pointX, pointY),
        radius * gridSize / maxRadius,
        anchorPaint,
      );

      canvas.drawCircle(
        Offset(pointX, pointY),
        pointSize,
        positionPaint,
      );

      final position = trilaterationMethod(
        centerXList,
        centerYList,
        radiusList,
      );

      var positionTextPainter = TextPainter(
        text: TextSpan(
          text:
          '(${position.x.toStringAsFixed(2)}, ${position.y.toStringAsFixed(2)})',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.rtl,
      );
      positionTextPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      if (position.x >= 0.0 && position.y >= 0.0) {
        positionTextPainter.paint(canvas, Offset(
          position.x * gridSize / maxRadius + gridSize / 2,
          position.y * gridSize / maxRadius + gridSize / 2,
        ));

        canvas.drawCircle(
          Offset(
            position.x * gridSize / maxRadius + gridSize / 2,
            position.y * gridSize / maxRadius + gridSize / 2,
          ),
          3,
          pointPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

