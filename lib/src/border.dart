import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'path.dart';

/// Rectangular border with smoother transitions between straight lines and curved
/// corners used on macOS and iOS.
///
/// See https://www.paintcodeapp.com/news/code-for-ios-7-rounded-rectangles
class CupertinoRectangleBorder extends OutlinedBorder {
  /// Creates a [CupertinoRectangleBorder].
  const CupertinoRectangleBorder({
    super.side,
    this.borderRadius = BorderRadius.zero,
  });

  /// The radius for each corner.
  ///
  /// Negative radius values are clamped to 0.0 by [getInnerPath] and
  /// [getOuterPath].
  final BorderRadiusGeometry borderRadius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) {
    return CupertinoRectangleBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is CupertinoRectangleBorder) {
      return CupertinoRectangleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is CupertinoRectangleBorder) {
      return CupertinoRectangleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  Path _getPath(RRect rrect) {
    return Path()
      ..addCupertinoRRect(rrect)
      ..close();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final RRect borderRect = borderRadius.resolve(textDirection).toRRect(rect);
    final RRect adjustedRect = borderRect.deflate(side.width);
    return _getPath(adjustedRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final RRect borderRect = borderRadius.resolve(textDirection).toRRect(rect);
    return _getPath(borderRect);
  }

  @override
  CupertinoRectangleBorder copyWith(
      {BorderSide? side, BorderRadiusGeometry? borderRadius}) {
    return CupertinoRectangleBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) {
      return;
    }
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final path = Path();
        path.fillType = PathFillType.evenOdd;
        path.addPath(
            getInnerPath(rect, textDirection: textDirection), Offset.zero);
        path.addPath(
            getOuterPath(rect, textDirection: textDirection), Offset.zero);
        path.close();
        canvas.drawPath(path, Paint()..color = side.color);
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CupertinoRectangleBorder &&
        other.side == side &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'CupertinoRectangleBorder')}($side, $borderRadius)';
  }
}
