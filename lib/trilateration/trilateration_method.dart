import 'dart:math';

import 'package:matrix2d/matrix2d.dart';

class Point{
    final double x;
    final double y;

    Point(this.x, this.y);
}

Point trilaterationMethod(var centerX, var centerY, var radiusList) {
    var matrixA = [];
    var matrixB = [];
    const Matrix2d m2d = Matrix2d();

    for (int idx = 1; idx <= centerX.length - 1; idx++) {
        matrixA.add([
            centerX[idx] - centerX[0],
            centerY[idx] - centerY[0]
        ]);
        matrixB.add([
            ((pow(centerX[idx], 2) + pow(centerY[idx], 2) - pow(radiusList[idx] > 8.0 ? 8.0 : radiusList[idx], 2)) -
                (pow(centerX[0], 2) + pow(centerY[0], 2) - pow(radiusList[0] > 8.0 ? 8.0 : radiusList[0], 2))) / 2
        ]);
    }
    var matrixATranspose = transposeDouble(matrixA);
    var matrixInverse = dim2InverseMatrix(m2d.dot(matrixATranspose, matrixA));
    var matrixDot = m2d.dot(matrixInverse, matrixATranspose);
    var position = m2d.dot(matrixDot, matrixB);
    return Point(position[0][0], position[1][0]);
}

List transposeDouble(List list) {
    var shape = list.shape;
    var temp = List.filled(shape[1], 0.0)
        .map((e) => List.filled(shape[0], 0.0))
        .toList();
    for (var i = 0; i < shape[1]; i++) {
        for (var j = 0; j < shape[0]; j++) {
            temp[i][j] = list[j][i];
        }
    }
    return temp;
}

List dim2InverseMatrix(List list) {
    var shape = list.shape;
    var temp = List.filled(shape[1], 0.0)
        .map((e) => List.filled(shape[0], 0.0))
        .toList();
    var determinant = list[0][0] * list[1][1] - list[1][0] * list[0][1];
    temp[0][0] = list[1][1] / determinant;
    temp[0][1] = -list[0][1] / determinant;
    temp[1][0] = -list[1][0] / determinant;
    temp[1][1] = list[0][0] / determinant;
    return temp;
}

