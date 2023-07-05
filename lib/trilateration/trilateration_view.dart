import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:get/get.dart';

import '../controller/bluetooth_controller.dart';
import '../controller/main_wrapper_controller.dart';
import '../utils/color_constants.dart';
import '../utils/grid/map_grid_view.dart';

class TrilaterationView extends StatefulWidget {
  const TrilaterationView({Key? key}) : super(key: key);

  @override
  State<TrilaterationView> createState() => TrilaterationViewState();
}

class TrilaterationViewState extends State<TrilaterationView> {
  num logDistancePathLoss(String rssi, double alpha) =>
      pow(10.0, ((alpha - double.parse(rssi)) / (10 * 2)));

  List<double> centriX = [];
  List<double> centriY = [];
  List<num> raggi = [];

  @override
  Widget build(BuildContext context) {
    final MainWrapperController mainWrapperController = Get.find();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<BluetoothController>(
        init: mainWrapperController.bluetoothController,
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Map",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: ColorConstants.appColor,
                                fontWeight: FontWeight.w900)),),
                StreamBuilder<List<SelectedDevice>>(
                  stream: controller.selectedDevicesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final selectedDevices = snapshot.data!;
                      double alpha = -55.0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          MapGridView(
                            centerXList: controller.selectedDevices
                                .map((device) => device.centerX)
                                .toList(),
                            centerYList: controller.selectedDevices
                                .map((device) => device.centerY)
                                .toList(),
                            radiusList: controller.selectedDevices
                                .map((device) => logDistancePathLoss(
                                      device.rssi.toString(),
                                      alpha,
                                    ))
                                .toList(),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (_, __) => const Divider(),
                            physics: const ScrollPhysics(),
                            itemCount: selectedDevices.length,
                            itemBuilder: (context, index) {
                              final selectedDevice =
                                  selectedDevices[index];
                              final data = selectedDevice.result;
                              final deviceName =
                                  data.device.name.isNotEmpty
                                      ? data.device.name
                                      : data.advertisementData.localName;
                              final title =
                                  'Device ${index + 1}${deviceName.isNotEmpty ? ': $deviceName' : ''}';
                              //double alpha = selectedDevice.rssi.toDouble();
                              String rssi =
                                  selectedDevice.rssi.toString();
                              num distance =
                                  logDistancePathLoss(rssi, alpha);
                              selectedDevice.distance = distance;
                              raggi.add(distance);
                              return ExpansionTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.radar,
                                    color: Colors.blue,
                                  ),
                                ),
                                title: Text(title),
                                subtitle:
                                    Text("MAC: ${data.device.id.id}"),
                                trailing: Text(
                                    '${distance.toStringAsPrecision(3)} m'),
                                children: <Widget>[
                                  ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.all(16),
                                          child: SpinBox(
                                            min: -100,
                                            max: -30,
                                            value: alpha,
                                            decimals: 0,
                                            step: 1,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDevice.distance =
                                                    logDistancePathLoss(
                                                        selectedDevice
                                                            .rssi
                                                            .toString(),
                                                        value);
                                              });
                                            },
                                            decoration:
                                                const InputDecoration(
                                                    labelText:
                                                        'RSSI at 1m'),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.all(16),
                                          child: SpinBox(
                                            min: 0.0,
                                            max: 20.0,
                                            value: selectedDevice.centerX,
                                            decimals: 1,
                                            step: 0.1,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDevice.centerX =
                                                    value;
                                                centriX.add(value);
                                              });
                                            },
                                            decoration:
                                                const InputDecoration(
                                                    labelText:
                                                        'Center X [m]'),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.all(16),
                                          child: SpinBox(
                                            min: 0.0,
                                            max: 20.0,
                                            value: selectedDevice.centerY,
                                            decimals: 1,
                                            step: 0.1,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDevice.centerY =
                                                    value;
                                                centriY.add(value);
                                              });
                                            },
                                            decoration:
                                                const InputDecoration(
                                                    labelText:
                                                        'Center Y [m]'),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text("No devices selected"));
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/*List<Widget> buildAnchorCircles(List<Anchor> anchors) {
  return anchors.map((anchor) {
    return CircleView(
      centerX: anchor.centerX,
      centerY: anchor.centerY,
      radius: anchor.radius,
    );
  }).toList();
}

class CirclePainter extends CustomPainter {
  var centerXList = [];
  var centerYList = [];
  var radiusList = [];
  var anchorePaint = Paint()
    ..color = Colors.lightBlue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..isAntiAlias = true;
  var positionPaint = Paint()
    ..color = Colors.redAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..isAntiAlias = true;
  final BluetoothController bleController;

  CirclePainter(this.bleController, this.centerXList, this.centerYList, this.radiusList);

  @override
  void paint(Canvas canvas, Size size) {
    List<Anchor> anchorList = [];
    List<double> pointDistance = [];
    if (radiusList.isNotEmpty) {
      for (int i = 0; i < radiusList.length; i++) {
        // radius
        var radius = radiusList[i] > 8.0
            ? 8.0
            : radiusList[i];
        anchorList.add(Anchor(
            centerX: centerXList[i], centerY: centerYList[i], radius: radius));
        canvas.drawCircle(Offset(centerXList[i] * 100, centerYList[i] * 100),
            radius * 100, anchorePaint);
        // centerX, centerY
        canvas.drawCircle(Offset(centerXList[i] * 100, centerYList[i] * 100), 2,
            anchorePaint);
        // anchor text paint
        var anchorTextPainter = TextPainter(
          text: TextSpan(
            text: 'Anchor$i\n(${centerXList[i]}, ${centerYList[i]})',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        anchorTextPainter.layout(
          minWidth: 0,
          maxWidth: size.width,
        );
        anchorTextPainter.paint(
            canvas, Offset(centerXList[i] * 100 - 27, centerYList[i] * 100));
        // radius text paint
        var radiusTextPainter = TextPainter(
          text: TextSpan(
            text: '  ${radius.toStringAsFixed(2)}m',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 10,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        radiusTextPainter.layout(
          minWidth: 0,
          maxWidth: size.width,
        );
        radiusTextPainter.paint(
            canvas,
            Offset(centerXList[i] * 100,
                centerYList[i] * 100 - (radius * 100) / 2 - 5));
        // draw a line
        //var p1 = Offset(centerXList[i] * 100, centerYList[i] * 100);
        //var p2 = Offset(
        //    centerXList[i] * 100, centerYList[i] * 100 - radiusList[i] * 100);

        //canvas.drawLine(p1, p2, anchorePaint);
        drawDashedLine(canvas, anchorePaint, centerXList[i] * 100,
            centerYList[i] * 100, radius * 100);
      }
      // decision max distance
      if (anchorList.length >= 3) {
        for (int i = 0; i < anchorList.length - 1; i++) {
          pointDistance.add(sqrt(
              pow((anchorList[i + 1].centerX - anchorList[0].centerX), 2) +
                  pow((anchorList[i + 1].centerY - anchorList[0].centerY), 2)));
        }
        var maxDistance = pointDistance.reduce(max);
        print(maxDistance);
        //
        var position =
        trilaterationMethod(anchorList, 8.0);

        if ((position[0][0] >= 0.0) && (position[1][0] >= 0.0)) {
          canvas.drawCircle(Offset(position[0][0] * 100, position[1][0] * 100),
              3, positionPaint);

          var positionTextPainter = TextPainter(
            text: TextSpan(
              text:
              '(${position[0][0].toStringAsFixed(2)}, ${position[1][0].toStringAsFixed(2)})',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          positionTextPainter.layout(
            minWidth: 0,
            maxWidth: size.width,
          );

          positionTextPainter.paint(canvas,
              Offset(position[0][0] * 100 - 25, position[1][0] * 100 + 10));
        }
      }
    }
  }

  void drawDashedLine(Canvas canvas, Paint paint, double centerX,
      double centerY, double radius) {
    const int dashWidth = 4;
    const int dashSpace = 3;
    double startY = 0;
    while (startY < radius - 2) {
      // Draw a dash line
      canvas.drawLine(Offset(centerX, centerY - startY),
          Offset(centerX, centerY - startY - dashSpace), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return true;
  }
}*/
