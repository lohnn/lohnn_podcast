import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/data/podcast_feed.dart';
import 'package:podcast_core/data/podcast_with_status.dart';
import 'package:podcast_core/providers/podcasts_with_status_provider.dart';
import 'package:podcast_core/screens/logged_in/podcast_list_screen.dart';
import '../../helpers/widget_tester_helpers.dart'; // Added import

// import 'package:mocktail/mocktail.dart'; // Not used for now

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockPodcast = Podcast(
    id: PodcastId('1'),
    title: 'Test Podcast',
    url: PodcastRssUrl.parse('http://example.com/feed.xml'),
    link: Uri.parse('http://example.com'),
    artwork: Uri.parse('http://example.com/artwork.png'),
    description: 'A test podcast description.',
    author: 'Test Author',
    owner: PodcastOwner(name: 'Test Owner', email: 'owner@example.com'),
    episodes: [], // Assuming empty list for simplicity here
    newFeedUrl: null,
    funding: [],
    categories: [],
    explicit: false,
    guid: 'test-guid',
    podcastPlatform: PodcastPlatform.rss,
    lastBuildDate: null,
    lastPubDate: null,
  );

  final mockPodcastWithStatus = PodcastWithStatus(
    podcast: mockPodcast,
    listenedEpisodes: 5,
    totalEpisodes: 10,
    hasUnseenEpisodes: true,
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

  group('PodcastListScreen Tests', () {
    testWidgets('renders correctly with data', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          PodcastListScreen(),
          [
            podcastsWithStatusProvider.overrideWith((ref) => AsyncData([mockPodcastWithStatus])),
          ],
        ),
      );

      // Ensure all animations and microtasks are settled
      await tester.pumpAndSettle();

      expect(find.byType(PodcastListScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.text('Test Podcast'), findsOneWidget);
      expect(find.text('5/10'), findsOneWidget);

      // Enhanced semantics check for search button
      final searchButton = find.byIcon(Icons.search);
      expect(tester.getSemantics(searchButton), matchesSemantics(
          hasTapAction: true,
          isButton: true,
          label: 'Search for podcasts', // As per the tooltip in PodcastListScreen
          tooltip: 'Search for podcasts',
      ));
    });

    testWidgets('renders correctly with empty podcast list', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          PodcastListScreen(),
          [
            podcastsWithStatusProvider.overrideWith((ref) => const AsyncData([])),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PodcastListScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('No podcasts yet. Tap the + button to add one.'), findsOneWidget);
      expect(find.text('Test Podcast'), findsNothing);
    });

    testWidgets('renders loading state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          PodcastListScreen(),
          [
            podcastsWithStatusProvider.overrideWith((ref) => const AsyncLoading()),
          ],
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          PodcastListScreen(),
          [
            podcastsWithStatusProvider.overrideWith((ref) => AsyncError('Test error', StackTrace.empty)),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Error: Test error'), findsOneWidget);
    });

    testWidgets('passes accessibility guidelines', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          PodcastListScreen(),
          [
            podcastsWithStatusProvider.overrideWith((ref) => AsyncData([mockPodcastWithStatus])),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.testA11yGuidelines();
    });
  });
}
