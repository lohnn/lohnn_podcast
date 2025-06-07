import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_core/providers/audio_player_provider.dart'; // Assuming this is where AudioPlayerPod is defined
import 'package:podcast_core/widgets/small_media_player/play_pause_button.dart';

// Mocks
class MockAudioPlayerNotifier extends Mock implements AudioPlayerPod {}

// Helper to create PlaybackState
PlaybackState createPlaybackState({
  bool playing = false,
  AudioProcessingState processingState = AudioProcessingState.ready,
  Duration position = Duration.zero,
  List<MediaControl> controls = const [
    MediaControl.play,
    MediaControl.pause,
  ], // Default controls
}) {
  return PlaybackState(
    controls: controls,
    processingState: processingState,
    playing: playing,
    updatePosition: position,
    bufferedPosition: Duration.zero,
    speed: 1.0,
    queueIndex: 0,
    repeatMode: AudioServiceRepeatMode.none,
    shuffleMode: AudioServiceShuffleMode.none,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAudioPlayerNotifier mockAudioPlayerNotifier;

  setUp(() {
    mockAudioPlayerNotifier = MockAudioPlayerNotifier();
    // Default stub for any call to triggerMediaAction
    when(
      () => mockAudioPlayerNotifier.triggerMediaAction(any()),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpWidget(WidgetTester tester, List<Override> overrides) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(home: Scaffold(body: PlayPauseButton())),
      ),
    );
    await tester.pumpAndSettle(); // Ensure UI is stable after initial pump
  }

  group('PlayPauseButton Accessibility Tests', () {
    testWidgets('shows play icon, is accessible, and handles tap', (
      WidgetTester tester,
    ) async {
      await pumpWidget(tester, [
        audioStateProvider.overrideWithValue(
          AsyncData(
            createPlaybackState(
              playing: false,
              processingState: AudioProcessingState.ready,
            ),
          ),
        ),
        audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
      ]);

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byTooltip('Play'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Accessibility Checks
      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Play',
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'Play Button State');

      await tester.tap(buttonFinder);
      verify(
        () => mockAudioPlayerNotifier.triggerMediaAction(MediaAction.playPause),
      ).called(1);
    });

    testWidgets('shows pause icon, is accessible, and handles tap', (
      WidgetTester tester,
    ) async {
      await pumpWidget(tester, [
        audioStateProvider.overrideWithValue(
          AsyncData(
            createPlaybackState(
              playing: true,
              processingState: AudioProcessingState.ready,
            ),
          ),
        ),
        audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
      ]);

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(Icons.pause), findsOneWidget);
      expect(find.byTooltip('Pause'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Accessibility Checks
      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Pause',
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'Pause Button State');

      await tester.tap(buttonFinder);
      verify(
        () => mockAudioPlayerNotifier.triggerMediaAction(MediaAction.playPause),
      ).called(1);
    });

    testWidgets('shows progress indicator when loading and is accessible', (
      WidgetTester tester,
    ) async {
      await pumpWidget(tester, [
        audioStateProvider.overrideWithValue(
          AsyncData(
            createPlaybackState(processingState: AudioProcessingState.loading),
          ),
        ),
        audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
      ]);

      final buttonFinder = find.byType(IconButton); // IconButton still exists, but is disabled
      expect(buttonFinder, findsOneWidget);
      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(progressIndicatorFinder, findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsNothing);
      expect(find.byIcon(Icons.pause), findsNothing);

      final iconButton = tester.widget<IconButton>(buttonFinder);
      expect(iconButton.onPressed, isNull);

      // Accessibility Checks
      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension)); // Visual size check
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(
        tester.getSemantics(buttonFinder), // Check semantics of the disabled button
        matchesSemantics(
          isEnabled: false,
          isButton: true, // Still a button, but disabled
          // No tap action when disabled
        ),
      );
      // CircularProgressIndicator by default is not excluded from semantics.
      // Screen readers might announce "progress indicator". This is generally acceptable.
      final indicatorSemantics = tester.getSemantics(progressIndicatorFinder);
      expect(indicatorSemantics.label, isEmpty); // Default has no label
      expect(indicatorSemantics.isFocusable, isFalse);
      await tester.testA11yGuidelines(label: 'Loading State');
    });

    testWidgets('shows progress indicator when buffering and is accessible', (
      WidgetTester tester,
    ) async {
      await pumpWidget(tester, [
        audioStateProvider.overrideWithValue(
          AsyncData(
            createPlaybackState(
              processingState: AudioProcessingState.buffering,
            ),
          ),
        ),
        audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
      ]);

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(progressIndicatorFinder, findsOneWidget);

      final iconButton = tester.widget<IconButton>(buttonFinder);
      expect(iconButton.onPressed, isNull);

      // Accessibility Checks
      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
       expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(isEnabled: false, isButton: true),
      );
      final indicatorSemantics = tester.getSemantics(progressIndicatorFinder);
      expect(indicatorSemantics.label, isEmpty);
      await tester.testA11yGuidelines(label: 'Buffering State');
    });

    testWidgets(
      'accessible when audioStateProvider is AsyncLoading',
      (WidgetTester tester) async {
        await pumpWidget(tester, [
          audioStateProvider.overrideWithValue(const AsyncLoading()),
          audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
        ]);

        final buttonFinder = find.byType(IconButton);
        expect(buttonFinder, findsOneWidget);
        final progressIndicatorFinder = find.byType(CircularProgressIndicator);
        expect(progressIndicatorFinder, findsOneWidget);
        final iconButton = tester.widget<IconButton>(buttonFinder);
        expect(iconButton.onPressed, isNull);

      // Accessibility Checks
      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
       expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(isEnabled: false, isButton: true),
      );
      final indicatorSemantics = tester.getSemantics(progressIndicatorFinder);
      expect(indicatorSemantics.label, isEmpty);
      await tester.testA11yGuidelines(label: 'Provider AsyncLoading State');
      },
    );

    testWidgets(
      'accessible when audioStateProvider is AsyncError',
      (WidgetTester tester) async {
        await pumpWidget(tester, [
          audioStateProvider.overrideWithValue(
            AsyncError('Test error', StackTrace.empty),
          ),
          audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
        ]);

        final buttonFinder = find.byType(IconButton);
        expect(buttonFinder, findsOneWidget);
        // Depending on implementation, might show an error icon or still a progress indicator
        // The current test expects CircularProgressIndicator.
        final progressIndicatorFinder = find.byType(CircularProgressIndicator);
        expect(progressIndicatorFinder, findsOneWidget);
        final iconButton = tester.widget<IconButton>(buttonFinder);
        expect(iconButton.onPressed, isNull);

      // Accessibility Checks
      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
       expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(isEnabled: false, isButton: true),
      );
      // If it's an error icon, it might have a specific error tooltip/label.
      // If it's still a progress indicator, its semantics would be similar to above.
      final indicatorSemantics = tester.getSemantics(progressIndicatorFinder);
      expect(indicatorSemantics.label, isEmpty); // Assuming it's still the default indicator
      await tester.testA11yGuidelines(label: 'Provider AsyncError State');
      },
    );
  });
}
