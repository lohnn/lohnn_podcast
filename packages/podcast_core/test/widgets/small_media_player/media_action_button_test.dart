import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:audio_service/audio_service.dart'; // For MediaAction
import 'package:podcast_core/providers/audio_player_provider.dart';
import 'package:podcast_core/widgets/small_media_player/media_action_button.dart';
import '../../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension etc.

// --- Mocks ---
class MockAudioPlayerPod extends Mock implements AudioPlayerPod {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAudioPlayerPod mockAudioPlayerPod;

  setUp(() {
    mockAudioPlayerPod = MockAudioPlayerPod();

    // Stub default behaviors for common actions.
    // Using any() for triggerMediaAction as the specific action will be verified by type in tests.
    when(() => mockAudioPlayerPod.triggerMediaAction(any())).thenAnswer((_) async {});
    when(() => mockAudioPlayerPod.fastForward()).thenAnswer((_) async {});
    when(() => mockAudioPlayerPod.rewind()).thenAnswer((_) async {});
    when(() => mockAudioPlayerPod.skipToNext()).thenAnswer((_) async {});
    when(() => mockAudioPlayerPod.skipToPrevious()).thenAnswer((_) async {});
  });

  Future<void> pumpMediaActionButton(
    WidgetTester tester, {
    required IconData iconData,
    required String tooltip,
    required VoidCallback onPressed,
    bool enabled = true, // To test disabled state
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // MediaActionButton itself doesn't directly use audioPlayerPodProvider in its build.
          // However, its onPressed callback usually does. So, providing it here
          // is good practice if the onPressed action needs to interact with it,
          // even if the widget itself doesn't rebuild based on provider changes.
          audioPlayerPodProvider.overrideWith((ref) => mockAudioPlayerPod),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MediaActionButton(
              icon: Icon(iconData),
              onPressed: enabled ? onPressed : null, // Pass null for onPressed to disable
              tooltip: tooltip,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('MediaActionButton Accessibility Tests', () {
    testWidgets('Fast Forward button: correct icon, tooltip, action, and meets a11y',
        (tester) async {
      const icon = Icons.fast_forward_rounded;
      const tooltip = 'Fast forward';
      final onPressed = () => mockAudioPlayerPod.fastForward();

      await pumpMediaActionButton(
        tester,
        iconData: icon,
        tooltip: tooltip,
        onPressed: onPressed,
      );

      final buttonFinder = find.byType(IconButton); // MediaActionButton wraps IconButton
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(icon), findsOneWidget);
      expect(find.byTooltip(tooltip), findsOneWidget);

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: tooltip,
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'Fast Forward Button');

      await tester.tap(buttonFinder);
      verify(() => mockAudioPlayerPod.fastForward()).called(1);
    });

    testWidgets('Rewind 10s button: correct icon, tooltip, action, and meets a11y',
        (tester) async {
      const icon = Icons.replay_10_rounded;
      const tooltip = 'Rewind 10 seconds';
      final onPressed = () => mockAudioPlayerPod.rewind(); // Assuming rewind handles the 10s logic

      await pumpMediaActionButton(
        tester,
        iconData: icon,
        tooltip: tooltip,
        onPressed: onPressed,
      );

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(icon), findsOneWidget);
      expect(find.byTooltip(tooltip), findsOneWidget);

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: tooltip,
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'Rewind 10s Button');

      await tester.tap(buttonFinder);
      verify(() => mockAudioPlayerPod.rewind()).called(1);
    });

    testWidgets('Skip to Next button: correct icon, tooltip, action, and meets a11y',
        (tester) async {
      const icon = Icons.skip_next_rounded;
      const tooltip = 'Skip to next';
      final onPressed = () => mockAudioPlayerPod.skipToNext();

      await pumpMediaActionButton(
        tester,
        iconData: icon,
        tooltip: tooltip,
        onPressed: onPressed,
      );

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(icon), findsOneWidget);
      expect(find.byTooltip(tooltip), findsOneWidget);

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: tooltip,
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'Skip to Next Button');

      await tester.tap(buttonFinder);
      verify(() => mockAudioPlayerPod.skipToNext()).called(1);
    });

    testWidgets('Disabled button: correct icon, tooltip, disabled state, and meets a11y',
        (tester) async {
      const icon = Icons.fast_forward_rounded;
      const tooltip = 'Fast forward';
      // onPressed is effectively null due to enabled: false
      final onPressed = () => fail("onPressed should not be called for a disabled button");

      await pumpMediaActionButton(
        tester,
        iconData: icon,
        tooltip: tooltip,
        onPressed: onPressed,
        enabled: false, // Explicitly disable
      );

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(icon), findsOneWidget);
      expect(find.byTooltip(tooltip), findsOneWidget); // Tooltip might still be found

      final iconButtonWidget = tester.widget<IconButton>(buttonFinder);
      expect(iconButtonWidget.onPressed, isNull); // Check it's actually disabled

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: tooltip, // Tooltip might persist
          isButton: true,
          isEnabled: false, // Key check for disabled state
          // hasTapAction should be false or absent for disabled buttons
        ),
      );
      await tester.testA11yGuidelines(label: 'Disabled MediaActionButton');

      // Attempt to tap and verify onPressed is not called
      await tester.tap(buttonFinder, warnIfMissed: false); // warnIfMissed: false as it's disabled
      // Verification of mockAudioPlayerPod.fastForward() not being called is implicit,
      // as it would fail if onPressed was called due to the fail() call.
    });
  });
}
