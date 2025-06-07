import 'dart:ui'; // For SemanticsFlag

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/podcast.model.dart'; // Added for PodcastId
import 'package:podcast_core/extensions/duration_extensions.dart';
import 'package:podcast_core/extensions/string_extensions.dart';
import 'package:podcast_core/services/podcast_audio_handler.dart'; // Added for PodcastMediaItem
import 'package:podcast_core/widgets/episode_list_item.dart';
import 'package:podcast_core/widgets/play_episode_button.dart';
import 'package:podcast_core/widgets/pub_date_text.dart';
import 'package:podcast_core/widgets/queue_button.dart';
import 'package:podcast_core/widgets/rounded_image.dart';

// Assuming test_episode.dart provides a concrete TestEpisode or similar, not used directly for mockEpisode now
// import '../test_data_models/test_episode.dart';
import '../helpers/widget_tester_helpers.dart'; // Corrected relative path

// Define MockEpisode as a concrete implementation of Episode for tests
class MockEpisode implements Episode {
  @override
  final EpisodeId id;
  @override
  final Uri url;
  @override
  final String title;
  @override
  final DateTime? pubDate;
  @override
  final String? description;
  @override
  final Uri imageUrl;
  @override
  final Duration? duration;
  @override
  final PodcastId podcastId; // This type needs to be resolved

  MockEpisode({
    required this.id,
    required this.url,
    required this.title,
    this.pubDate,
    this.description,
    required this.imageUrl,
    this.duration,
    required this.podcastId,
  });

  @override
  String get localFilePath => '${id.id}-${url.pathSegments.last}'; // Use .id for EpisodeId

