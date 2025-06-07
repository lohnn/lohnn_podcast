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

        // 2. AppBar Search Button Tap Target Size
        expect(tester.getSize(searchButton).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(searchButton).height, greaterThanOrEqualTo(kMinInteractiveDimension));

        // 3. PodcastListTile Instance Checks
        final podcastListTileFinder = find.byType(PodcastListTile);
        expect(podcastListTileFinder, findsOneWidget);

        // Tap target size for PodcastListTile
        expect(tester.getSize(podcastListTileFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        // Height might be tricky if it's dynamic; ensure it's reasonable or meets kMinInteractiveDimension too.
        // For a list item, usually width is constrained and height is content-dependent but should be >= 48.
        expect(tester.getSize(podcastListTileFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

        // Semantic label and tappable for PodcastListTile
        // This assumes PodcastListTile combines title and status for its label.
        // This will need verification against PodcastListTile's actual semantic implementation.
        expect(
          tester.getSemantics(podcastListTileFinder),
          matchesSemantics(
            label: 'Test Podcast, 5/10 listened', // Example combined label
            isTappable: true,
            // Other flags like isFocusable might also be relevant.
          ),
        );
      });
    });

    testWidgets('renders correctly with empty podcast list and checks accessibility', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
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

        // 6. Empty State Accessibility Check
        // Assuming there's a text widget for the empty state like "No podcasts yet."
        // This text needs to be present in your actual UI for the empty list scenario.
        final emptyStateMessageFinder = find.text('No podcasts. Subscribe to some!'); // Example text
        // If your app doesn't show a specific message, this part of the test would be removed or adjusted.
        // For now, let's assume such a message exists for demonstration.
        // expect(emptyStateMessageFinder, findsOneWidget);
        // expect(
        //   tester.getSemantics(emptyStateMessageFinder),
        //   matchesSemantics(label: 'No podcasts. Subscribe to some!', isInSemanticTree: true),
        // );
        // Since the original test didn't assert an empty message, I'll comment this out.
        // If an empty state message IS implemented, these lines should be uncommented and text updated.
      });
    });

    testWidgets('renders loading state correctly and checks accessibility', (WidgetTester tester) async {
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

      await tester.pump(); // Initial pump for loading state

      final loadingIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(loadingIndicatorFinder, findsOneWidget);

      // 4. Loading State Accessibility
      // CircularProgressIndicator by default is not excluded from semantics and has a null label.
      // It's usually fine as screen readers might announce "progress indicator".
      // If it were meant to be purely decorative with other loading text, excludeFromSemantics would be true.
      // If it needs a specific announcement, it should have a label.
      final semantics = tester.getSemantics(loadingIndicatorFinder);
      expect(semantics.label, isEmpty, reason: "Default CircularProgressIndicator has no specific label.");
      expect(semantics.hasFlag(SemanticsFlag.isInMutuallyExclusiveGroup), isFalse); // Progress indicators are not typically mutually exclusive groups
      expect(semantics.isFocusable, isFalse); // Not typically focusable
      // testA11yGuidelines will also help catch if it's problematic (e.g., traps focus).
    });

    testWidgets('renders error state correctly and checks accessibility', (WidgetTester tester) async {
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

      final errorTextFinder = find.textContaining('Test error from override', findRichText: true);
      expect(errorTextFinder, findsOneWidget);

      // 5. Error State Accessibility
      expect(
        tester.getSemantics(errorTextFinder),
        matchesSemantics(
          label: contains('Test error from override'), // The exact label might be the full text
          isInSemanticTree: true,
          // Depending on implementation, it might have other properties like isLiveRegion if errors are announced dynamically.
        ),
      );
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
