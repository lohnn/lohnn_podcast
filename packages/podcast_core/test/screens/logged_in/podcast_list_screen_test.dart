import 'dart:async';
import 'dart:ui'; // For SemanticsAction if needed for explicit action check

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/data/podcast_with_status.dart';
import 'package:podcast_core/providers/podcasts_with_status_provider.dart';
import 'package:podcast_core/screens/logged_in/podcast_list_screen.dart';
import 'package:podcast_core/widgets/podcast_list_tile.dart';
import '../../helpers/widget_tester_helpers.dart';
import 'package:podcast_core/helpers/equatable_list.dart';
import 'package:network_image_mock/network_image_mock.dart';

// Define MockPodcast
class MockPodcast implements Podcast {
  @override
  final PodcastId id;
  @override
  final PodcastRssUrl url;
  @override
  final Uri link;
  @override
  final String title;
  @override
  final String description;
  @override
  final Uri artwork;
  @override
  final DateTime? lastPublished;
  @override
  final String? language;
  @override
  final Set<String> categories;

  MockPodcast({
    required this.id,
    required this.url,
    required this.link,
    required this.title,
    required this.description,
    required this.artwork,
    this.lastPublished,
    this.language,
    this.categories = const {},
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockPodcastImpl = MockPodcast(
    id: PodcastId('1'),
    title: 'Test Podcast',
    url: PodcastRssUrl.parse('http://example.com/feed.xml'),
    link: Uri.parse('http://example.com'),
    artwork: Uri.parse('http://example.com/artwork.png'),
    description: 'A test podcast description.',
    lastPublished: DateTime.now(),
    language: 'en',
    categories: {'Technology'},
  );

  final mockPodcastWithStatus = PodcastWithStatus(
    podcast: mockPodcastImpl,
    listenedEpisodes: 5,
    totalEpisodes: 10,
    hasUnseenEpisodes: true,
  );

  group('PodcastListScreen Tests', () {
    testWidgets('renders correctly with data and checks key semantics', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              podcastsWithStatusProvider.overrideWithBuild((ref, self) async {
                return EquatableList([mockPodcastWithStatus]);
              }),
            ],
            child: MaterialApp(home: PodcastListScreen()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(PodcastListScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);

        final searchButton = find.byIcon(Icons.search);
        expect(searchButton, findsOneWidget);

        expect(searchButton, matchesSemantics(
            tooltip: 'Search for podcasts',
            hasTapAction: true,
            hasFocusAction: true, // IconButton with tooltip is focusable and can be tapped
            isButton: true,
            isEnabled: true, // Assuming it is enabled
            isFocusable: true,
        ));

        expect(find.byType(CustomScrollView), findsOneWidget);
        expect(find.text('Test Podcast'), findsOneWidget);
        expect(find.text('5/10'), findsOneWidget);
      });
    });

    testWidgets('renders correctly with empty podcast list', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async { // Added for safety, though likely no images
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              podcastsWithStatusProvider.overrideWithBuild((ref, self) async {
                return EquatableList<PodcastWithStatus>([]);
              }),
            ],
            child: MaterialApp(home: PodcastListScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(PodcastListScreen), findsOneWidget);
        expect(find.byType(PodcastListTile), findsNothing);
        expect(find.text('Test Podcast'), findsNothing);
      });
    });

    testWidgets('renders loading state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            podcastsWithStatusProvider.overrideWithBuild((ref, self) async {
              // Standard way to keep an AsyncNotifier loading for tests: return a non-completing future.
              return Completer<EquatableList<PodcastWithStatus>>().future;
            }),
          ],
          child: MaterialApp(home: PodcastListScreen()),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error state correctly', (WidgetTester tester) async {
      final testException = Exception('Test error from override');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            podcastsWithStatusProvider.overrideWithBuild((ref, self) async {
              throw testException;
            }),
          ],
          child: MaterialApp(home: PodcastListScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Test error from override', findRichText: true), findsOneWidget);
    });

    testWidgets('passes accessibility guidelines', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              podcastsWithStatusProvider.overrideWithBuild((ref, self) async {
                return EquatableList([mockPodcastWithStatus]);
              }),
            ],
            child: MaterialApp(home: PodcastListScreen()),
          ),
        );
        await tester.pumpAndSettle();
        await tester.testA11yGuidelines();
      });
    });
  });
}
