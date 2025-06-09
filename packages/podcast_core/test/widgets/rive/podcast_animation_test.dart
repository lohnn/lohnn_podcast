import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'package:podcast_core/widgets/rive/podcast_animation.dart';
import '../../helpers/widget_tester_helpers.dart'; // For testA11yGuidelines

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // If Rive animations cause known, non-critical overflow errors in tests,
  // you might need a custom FlutterError.onError handler for specific tests.
  // Example:
  // final originalOnError = FlutterError.onError;
  // setUpAll(() {
  //   FlutterError.onError = (FlutterErrorDetails details) {
  //     if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
  //       // Optionally print or log, but don't fail the test for this specific error.
  //       return;
  //     }
  //     originalOnError?.call(details);
  //   };
  // });
  // tearDownAll(() {
  //   FlutterError.onError = originalOnError;
  // });


  Future<void> pumpPodcastAnimation(
    WidgetTester tester, {
    double width = 200,
    double height = 200,
    BoxFit fit = BoxFit.contain,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PodcastAnimation(
            width: width,
            height: height,
            fit: fit,
          ),
        ),
      ),
    );
    // Rive animations can take a moment to initialize their artboards and start playing.
    // pumpAndSettle will wait for animations to complete.
    // For just checking initial render and semantics, a few pumps might be enough if settle times out.
    await tester.pumpAndSettle();
  }

  group('PodcastAnimation Accessibility Tests', () {
    testWidgets(
        'renders RiveAnimation and is correctly excluded from semantics tree (or has no meaningful semantics), and meets a11y guidelines',
        (tester) async {
      // This test assumes that the Rive asset ('assets/rive/podcast_animation.riv')
      // is correctly declared in pubspec.yaml and available in the test environment.
      // If not, RiveAnimation widget might fail to load its artboard.

      await pumpPodcastAnimation(tester);

      // 1. Verify it renders the RiveAnimation widget
      final riveAnimationFinder = find.byType(RiveAnimation);
      expect(riveAnimationFinder, findsOneWidget, reason: "RiveAnimation widget should be rendered by PodcastAnimation.");

      // 2. Verify Semantic Exclusion for PodcastAnimation or its RiveAnimation child
      // The PodcastAnimation widget itself is a simple wrapper (StatelessWidget).
      // The RiveAnimation widget is what actually renders.
      // By default, RiveAnimation might not be focusable and might not have specific labels unless provided.
      // We want to ensure it's treated as decorative.

      final podcastAnimationWidgetFinder = find.byType(PodcastAnimation);
      final SemanticsNode? podcastAnimationSemanticsNode = tester.getSemantics(podcastAnimationWidgetFinder);

      if (podcastAnimationSemanticsNode != null &&
          !podcastAnimationSemanticsNode.isInvisible &&
          !podcastAnimationSemanticsNode.hasFlag(SemanticsFlag.isExcludedFromSemanticsTree)) {
        // If the wrapper itself has a node and it's not invisible/excluded, it should be trivial
        expect(podcastAnimationSemanticsNode.label, isEmpty, reason: "PodcastAnimation wrapper should have no semantic label if it has a node.");
        expect(podcastAnimationSemanticsNode.value, isEmpty, reason: "PodcastAnimation wrapper should have no semantic value.");
        expect(podcastAnimationSemanticsNode.hasTapAction, isFalse, reason: "PodcastAnimation wrapper should not be tappable.");
        expect(podcastAnimationSemanticsNode.isFocusable, isFalse, reason: "PodcastAnimation wrapper should not be focusable.");
      }
      // More importantly, check the RiveAnimation child if the parent is too simple or merged.
      final SemanticsNode? riveSemanticsNode = tester.getSemantics(riveAnimationFinder);
       if (riveSemanticsNode != null &&
          !riveSemanticsNode.isInvisible &&
          !riveSemanticsNode.hasFlag(SemanticsFlag.isExcludedFromSemanticsTree)) {
        expect(riveSemanticsNode.label, isEmpty, reason: "RiveAnimation should have no semantic label if decorative.");
        expect(riveSemanticsNode.value, isEmpty, reason: "RiveAnimation should have no semantic value.");
        expect(riveSemanticsNode.hasTapAction, isFalse, reason: "RiveAnimation should not be tappable if decorative.");
        // Rive widget itself might be focusable by default depending on its implementation,
        // testA11yGuidelines will catch if it's focusable without a label.
        // For a purely decorative item, isFocusable should be false.
        // If the Rive widget *is* focusable by default and not labeled, testA11yGuidelines should complain.
        // If it is focusable but labeled by Rive internally (e.g. "Animation"), that's a Rive package detail.
        // Our goal is that PodcastAnimation doesn't *add* problematic semantics.
         expect(riveSemanticsNode.isFocusable, isFalse, reason: "Decorative RiveAnimation should ideally not be focusable.");
      }


      // 3. Call testA11yGuidelines()
      // This will catch issues like:
      // - If the RiveAnimation is somehow focusable but has no label.
      // - If it's too small (though less relevant for a decorative background).
      // - Contrast issues (though less likely for an animation, more for text on it).
      await tester.testA11yGuidelines(label: 'PodcastAnimation');
    });
  });
}
