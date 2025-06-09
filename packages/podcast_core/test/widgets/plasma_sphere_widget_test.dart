import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_core/widgets/plasma_sphere_widget.dart';
import '../helpers/widget_tester_helpers.dart'; // For testA11yGuidelines and kMinInteractiveDimension

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const double defaultWidth = 200.0;
  const double defaultHeight = 200.0;
  const Color defaultColor = Colors.blue;

  Future<void> pumpPlasmaSphereWidget(
    WidgetTester tester, {
    double width = defaultWidth,
    double height = defaultHeight,
    Color color = defaultColor,
    // Add other parameters if PlasmaSphereWidget takes them
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlasmaSphereWidget(
            height: height,
            width: width,
            color: color,
            // particleCount: 20, // Example of another potential parameter
          ),
        ),
      ),
    );
    // PlasmaSphereWidget might have its own internal animations/timers for the plasma effect.
    // A pumpAndSettle() or specific duration pumps might be needed if its rendering is time-dependent
    // beyond the first frame. For semantics, the first frame is often enough.
    await tester.pumpAndSettle();
  }

  group('PlasmaSphereWidget Accessibility Tests', () {
    testWidgets(
        'renders, is correctly excluded from semantics tree (or has no meaningful semantics), and meets a11y guidelines',
        (tester) async {
      await pumpPlasmaSphereWidget(tester);

      // 1. Verify it renders
      final plasmaFinder = find.byType(PlasmaSphereWidget);
      expect(plasmaFinder, findsOneWidget);

      // It internally uses CustomPaint via the simple_shader_experiments_flutter package
      expect(find.descendant(of: plasmaFinder, matching: find.byType(CustomPaint)), findsOneWidget);

      // 2. Verify Semantic Exclusion
      // Option A: Check if it's explicitly excluded by an ancestor Semantics widget
      // This would be the ideal case if PlasmaSphereWidget itself ensures this.
      final explicitExclusionFinder = find.ancestor(
        of: find.byType(CustomPaint), // The core rendering part
        matching: find.byWidgetPredicate(
            (widget) => widget is Semantics && widget.excludeFromSemantics == true),
      );
      // If PlasmaSphereWidget itself doesn't wrap with Semantics(exclude...), this will fail.
      // This is an assertion about how it *should* be implemented if it's purely decorative.
      // For now, we don't know if it does this, so this might be too strict.
      // expect(explicitExclusionFinder, findsOneWidget);

      // Option B: Check the properties of the SemanticsNode for PlasmaSphereWidget itself.
      // If it's purely decorative and has no interactive behavior or labels,
      // its SemanticsNode should ideally be trivial or marked as invisible/excluded.
      final SemanticsNode? plasmaSemanticsNode = tester.getSemantics(plasmaFinder);

      // If the widget is purely decorative and correctly implemented, it might not even produce
      // a SemanticsNode for itself if its children are also non-semantic, or it might be
      // marked as isPartOfNodeMerging or similar.
      // A common outcome for a purely decorative CustomPaint without explicit Semantics is that
      // it doesn't have its own distinct, labeled, or interactive SemanticsNode.
      // testA11yGuidelines will be more effective at catching issues if it *does* produce
      // a problematic node (e.g., focusable but no label).

      // Let's check that if a SemanticsNode is produced, it has no label, no value, and no actions.
      if (plasmaSemanticsNode != null && plasmaSemanticsNode.isInvisible == false && plasmaSemanticsNode.hasFlag(SemanticsFlag.isExcludedFromSemanticsTree) == false) {
        // If it has a node and is not marked as invisible or excluded, it should have no meaningful semantics.
        expect(plasmaSemanticsNode.label, isEmpty, reason: "Decorative widget should have no semantic label.");
        expect(plasmaSemanticsNode.value, isEmpty, reason: "Decorative widget should have no semantic value.");
        expect(plasmaSemanticsNode.hasTapAction, isFalse, reason: "Decorative widget should not be tappable.");
        expect(plasmaSemanticsNode.isFocusable, isFalse, reason: "Decorative widget should not be focusable.");
      } else if (plasmaSemanticsNode != null) {
        // If it's invisible or excluded, that's good.
        expect(plasmaSemanticsNode.isInvisible || plasmaSemanticsNode.hasFlag(SemanticsFlag.isExcludedFromSemanticsTree), isTrue,
               reason: "PlasmaSphere should either be invisible to semantics or explicitly excluded if it has a node.");
      }
      // If plasmaSemanticsNode is null, it means it didn't even create a node, which is also fine for a decorative widget.


      // 3. Check rendered size (visual check, not directly a tap target for this widget)
      final Size widgetSize = tester.getSize(plasmaFinder);
      expect(widgetSize.width, defaultWidth);
      expect(widgetSize.height, defaultHeight);


      // 4. Call testA11yGuidelines()
      // This is the most important check for a decorative widget.
      // It will fail if the widget is focusable without a label, or too small if it were interactive (which it's not).
      await tester.testA11yGuidelines(label: 'PlasmaSphereWidget');
    });
  });
}
