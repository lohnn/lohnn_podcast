import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/user_episode_status.model.dart';
import 'package:podcast_core/providers/playlist_pod_provider.dart';
import 'package:podcast_core/providers/user_episode_status_provider.dart';
import 'package:podcast_core/screens/logged_in/playlist_screen.dart';
import 'package:podcast_core/widgets/episode_list_item.dart';
import '../../test_data_models/test_episode.dart'; // Using existing mock
import '../../helpers/widget_tester_helpers.dart'; // Added import

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockEpisode1 = testEpisode.copyWith(id: 'ep1', title: 'Playlist Episode 1 for A11y', podcastId: 'podcast1');
  final mockEpisode2 = testEpisode.copyWith(id: 'ep2', title: 'Playlist Episode 2 for A11y', podcastId: 'podcast2');

  final mockStatus1 = UserEpisodeStatus(
    episodeId: mockEpisode1.id,
    podcastId: mockEpisode1.podcastId,
    isPlayed: true,
    position: Duration.zero,
    completed: true,
    isFavorite: false,
    startedAt: null,
    completedAt: DateTime.now(),
    lastListenedAt: DateTime.now(),
  );

  // Helper to wrap a widget with ProviderScope and MaterialApp
  Widget createTestApp(Widget child, List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('PlaylistScreen Tests', () {
    testWidgets('renders correctly with data', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(
            PlaylistScreen(),
            [
              playlistPodProvider.overrideWith((ref) => AsyncData([mockEpisode1, mockEpisode2])),
              userEpisodeStatusPodProvider.overrideWith((ref) => AsyncData({mockEpisode1.id: mockStatus1})),
            ],
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(PlaylistScreen), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Playlist'), findsOneWidget); // AppBar title
        expect(find.byType(ReorderableListView), findsOneWidget);
        expect(find.byType(EpisodeListItem), findsNWidgets(2));
        expect(find.text(mockEpisode1.title), findsOneWidget);
        expect(find.text(mockEpisode2.title), findsOneWidget);
      });
    });

    testWidgets('renders loading state correctly', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(
            PlaylistScreen(),
            [
              playlistPodProvider.overrideWith((ref) => const AsyncLoading()),
              userEpisodeStatusPodProvider.overrideWith((ref) => AsyncData({})),
            ],
          ),
        );

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    testWidgets('renders error state correctly', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(
            PlaylistScreen(),
            [
              playlistPodProvider.overrideWith((ref) => AsyncError('Test error', StackTrace.empty)),
              userEpisodeStatusPodProvider.overrideWith((ref) => AsyncData({})),
            ],
          ),
        );

        await tester.pumpAndSettle();

        expect(find.textContaining('Error: Test error'), findsOneWidget);
      });
    });

    testWidgets('renders correctly with empty playlist', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(
            PlaylistScreen(),
            [
              playlistPodProvider.overrideWith((ref) => const AsyncData([])),
              userEpisodeStatusPodProvider.overrideWith((ref) => AsyncData({})),
            ],
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(PlaylistScreen), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Playlist'), findsOneWidget);
        expect(find.text('Your playlist is empty.'), findsOneWidget);
        expect(find.byType(EpisodeListItem), findsNothing);
      });
    });

    testWidgets('passes accessibility guidelines', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(
            PlaylistScreen(),
            [
              playlistPodProvider.overrideWith((ref) => AsyncData([mockEpisode1, mockEpisode2])),
              userEpisodeStatusPodProvider.overrideWith((ref) => AsyncData({mockEpisode1.id: mockStatus1})),
            ],
          ),
        );
        await tester.pumpAndSettle();
        await tester.testA11yGuidelines();
      });
    });
  });
}
