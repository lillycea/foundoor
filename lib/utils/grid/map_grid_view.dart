import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foundoor/trilateration/trilateration_method.dart';


class MapGridView extends StatelessWidget {
  final List<double> centerXList;
  final List<double> centerYList;
  final List<num> radiusList;

  const MapGridView({
    Key? key,
    required this.centerXList,
    required this.centerYList,
    required this.radiusList,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    const double gridSize = 450; // Dimensione della griglia
    const double pointSize = 15; // Dimensione dei punti
    const double maxRadius = 8; // Raggio massimo consentito

    return SafeArea(
      child: SizedBox(
        width: gridSize,
        height: gridSize,
        child: CustomPaint(
          size: const Size(gridSize, gridSize),
          painter: CirclePainter(centerXList, centerYList, radiusList),
          child: Stack(
            children: <Widget>[
              ...List.generate(
                centerXList.length,
                    (index) {
                  final centerX = centerXList[index];
                  final centerY = centerYList[index];

                  final pointX = centerX * gridSize / maxRadius + gridSize / 2;
                  final pointY = centerY * gridSize / maxRadius + gridSize / 2;

                  return Positioned(
                    left: pointX - pointSize / 2,
                    top: pointY - pointSize / 2,
                    child: GestureDetector(
                      onTap: () {
                        print("hello");
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final List<double> centerXList;
  final List<double> centerYList;
  final List<num> radiusList;

  CirclePainter(this.centerXList, this.centerYList, this.radiusList);

  @override
  void paint(Canvas canvas, Size size) {
    const double gridSize = 200; // Dimensione della griglia
    const double maxRadius = 8; // Raggio massimo consentito
    const double pointSize = 2; // Dimensione del punto

    final Paint anchorPaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    //..isAntiAlias = true;

    final Paint positionPaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    //..isAntiAlias = true;

    final Paint pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    for (int i = 0; i < centerXList.length; i++) {
      final centerX = centerXList[i];
      final centerY = centerYList[i];
      final radius = radiusList[i];

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

      var position = trilaterationMethod(centerXList, centerYList, radiusList);

      if(position.x >= 0.0){
        if(position.y >= 0.0){
          canvas.drawCircle(Offset(position.x*43, position.y*43), 3, pointPaint);
        }
      }

    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
