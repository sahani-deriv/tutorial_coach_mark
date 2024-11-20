import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/src/clipper/rect_clipper.dart';
import 'package:tutorial_coach_mark/src/target/target_position.dart';

class DottedRectClipper extends CustomClipper<Path> {
  final double progress;
  final TargetPosition target;
  final double offset;
  final double dashWidth; // Width of each dash
  final double dashSpace; // Space between dashes

  DottedRectClipper({
    required this.progress,
    required this.target,
    required this.offset,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  Path getClip(Size size) {
    if (target.offset == Offset.zero) return Path();

    var maxSize = max(size.width, size.height) +
        max(target.size.width, target.size.height) +
        target.getBiggerSpaceBorder(size);

    double x = -maxSize / 2 * (1 - progress) + target.offset.dx - offset / 2;
    double y = -maxSize / 2 * (1 - progress) + target.offset.dy - offset / 2;
    double w = maxSize * (1 - progress) + target.size.width + offset;
    double h = maxSize * (1 - progress) + target.size.height + offset;

    return dottedRectPath(size, x, y, w, h);
  }

  @override
  bool shouldReclip(covariant RectClipper oldClipper) {
    return progress != oldClipper.progress;
  }

  Path dottedRectPath(Size canvasSize, double x, double y, double w, double h) {
    Path path = Path();

    // Draw top edge
    _drawDottedLine(path, Offset(x, y), Offset(x + w, y));

    // Draw right edge
    _drawDottedLine(path, Offset(x + w, y), Offset(x + w, y + h));

    // Draw bottom edge
    _drawDottedLine(path, Offset(x + w, y + h), Offset(x, y + h));

    // Draw left edge
    _drawDottedLine(path, Offset(x, y + h), Offset(x, y));

    return path;
  }

  void _drawDottedLine(Path path, Offset start, Offset end) {
    double distance = (end - start).distance;
    double dx = (end.dx - start.dx) / distance;
    double dy = (end.dy - start.dy) / distance;

    for (double i = 0; i < distance; i += dashWidth + dashSpace) {
      path.moveTo(start.dx + dx * i, start.dy + dy * i);
      path.lineTo(
          start.dx + dx * (i + dashWidth), start.dy + dy * (i + dashWidth));
    }
  }
}
