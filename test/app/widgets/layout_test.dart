import 'package:flutter/material.dart';
import 'package:flutter_template/app/widgets/layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(LayoutData, () {
    test('derives correct layout from size', () {
      expect(LayoutData.derive(const Size(300, 800)), equals(LayoutData.small));
      expect(
        LayoutData.derive(const Size(640, 800)),
        equals(LayoutData.medium),
      );
      expect(LayoutData.derive(const Size(768, 800)), equals(LayoutData.large));
      expect(
        LayoutData.derive(const Size(1024, 800)),
        equals(LayoutData.xlarge),
      );
    });

    test('comparison operators work correctly', () {
      expect(LayoutData.small < LayoutData.medium, isTrue);
      expect(LayoutData.large >= LayoutData.medium, isTrue);
      expect(LayoutData.xlarge > LayoutData.large, isTrue);
      expect(LayoutData.small <= LayoutData.small, isTrue);
    });
  });

  group(Layout, () {
    testWidgets('provides derived $LayoutData via context extension', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      late LayoutData layout;
      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            child: Builder(
              builder: (context) {
                layout = context.layout;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(layout, equals(LayoutData.small));
    });

    testWidgets('provides fixed $LayoutData when passed explicitly', (
      tester,
    ) async {
      late LayoutData layout;
      await tester.pumpWidget(
        Layout(
          data: LayoutData.xlarge,
          child: Builder(
            builder: (context) {
              layout = context.layout;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(layout, equals(LayoutData.xlarge));
    });

    testWidgets('updates descendants when screen size changes in $Layout', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      var builds = 0;
      late LayoutData layout;

      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            child: Builder(
              builder: (context) {
                builds++;
                layout = context.layout;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(layout, equals(LayoutData.small));
      expect(builds, equals(1));

      tester.view.physicalSize = const Size(800, 800);
      await tester.pump();

      expect(layout, equals(LayoutData.large));
      expect(builds, equals(2));
    });

    testWidgets('context predicates return correct values in $Layout', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            child: Builder(
              builder: (context) {
                expect(context.isMobile, isFalse);
                expect(context.isTablet, isFalse);
                expect(context.isDesktop, isTrue);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}
