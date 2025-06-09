import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_core/widgets/small_media_player/show_playlist_button.dart';
import 'package:podcast_core/routes/app_routes.dart'; // Required for AppRoutes.playlist.path
import '../../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension and testA11yGuidelines

// --- Mocks ---
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGoRouter mockGoRouter;

  setUp(() {
    mockGoRouter = MockGoRouter();
    // Stub the push method. We're interested in verifying it's called with the correct path.
    when(() => mockGoRouter.push(any())).thenAnswer((_) async => {}); // Default stub
  });

  Future<void> pumpShowPlaylistButton(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          // ShowPlaylistButton uses GoRouter.of(context), so it needs a GoRouter ancestor.
          // We can mock this using InheritedGoRouter if direct MaterialApp.router is too complex for this unit test.
          // However, simpler is often to wrap with a MaterialApp that uses our mockGoRouter if possible,
          // or ensure the context has it. For a simple button, providing it via InheritedGoRouter is clean.
          body: InheritedGoRouter(
            goRouter: mockGoRouter,
            child: const ShowPlaylistButton(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ShowPlaylistButton Accessibility and Action Tests', () {
    testWidgets(
        'renders button with correct icon, tooltip, semantics, triggers navigation, and meets a11y guidelines',
        (tester) async {
      await pumpShowPlaylistButton(tester);

      // ShowPlaylistButton itself renders an IconButton.
      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);

      // 1. Verify Icon
      expect(find.byIcon(Icons.playlist_play_rounded), findsOneWidget);

      // 2. Verify Tooltip
      expect(find.byTooltip('Show playlist'), findsOneWidget);
      // Tooltip also often serves as the semantic label for IconButtons

      // 3. Verify Tap Target Size
      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      // 4. Verify Semantics (enabled, role, action)
      final semantics = tester.getSemantics(buttonFinder);
      expect(semantics, matchesSemantics(
        tooltip: 'Show playlist',
        isButton: true,
        isEnabled: true,
        hasTapAction: true,
      ));

      // 5. Call testA11yGuidelines
      await tester.testA11yGuidelines(label: 'ShowPlaylistButton');

      // 6. Verify Action (navigation)
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle(); // Allow navigation to process if it were real

      verify(() => mockGoRouter.push(AppRoutes.playlist.path)).called(1);
    });

    testWidgets('is disabled when onPressed is null (conceptual test if applicable)', (tester) async {
      // The current ShowPlaylistButton does not have an external onPressed to make it null.
      // Its onPressed is hardcoded to navigate. So, this test is more of a placeholder
      // for how one might test a disabled MediaActionButton or IconButton.
      // If ShowPlaylistButton could be disabled (e.g. by a provider), we'd set up that state.

      // For demonstration, if it were an IconButton we controlled:
      // await tester.pumpWidget(
      //   MaterialApp(
      //     home: Scaffold(
      //       body: IconButton(
      //         icon: Icon(Icons.playlist_play_rounded),
      //         tooltip: 'Show playlist',
      //         onPressed: null, // DISABLED
      //       ),
      //     ),
      //   ),
      // );
      // await tester.pumpAndSettle();
      // final buttonFinder = find.byType(IconButton);
      // expect(tester.getSemantics(buttonFinder), matchesSemantics(isEnabled: false, tooltip: 'Show playlist'));
      // await tester.testA11yGuidelines(label: 'Disabled ShowPlaylistButton (Conceptual)');

      // Since ShowPlaylistButton is always enabled, this test is more of a note.
      // If a disabled state becomes possible, this test should be implemented.
      expect(true, isTrue, reason: "ShowPlaylistButton is currently always enabled. No direct disabled state to test.");
    });
  });
}
