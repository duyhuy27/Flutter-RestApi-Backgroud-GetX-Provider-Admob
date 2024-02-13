import 'package:flutter/material.dart';

class ChartDataCandle {
  final DateTime? x;
  final double o;
  final double h;
  final double l;
  final double c;

  ChartDataCandle(this.x, this.o, this.h, this.l, this.c);
}