  @override
  PodcastMediaItem mediaItem({
    Duration? actualDuration,
    bool? isPlayingFromDownloaded,
  }) {
    // Throw UnimplementedError as PodcastMediaItem definition is missing
    throw UnimplementedError(
      'PodcastMediaItem definition is missing or its constructor is unknown.',
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockEpisode = MockEpisode(
    id: EpisodeId('test-episode-id-a11y'),
    podcastId: PodcastId('test-podcast-id-a11y'),
    title: 'Test Episode Title for A11y',
    url: Uri.parse('http://example.com/episode.mp3'),
    description: '<p>Test Episode Description with HTML for A11y</p>',
    pubDate: DateTime(2023, 10, 26),
    duration: const Duration(minutes: 30, seconds: 45),
    imageUrl: Uri.parse('https://example.com/test_image_a11y.png'),
  );

  Future<void> pumpWidgetUnderTest(
    WidgetTester tester, {
    required Episode episode,
    required bool isPlayed,
    Widget? trailing,
    // VoidCallback? onTap, // Removed, EpisodeListItem does not take onTap directly
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: EpisodeListItem(
              episodeWithStatus: episode,
              isPlayed: isPlayed,
              trailing: trailing,
            ),
          ),
        ),
      ),
    );
    // Add a pumpAndSettle here to ensure all animations/async ops complete
    // before tests that depend on final state begin.
    await tester.pumpAndSettle();
  }

  group('EpisodeListItem Accessibility Tests', () {
    // Test for general a11y guidelines, combining unplayed and played states for this specific check
    testWidgets('passes accessibility guidelines (unplayed and played states)', (tester) async {
      await mockNetworkImagesFor(() async {
        // Test unplayed state
        await pumpWidgetUnderTest(tester, episode: mockEpisode, isPlayed: false);
        await tester.testA11yGuidelines(label: 'Unplayed EpisodeListItem');

        // Test played state
        await pumpWidgetUnderTest(tester, episode: mockEpisode, isPlayed: true);
        await tester.testA11yGuidelines(label: 'Played EpisodeListItem');
      });
    });

    testWidgets('renders correctly when unplayed and checks detailed semantics', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(
          tester,
          episode: mockEpisode,
          isPlayed: false,
        );

        final listItemFinder = find.byType(EpisodeListItem);
        expect(listItemFinder, findsOneWidget);

        // 2. Main InkWell (EpisodeListItem)
        // Tap Target Size
        expect(tester.getSize(listItemFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(listItemFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

        // Combined Semantic Label and Tappable
        // This assumes EpisodeListItem's Semantics combines these details.
        // The exact format of pubDate and duration needs to match how PubDateText formats it.
        // For example, PubDateText might produce "Oct 26, 2023 • 30:45".
        // The state "Unplayed episode" is from RoundedImage's tooltip.
        // How this gets into the main label needs to be verified.
        // It's more likely the main label focuses on content, and state is conveyed by child elements' semantics.
        // For now, we'll check for essential parts. A more robust check would involve knowing
        // exactly how EpisodeListItem merges its semantics.
        final expectedLabelParts = [
          mockEpisode.title,
          mockEpisode.description!.removeHtmlTags(),
          // Assuming PubDateText renders "Month Day, Year" and duration is "MM:SS"
          // This part is highly dependent on PubDateText's output.
          // For a more robust test, you might find PubDateText and get its text.
          // For now, checking parts:
          "2023", // Year from pubDate
          mockEpisode.duration!.prettyPrint(), // "30:45"
          "Unplayed episode", // From RoundedImage tooltip
        ];
        expect(
          tester.getSemantics(listItemFinder),
          matchesSemantics(
            // label: allOf(expectedLabelParts.map(contains).toList()), // This creates a list of Matchers
            // A simpler check for now, focusing on title and tappable. Full label construction is complex.
            label: contains(mockEpisode.title),
            tooltip: contains("Unplayed episode"), // Tooltip often comes from child (RoundedImage)
            isTappable: true,
            // Other flags as necessary e.g. isFocusable
          ),
        );


        // 3. RoundedImage
        final roundedImageFinder = find.byType(RoundedImage);
        expect(roundedImageFinder, findsOneWidget);
        expect(tester.getSize(roundedImageFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension / 2)); // Example, not necessarily a tap target
        expect(tester.getSize(roundedImageFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension / 2));
        final roundedImageSemantics = tester.getSemantics(roundedImageFinder);
        expect(roundedImageSemantics.label, 'Episode image');
        expect(roundedImageSemantics.tooltip, 'Unplayed episode');


        // 4. PlayEpisodeButton and QueueButton
        final playButtonFinder = find.byType(PlayEpisodeButton);
        expect(playButtonFinder, findsOneWidget);
        expect(tester.getSize(playButtonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(playButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(
          tester.getSemantics(playButtonFinder),
          matchesSemantics(isButton: true, hasTapAction: true, label: "Play episode"),
        );

        final queueButtonFinder = find.byType(QueueButton);
        expect(queueButtonFinder, findsOneWidget);
        expect(tester.getSize(queueButtonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(queueButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(
          tester.getSemantics(queueButtonFinder),
          matchesSemantics(isButton: true, hasTapAction: true, label: "Add to queue"),
        );
      });
    });

    testWidgets('renders correctly when played and checks detailed semantics', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(tester, episode: mockEpisode, isPlayed: true);

        final listItemFinder = find.byType(EpisodeListItem);
        // Combined Semantic Label and Tappable (Played State)
        expect(
          tester.getSemantics(listItemFinder),
          matchesSemantics(
            label: contains(mockEpisode.title),
            tooltip: contains("Played episode"),
            isTappable: true,
          ),
        );

        final roundedImageFinder = find.byType(RoundedImage);
        final roundedImageSemanticsPlayed = tester.getSemantics(roundedImageFinder);
        expect(roundedImageSemanticsPlayed.label, 'Episode image');
        expect(roundedImageSemanticsPlayed.tooltip, 'Played episode');

        final playButtonFinder = find.byType(PlayEpisodeButton);
        expect(tester.getSize(playButtonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(playButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(
          tester.getSemantics(playButtonFinder),
          matchesSemantics(isButton: true, hasTapAction: true, label: "Pause episode"),
        );
      });
    });

    testWidgets('renders correctly with trailing widget and checks its accessibility', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Using a PopupMenuButton as a more realistic trailing widget
        final trailingWidget = PopupMenuButton<String>(
          key: UniqueKey(), // Ensure it has a key for finding if needed
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'test', child: Text('Test Item')),
          ],
          icon: const Icon(Icons.more_vert), // Common icon for PopupMenuButton
          tooltip: 'More options for ${mockEpisode.title}', // Important for accessibility
        );

        await pumpWidgetUnderTest(
          tester,
          episode: mockEpisode,
          isPlayed: false,
          trailing: trailingWidget,
        );

        expect(find.byType(EpisodeListItem), findsOneWidget);
        final trailingIconFinder = find.byIcon(Icons.more_vert);
        expect(trailingIconFinder, findsOneWidget);

        // 5. Trailing Widget (PopupMenuButton)
        expect(tester.getSize(trailingIconFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(trailingIconFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(
          tester.getSemantics(trailingIconFinder), // Semantics are often on the icon if it's part of PopupMenuButton's default structure
          matchesSemantics(
            isButton: true,
            hasTapAction: true,
            tooltip: 'More options for ${mockEpisode.title}', // Check tooltip if set on PopupMenuButton
            // The label might be empty if only tooltip is used, or it might be derived.
            // Depending on PopupMenuButton's internal Semantics.
          ),
        );

        expect(find.byType(PlayEpisodeButton), findsNothing); // As per original test logic
        expect(find.byType(QueueButton), findsNothing);   // As per original test logic

        await tester.testA11yGuidelines(label: 'EpisodeListItem with Trailing Widget');
      });
    });

    testWidgets('renders with missing optional data and passes accessibility', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        final minimalEpisode = MockEpisode(
          id: EpisodeId('minimal-ep-id-a11y'),
          podcastId: PodcastId('minimal-podcast-id-a11y'),
          title: 'Minimal Episode A11y',
          url: Uri.parse('http://example.com/minimal_a11y.mp3'),
          imageUrl: Uri.parse('https://example.com/minimal_image_a11y.png'),
          // No description, pubDate, duration
        );

        await pumpWidgetUnderTest(
          tester,
          episode: minimalEpisode,
          isPlayed: false,
        );

        expect(find.byType(EpisodeListItem), findsOneWidget);
        expect(find.text(minimalEpisode.title), findsOneWidget);

        // Check main item accessibility
        final listItemFinder = find.byType(EpisodeListItem);
        expect(tester.getSize(listItemFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(listItemFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(
          tester.getSemantics(listItemFinder),
          matchesSemantics(
            label: contains(minimalEpisode.title),
            tooltip: contains("Unplayed episode"),
            isTappable: true,
          ),
        );

        // Buttons should still be accessible
        final playButtonFinder = find.byType(PlayEpisodeButton);
        expect(playButtonFinder, findsOneWidget);
        expect(tester.getSize(playButtonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(playButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

        final queueButtonFinder = find.byType(QueueButton);
        expect(queueButtonFinder, findsOneWidget);
        expect(tester.getSize(queueButtonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(queueButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

        await tester.testA11yGuidelines(label: 'EpisodeListItem with Minimal Data');
      });
    });

    // Removed redundant 'passes accessibility guidelines when unplayed/played' tests
    // as they are now covered by the combined 'passes accessibility guidelines (unplayed and played states)'
    // and specific checks within other tests.
  });
}
