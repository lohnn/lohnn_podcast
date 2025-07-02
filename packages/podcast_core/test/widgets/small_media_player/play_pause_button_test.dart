import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';
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
  }

  group('PlayPauseButton Tests', () {
    testWidgets('shows play icon when paused and ready', (
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
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byTooltip('Play'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byIcon(Icons.play_arrow));
      verify(
        () => mockAudioPlayerNotifier.triggerMediaAction(MediaAction.playPause),
      ).called(1);
    });

    // testWidgets('shows pause icon when playing and ready', (
    //   WidgetTester tester,
    // ) async {
    //   await pumpWidget(tester, [
    //     audioStateProvider.overrideWithValue(
    //       AsyncData(
    //         createPlaybackState(
    //           playing: true,
    //           processingState: AudioProcessingState.ready,
    //         ),
    //       ),
    //     ),
    //     audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
    //   ]);
    //   await tester.pumpAndSettle();

    //   expect(find.byIcon(Icons.pause), findsOneWidget);
    //   expect(find.byTooltip('Pause'), findsOneWidget);
    //   expect(find.byType(CircularProgressIndicator), findsNothing);

    //   await tester.tap(find.byIcon(Icons.pause));
    //   verify(
    //     () => mockAudioPlayerNotifier.triggerMediaAction(MediaAction.playPause),
    //   ).called(1);
    // });

    // testWidgets('shows progress indicator when loading', (
    //   WidgetTester tester,
    // ) async {
    //   await pumpWidget(tester, [
    //     audioStateProvider.overrideWithValue(
    //       AsyncData(
    //         createPlaybackState(processingState: AudioProcessingState.loading),
    //       ),
    //     ),
    //     audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
    //   ]);
    //   await tester.pumpAndSettle();

    //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
    //   expect(find.byIcon(Icons.play_arrow), findsNothing);
    //   expect(find.byIcon(Icons.pause), findsNothing);

    //   final iconButton = tester.widget<IconButton>(find.byType(IconButton));
    //   expect(iconButton.onPressed, isNull); // Button should be disabled
    // });

    // testWidgets('shows progress indicator when buffering', (
    //   WidgetTester tester,
    // ) async {
    //   await pumpWidget(tester, [
    //     audioStateProvider.overrideWithValue(
    //       AsyncData(
    //         createPlaybackState(
    //           processingState: AudioProcessingState.buffering,
    //         ),
    //       ),
    //     ),
    //     audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
    //   ]);
    //   await tester.pumpAndSettle();

    //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
    //   expect(find.byIcon(Icons.play_arrow), findsNothing);
    //   expect(find.byIcon(Icons.pause), findsNothing);

    //   final iconButton = tester.widget<IconButton>(find.byType(IconButton));
    //   expect(iconButton.onPressed, isNull); // Button should be disabled
    // });

    // testWidgets(
    //   'shows progress indicator when audioStateProvider is AsyncLoading',
    //   (WidgetTester tester) async {
    //     await pumpWidget(tester, [
    //       audioStateProvider.overrideWithValue(const AsyncLoading()),
    //       audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
    //     ]);
    //     await tester.pumpAndSettle();

    //     expect(find.byType(CircularProgressIndicator), findsOneWidget);
    //     expect(find.byIcon(Icons.play_arrow), findsNothing);
    //     expect(find.byIcon(Icons.pause), findsNothing);

    //     final iconButtonFinder = find.byType(IconButton);
    //     expect(
    //       iconButtonFinder,
    //       findsOneWidget,
    //     ); // The IconButton itself is still there
    //     final iconButton = tester.widget<IconButton>(iconButtonFinder);
    //     expect(iconButton.onPressed, isNull); // But it's disabled
    //   },
    // );

    // testWidgets(
    //   'shows progress indicator when audioStateProvider is AsyncError',
    //   (WidgetTester tester) async {
    //     await pumpWidget(tester, [
    //       audioStateProvider.overrideWithValue(
    //         AsyncError('Test error', StackTrace.empty),
    //       ),
    //       audioPlayerPodProvider.overrideWith(() => mockAudioPlayerNotifier),
    //     ]);
    //     await tester.pumpAndSettle();

    //     expect(
    //       find.byType(CircularProgressIndicator),
    //       findsOneWidget,
    //     ); // Or an error icon, depending on widget's error handling
    //     expect(find.byIcon(Icons.play_arrow), findsNothing);
    //     expect(find.byIcon(Icons.pause), findsNothing);

    //     final iconButtonFinder = find.byType(IconButton);
    //     expect(iconButtonFinder, findsOneWidget);
    //     final iconButton = tester.widget<IconButton>(iconButtonFinder);
    //     expect(iconButton.onPressed, isNull);
    //   },
    // );
  });
}