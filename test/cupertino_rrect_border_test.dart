import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cupertino_rrect/cupertino_rrect.dart';

void main() {
  test('CupertinoRectangleBorder defaults', () {
    const border = CupertinoRectangleBorder();
    expect(border.side, BorderSide.none);
    expect(border.borderRadius, BorderRadius.zero);
  });

  test('CupertinoRectangleBorder copyWith, ==, hashCode', () {
    expect(const CupertinoRectangleBorder(),
        const CupertinoRectangleBorder().copyWith());
    expect(const CupertinoRectangleBorder().hashCode,
        const CupertinoRectangleBorder().copyWith().hashCode);
    const side = BorderSide(width: 10.0, color: Color(0xff123456));
    const radius = BorderRadius.all(Radius.circular(16.0));
    const directionalRadius =
        BorderRadiusDirectional.all(Radius.circular(16.0));

    expect(
      const CupertinoRectangleBorder()
          .copyWith(side: side, borderRadius: radius),
      const CupertinoRectangleBorder(side: side, borderRadius: radius),
    );

    expect(
      const CupertinoRectangleBorder()
          .copyWith(side: side, borderRadius: directionalRadius),
      const CupertinoRectangleBorder(
          side: side, borderRadius: directionalRadius),
    );
  });

  test('CupertinoRectangleBorder scale and lerp', () {
    const c10 = CupertinoRectangleBorder(
        side: BorderSide(width: 10.0),
        borderRadius: BorderRadius.all(Radius.circular(100.0)));
    const c15 = CupertinoRectangleBorder(
        side: BorderSide(width: 15.0),
        borderRadius: BorderRadius.all(Radius.circular(150.0)));
    const c20 = CupertinoRectangleBorder(
        side: BorderSide(width: 20.0),
        borderRadius: BorderRadius.all(Radius.circular(200.0)));
    expect(c10.dimensions, const EdgeInsets.all(10.0));
    expect(c10.scale(2.0), c20);
    expect(c20.scale(0.5), c10);
    expect(ShapeBorder.lerp(c10, c20, 0.0), c10);
    expect(ShapeBorder.lerp(c10, c20, 0.5), c15);
    expect(ShapeBorder.lerp(c10, c20, 1.0), c20);
  });

  test('CupertinoRectangleBorder BorderRadius.zero', () {
    const Rect rect1 = Rect.fromLTRB(10.0, 20.0, 30.0, 40.0);
    final Matcher looksLikeRect1 = isPathThat(
      includes: const <Offset>[Offset(10.0, 20.0), Offset(20.0, 30.0)],
      excludes: const <Offset>[Offset(9.0, 19.0), Offset(31.0, 41.0)],
    );

    // Default border radius and border side are zero, i.e. just a rectangle.
    expect(
        const CupertinoRectangleBorder().getOuterPath(rect1), looksLikeRect1);
    expect(
        const CupertinoRectangleBorder().getInnerPath(rect1), looksLikeRect1);

    // Represents the inner path when borderSide.width = 4, which is just rect1
    // inset by 4 on all sides.
    final Matcher looksLikeInnerPath = isPathThat(
      includes: const <Offset>[Offset(14.0, 24.0), Offset(16.0, 26.0)],
      excludes: const <Offset>[Offset(9.0, 23.0), Offset(27.0, 37.0)],
    );

    const side = BorderSide(width: 4.0);
    expect(const CupertinoRectangleBorder(side: side).getOuterPath(rect1),
        looksLikeRect1);
    expect(const CupertinoRectangleBorder(side: side).getInnerPath(rect1),
        looksLikeInnerPath);
  });

  test('CupertinoRectangleBorder non-zero BorderRadius', () {
    const Rect rect = Rect.fromLTRB(10.0, 20.0, 30.0, 40.0);
    final Matcher looksLikeRect = isPathThat(
      includes: const <Offset>[Offset(15.0, 25.0), Offset(20.0, 30.0)],
      excludes: const <Offset>[Offset(10.0, 20.0), Offset(30.0, 40.0)],
    );
    const border = CupertinoRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    );
    expect(border.getOuterPath(rect), looksLikeRect);
    expect(border.getInnerPath(rect), looksLikeRect);
  });

  test('CupertinoRectangleBorder non-zero BorderRadiusDirectional', () {
    const Rect rect = Rect.fromLTRB(10.0, 20.0, 30.0, 40.0);
    final Matcher looksLikeRectLtr = isPathThat(
      includes: const <Offset>[Offset(15.0, 25.0), Offset(20.0, 30.0)],
      excludes: const <Offset>[Offset(10.0, 20.0), Offset(10.0, 40.0)],
    );
    const border = CupertinoRectangleBorder(
      borderRadius: BorderRadiusDirectional.only(
        topStart: Radius.circular(5.0),
        bottomStart: Radius.circular(5.0),
      ),
    );

    expect(border.getOuterPath(rect, textDirection: TextDirection.ltr),
        looksLikeRectLtr);
    expect(border.getInnerPath(rect, textDirection: TextDirection.ltr),
        looksLikeRectLtr);

    final Matcher looksLikeRectRtl = isPathThat(
      includes: const <Offset>[Offset(25.0, 35.0), Offset(25.0, 25.0)],
      excludes: const <Offset>[Offset(30.0, 20.0), Offset(30.0, 40.0)],
    );

    expect(border.getOuterPath(rect, textDirection: TextDirection.rtl),
        looksLikeRectRtl);
    expect(border.getInnerPath(rect, textDirection: TextDirection.rtl),
        looksLikeRectRtl);
  });

  testWidgets('Golden test even radii', (WidgetTester tester) async {
    await tester.pumpWidget(RepaintBoundary(
      child: Material(
        color: Colors.blueAccent[400],
        shape: const CupertinoRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28.0)),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(RepaintBoundary),
      matchesGoldenFile(
          'cupertino_rectangle_border.golden_test_even_radii.png'),
    );
  });

  testWidgets('Golden test varying radii', (WidgetTester tester) async {
    await tester.pumpWidget(RepaintBoundary(
      child: Material(
        color: Colors.green[100],
        shape: const CupertinoRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(100.0, 200.0),
            topRight: Radius.circular(350.0),
            bottomLeft: Radius.elliptical(2000.0, 100.0),
            bottomRight: Radius.circular(700.0),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(RepaintBoundary),
      matchesGoldenFile(
          'cupertino_rectangle_border.golden_test_varying_radii.png'),
    );
  });

  testWidgets('Golden test topLeft radii', (WidgetTester tester) async {
    await tester.pumpWidget(RepaintBoundary(
      child: Material(
        color: Colors.green[200],
        shape: const CupertinoRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(100.0, 200.0),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(RepaintBoundary),
      matchesGoldenFile(
          'cupertino_rectangle_border.golden_test_topLeft_radii.png'),
    );
  });

  testWidgets('Golden test topRight radii', (WidgetTester tester) async {
    await tester.pumpWidget(RepaintBoundary(
      child: Material(
        color: Colors.green[300],
        shape: const CupertinoRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(350.0),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(RepaintBoundary),
      matchesGoldenFile(
          'cupertino_rectangle_border.golden_test_topRight_radii.png'),
    );
  });

  testWidgets('Golden test bottomLeft radii', (WidgetTester tester) async {
    await tester.pumpWidget(RepaintBoundary(
      child: Material(
        color: Colors.green[400],
        shape: const CupertinoRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(2000.0, 100.0),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(RepaintBoundary),
      matchesGoldenFile(
          'cupertino_rectangle_border.golden_test_bottomLeft_radii.png'),
    );
  });

  testWidgets('Golden test bottomRight radii', (WidgetTester tester) async {
    await tester.pumpWidget(RepaintBoundary(
      child: Material(
        color: Colors.green[500],
        shape: const CupertinoRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(700.0),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(RepaintBoundary),
      matchesGoldenFile(
          'cupertino_rectangle_border.golden_test_bottomRight_radii.png'),
    );
  });

  testWidgets('Golden test large radii', (WidgetTester tester) async {
    await tester.pumpWidget(RepaintBoundary(
      child: Material(
        color: Colors.redAccent[400],
        shape: const CupertinoRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(RepaintBoundary),
      matchesGoldenFile(
          'cupertino_rectangle_border.golden_test_large_radii.png'),
    );
  });
}
