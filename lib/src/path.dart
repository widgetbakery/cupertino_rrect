import 'dart:ui';
import 'dart:math' as math;

enum Edge {
  top,
  right,
  bottom,
  left,
}

extension EdgeExt on Edge {
  bool get isHorizontal => this == Edge.top || this == Edge.bottom;
  bool get isVertical => this == Edge.left || this == Edge.right;
}

void _defaultLineCallback(Path path, Offset from, Offset to, Edge edge) {
  path.lineTo(to.dx, to.dy);
}

typedef LineCallback = void Function(
    Path path, Offset from, Offset to, Edge edge);

extension AddCupertinoRRect on Path {
  /// Adds rounded rectangle with Squircle corners used in macOS and iOS.
  /// https://www.paintcodeapp.com/news/code-for-ios-7-rounded-rectangles
  void addCupertinoRRect(
    RRect rrect, {
    /// Allows customizing how lines are added to the path. This can be useful
    /// for adding popover call-outs or other decorations.
    LineCallback lineCallback = _defaultLineCallback,
  }) {
    final limit = math.min(rrect.width, rrect.height) / 1.8 / 1.52866483;
    double limitedRadius(double radius) => math.min(radius, limit);

    Offset topLeft(double x, double y) => Offset(
          rrect.left + x * limitedRadius(rrect.tlRadiusX),
          rrect.top + y * limitedRadius(rrect.tlRadiusY),
        );
    Offset topRight(double x, double y) => Offset(
          rrect.right - x * limitedRadius(rrect.trRadiusX),
          rrect.top + y * limitedRadius(rrect.trRadiusY),
        );
    Offset bottomRight(double x, double y) => Offset(
          rrect.right - x * limitedRadius(rrect.brRadiusX),
          rrect.bottom - y * limitedRadius(rrect.brRadiusY),
        );
    Offset bottomLeft(double x, double y) => Offset(
          rrect.left + x * limitedRadius(rrect.blRadiusX),
          rrect.bottom - y * limitedRadius(rrect.blRadiusY),
        );

    var currentOffset = Offset.zero;

    void moveToPoint(Offset point) {
      moveTo(point.dx, point.dy);
      currentOffset = point;
    }

    void addLineToPoint(Offset point, [Edge? edge]) {
      if (edge != null) {
        lineCallback(this, currentOffset, point, edge);
      } else {
        lineTo(point.dx, point.dy);
      }
      currentOffset = point;
    }

    void addCurveToPoint(
      Offset destination, {
      required Offset controlPoint1,
      required Offset controlPoint2,
    }) {
      cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        destination.dx,
        destination.dy,
      );
      currentOffset = destination;
    }

    moveToPoint(topLeft(1.52866483, 0.00000000));
    addLineToPoint(topRight(1.52866471, 0.00000000), Edge.top);
    if (rrect.trRadius != Radius.zero) {
      addCurveToPoint(topRight(0.66993427, 0.06549600),
          controlPoint1: topRight(1.08849323, 0.00000000),
          controlPoint2: topRight(0.86840689, 0.00000000));
      addLineToPoint(topRight(0.63149399, 0.07491100));
      addCurveToPoint(topRight(0.07491176, 0.63149399),
          controlPoint1: topRight(0.37282392, 0.16905899),
          controlPoint2: topRight(0.16906013, 0.37282401));
      addCurveToPoint(topRight(0.00000000, 1.52866483),
          controlPoint1: topRight(0.00000000, 0.86840701),
          controlPoint2: topRight(0.00000000, 1.08849299));
    }
    addLineToPoint(bottomRight(0.00000000, 1.52866471), Edge.right);
    if (rrect.brRadius != Radius.zero) {
      addCurveToPoint(bottomRight(0.06549569, 0.66993493),
          controlPoint1: bottomRight(0.00000000, 1.08849323),
          controlPoint2: bottomRight(0.00000000, 0.86840689));
      addLineToPoint(bottomRight(0.07491111, 0.63149399));
      addCurveToPoint(bottomRight(0.63149399, 0.07491111),
          controlPoint1: bottomRight(0.16905883, 0.37282392),
          controlPoint2: bottomRight(0.37282392, 0.16905883));
      addCurveToPoint(bottomRight(1.52866471, 0.00000000),
          controlPoint1: bottomRight(0.86840689, 0.00000000),
          controlPoint2: bottomRight(1.08849323, 0.00000000));
    }
    addLineToPoint(bottomLeft(1.52866483, 0.00000000), Edge.bottom);
    if (rrect.blRadius != Radius.zero) {
      addCurveToPoint(bottomLeft(0.66993397, 0.06549569),
          controlPoint1: bottomLeft(1.08849299, 0.00000000),
          controlPoint2: bottomLeft(0.86840701, 0.00000000));
      addLineToPoint(bottomLeft(0.63149399, 0.07491111));
      addCurveToPoint(bottomLeft(0.07491100, 0.63149399),
          controlPoint1: bottomLeft(0.37282401, 0.16905883),
          controlPoint2: bottomLeft(0.16906001, 0.37282392));
      addCurveToPoint(bottomLeft(0.00000000, 1.52866471),
          controlPoint1: bottomLeft(0.00000000, 0.86840689),
          controlPoint2: bottomLeft(0.00000000, 1.08849323));
    }
    addLineToPoint(topLeft(0.00000000, 1.52866483), Edge.left);
    if (rrect.tlRadius != Radius.zero) {
      addCurveToPoint(topLeft(0.06549600, 0.66993397),
          controlPoint1: topLeft(0.00000000, 1.08849299),
          controlPoint2: topLeft(0.00000000, 0.86840701));
      addLineToPoint(topLeft(0.07491100, 0.63149399));
      addCurveToPoint(topLeft(0.63149399, 0.07491100),
          controlPoint1: topLeft(0.16906001, 0.37282401),
          controlPoint2: topLeft(0.37282401, 0.16906001));
      addCurveToPoint(topLeft(1.52866483, 0.00000000),
          controlPoint1: topLeft(0.86840701, 0.00000000),
          controlPoint2: topLeft(1.08849299, 0.00000000));
    }
  }
}
