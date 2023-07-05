import 'dart:math';

import 'package:matrix2d/matrix2d.dart';

class Point{
  final double x;
  final double y;

  Point(this.x, this.y);
}

Point trilaterationMethod(List<double> centriX, List<double> centriY, List<num> raggi ){
  final d1 = raggi[0];
  final d2 = raggi[1];
  final d3 = raggi[2];

  final x1 = centriX[0];
  final x2 = centriX[1];
  final x3 = centriX[2];

  final y1 = centriY[0];
  final y2 = centriY[1];
  final y3 = centriY[2];

  final A = 2*x2 - 2*x1;
  final B = 2*y2 - 2*y1;
  final C = pow(d1, 2) - pow(d2, 2) - pow(x1, 2) + pow(x2, 2) - pow(y1, 2) + pow(y2, 2);
  final D = 2 * x3 - 2 * x2;
  final E = 2 * y3 - 2 * y2;
  final F = pow(d2, 2) - pow(d3, 2) - pow(x2, 2) + pow(x3, 2) - pow(y2, 2) + pow(y3, 2);

  final x = (C * E - F * B) / (E * A - B * D);
  final y = (C * D - A * F) / (B * D - A * E);
  print(x.toString());
  print(y.toString());
  return Point(x, y);
}




