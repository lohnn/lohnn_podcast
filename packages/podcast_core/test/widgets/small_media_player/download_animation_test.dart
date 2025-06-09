import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/download_task_status.dart';
import 'package:podcast_core/providers/download_queue_pod.dart';
import 'package:podcast_core/providers/download_tasks_provider.dart';
import 'package:podcast_core/widgets/small_media_player/download_animation.dart';
// For PodcastMediaItem - TestEpisode handles its own mediaItem
// import 'package:podcast_core/services/podcast_audio_handler.dart';

import '../../../test_data_models/test_episode.dart'; // Corrected path for TestEpisode
import '../../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension etc.

// --- Mocks ---
// MockEpisode class definition removed

class MockDownloadQueuePod extends Mock implements DownloadQueuePod {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEpisode mockEpisode; // Changed type to TestEpisode
  late MockDownloadQueuePod mockDownloadQueueNotifier;

  setUp(() {
    // Initialize with TestEpisode.mocked()
    mockEpisode = TestEpisode.mocked(
        id: 'dl_ep_default',
        podcastId: 'dl_pd_default',
        title: 'Default Download Test Episode');
    mockDownloadQueueNotifier = MockDownloadQueuePod();

    // Default stubs for actions
    when(() => mockDownloadQueueNotifier.addToDownloadQueue(any()))
        .thenAnswer((_) async {});
    when(() => mockDownloadQueueNotifier.cancelDownload(any()))
        .thenAnswer((_) async {});
    // Add resumeDownload, etc., if DownloadAnimation uses them
  });

  Future<void> pumpDownloadAnimation(
    WidgetTester tester, {
    DownloadTaskStatus? taskStatus, // Overall status of the task
    DownloadTaskProgress? taskProgress, // Progress if downloading
  }) async {
    // Prepare the state for the providers
    final tasksMap = <String, DownloadTaskStatus>{};
    if (taskStatus != null) {
      tasksMap[mockEpisode.id.id] = taskStatus;
    }

    final progressMap = <String, DownloadTaskProgress>{};
    if (taskProgress != null) {
      progressMap[mockEpisode.id.id] = taskProgress;
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          downloadTasksProvider.overrideWithValue(tasksMap),
          downloadTaskProgressProvider.overrideWithValue(progressMap),
          downloadQueuePodProvider.overrideWith((ref) => mockDownloadQueueNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: DownloadAnimation(episode: mockEpisode),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('DownloadAnimation Accessibility Tests', () {
    testWidgets(
        'Not Downloaded state: correct icon, tooltip, action, and meets a11y',
        (tester) async {
      await pumpDownloadAnimation(tester, taskStatus: null); // No status means not downloaded

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(Icons.download_for_offline_outlined), findsOneWidget);

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Download',
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'DownloadAnimation - Not Downloaded');

      await tester.tap(buttonFinder);
      verify(() => mockDownloadQueueNotifier.addToDownloadQueue(mockEpisode)).called(1);
    });

    testWidgets('Download Queued state: correct icon, tooltip, and meets a11y',
        (tester) async {
      await pumpDownloadAnimation(
          tester,
          taskStatus: DownloadTaskStatus(
              id: mockEpisode.id.id,
              status: DownloadTaskStatusType.queued,
              progress: 0));

      // Icon might be specific for queued, e.g., Icons.pending_actions_outlined
      // Or it might show the download icon but be non-interactive or have a different tooltip.
      // Let's assume it shows a queue/pending icon and is non-interactive for now.
      expect(find.byIcon(Icons.pending_actions_outlined), findsOneWidget);
      final buttonFinder = find.byType(IconButton); // Or a generic container if not an IconButton in this state
      expect(buttonFinder, findsOneWidget);


      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      final iconButton = tester.widget<IconButton>(buttonFinder);
      expect(iconButton.onPressed, isNull); // Often queued state is not directly interactive to cancel from here

      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Download pending',
          isButton: true, // Still a button, but disabled
          isEnabled: false,
        ),
      );
      await tester.testA11yGuidelines(label: 'DownloadAnimation - Queued');
    });

    testWidgets(
        'Downloading state (e.g., 50%): shows progress, tooltip, action (cancel), and meets a11y',
        (tester) async {
      await pumpDownloadAnimation(
        tester,
        taskStatus: DownloadTaskStatus(
            id: mockEpisode.id.id,
            status: DownloadTaskStatusType.running,
            progress: 50),
        taskProgress: DownloadTaskProgress(id: mockEpisode.id.id, progress: 50, taskId: 'task1'),
      );

      // Expect CircularProgressIndicator and potentially a cancel button (e.g., Icons.close or Icons.stop)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final buttonFinder = find.byType(IconButton); // Assuming IconButton is still used for cancel
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsOneWidget); // Icon for cancel/stop


      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      // Tooltip should ideally include progress and cancel action
      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Cancel download (50%)', // Example tooltip
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'DownloadAnimation - Downloading 50%');

      await tester.tap(buttonFinder);
      verify(() => mockDownloadQueueNotifier.cancelDownload(mockEpisode.id)).called(1);
    });

    testWidgets(
        'Downloaded state: correct icon, tooltip, action (delete), and meets a11y',
        (tester) async {
      await pumpDownloadAnimation(
          tester,
          taskStatus: DownloadTaskStatus(
              id: mockEpisode.id.id,
              status: DownloadTaskStatusType.complete,
              progress: 100));

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(Icons.download_done_rounded), findsOneWidget);


      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Delete download',
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'DownloadAnimation - Downloaded');

      await tester.tap(buttonFinder);
      // This action might be different, e.g., `deleteDownloadedFile(mockEpisode.id)`
      // For now, using cancelDownload as a placeholder for "remove/undo download"
      verify(() => mockDownloadQueueNotifier.cancelDownload(mockEpisode.id)).called(1);
    });

    testWidgets('Error state: correct icon, tooltip, action (retry), and meets a11y',
        (tester) async {
      await pumpDownloadAnimation(
          tester,
          taskStatus: DownloadTaskStatus(
              id: mockEpisode.id.id,
              status: DownloadTaskStatusType.failed,
              progress: 0));

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);


      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Download error, tap to retry', // Example tooltip
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'DownloadAnimation - Error');

      await tester.tap(buttonFinder);
      // Action should be to retry, which might be addToDownloadQueue again or a specific retry method
      verify(() => mockDownloadQueueNotifier.addToDownloadQueue(mockEpisode)).called(1);
    });
  });
}
