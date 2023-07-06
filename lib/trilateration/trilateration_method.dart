import 'dart:math';

import 'package:matrix2d/matrix2d.dart';

class Point{
  final double x;
  final double y;

  Point(this.x, this.y);
}

/*Point trilaterationMethod(List<double> centerX, List<double> centerY, List<num> radiusList ){
  final d1 = radiusList[0];
  final d2 = radiusList[1];
  final d3 = radiusList[2];

  final x1 = centerX[0];
  final x2 = centerX[1];
  final x3 = centerX[2];

  final y1 = centerY[0];
  final y2 = centerY[1];
  final y3 = centerY[2];

  final A = 2*x2 - 2*x1;
  final B = 2*y2 - 2*y1;
  final C = pow(d1, 2) - pow(d2, 2) - pow(x1, 2) + pow(x2, 2) - pow(y1, 2) + pow(y2, 2);
  final D = 2 * x3 - 2 * x2;
  final E = 2 * y3 - 2 * y2;
  final F = pow(d2, 2) - pow(d3, 2) - pow(x2, 2) + pow(x3, 2) - pow(y2, 2) + pow(y3, 2);

  var x = (C * E - F * B) / (E * A - B * D);
  var y = (C * D - A * F) / (B * D - A * E);

  return Point(x, y);
}*/


Point trilaterationMethod(List<double> centerX, List<double> centerY, List<num> radiusList) {
    final p1 = Point(centerX[0], centerY[0]);
    final p2 = Point(centerX[1], centerY[1]);
    final p3 = Point(centerX[2], centerY[2]);

    final d1 = radiusList[0];
    final d2 = radiusList[1];
    final d3 = radiusList[2];

    final ex = Point((p2.x - p1.x) / d1, (p2.y - p1.y) / d1);
    final i = (p3.x - p1.x) * ex.x + (p3.y - p1.y) * ex.y;
    final ey = Point((p3.x - p1.x - i * ex.x) / sqrt(pow(p3.x - p1.x - i * ex.x, 2) + pow(p3.y - p1.y - i * ex.y, 2)),
        (p3.y - p1.y - i * ex.y) / sqrt(pow(p3.x - p1.x - i * ex.x, 2) + pow(p3.y - p1.y - i * ex.y, 2)));
    final ez = Point(0, 0);

    final d = sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
    final j = (d2 * d2 - d1 * d1 + d * d) / (2 * d);
    final x = p1.x + ex.x * j;
    final y = p1.y + ex.y * j;

    final h = sqrt(pow(d2, 2) - pow(x - p2.x, 2) - pow(y - p2.y, 2));
    final rx = -(ey.x * h);
    final ry = -(ey.y * h);

    final result = Point((x - rx),(y - ry));
    print((x - rx).toString());
    print((y - ry).toString());
    return result;
  }



