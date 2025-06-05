import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/utils/extensions.dart'; // For removeHtmlTags and prettyPrint
import 'package:podcast_core/widgets/episode_list_item.dart';
import 'package:podcast_core/widgets/play_episode_button.dart';
import 'package:podcast_core/widgets/queue_button.dart';
import 'package:podcast_core/widgets/rounded_image.dart';
import 'package:podcast_core/widgets/pub_date_text.dart';
import '../test_data_models/test_episode.dart';
import '../../helpers/widget_tester_helpers.dart'; // Added import

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockEpisode = testEpisode.copyWith(
    title: 'Test Episode Title for A11y',
    description: '<p>Test Episode Description with HTML for A11y</p>',
    pubDate: DateTime(2023, 10, 26),
    duration: const Duration(minutes: 30, seconds: 45),
    imageUrl: 'https://example.com/test_image_a11y.png',
    podcastId: 'test-podcast-id-a11y',
    id: 'test-episode-id-a11y',
  );

  Future<void> pumpWidgetUnderTest(
    WidgetTester tester, {
    required Episode episode,
    required bool isPlayed,
    Widget? trailing,
    VoidCallback? onTap,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: EpisodeListItem(
              episode: episode,
              isPlayed: isPlayed,
              onTap: onTap ?? () {},
              trailing: trailing,
            ),
          ),
        ),
      ),
    );
  }

  group('EpisodeListItem Tests', () {
    testWidgets('renders correctly when unplayed and checks key semantics', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(tester, episode: mockEpisode, isPlayed: false);
        await tester.pumpAndSettle();

        expect(find.byType(EpisodeListItem), findsOneWidget);
        expect(find.text(mockEpisode.title), findsOneWidget);
        expect(find.text(mockEpisode.description!.removeHtmlTags()), findsOneWidget);
        expect(find.byType(PubDateText), findsOneWidget);
        expect(find.textContaining(mockEpisode.duration!.prettyPrint()), findsOneWidget);

        final roundedImageFinder = find.byType(RoundedImage);
        expect(roundedImageFinder, findsOneWidget);
        final roundedImage = tester.widget<RoundedImage>(roundedImageFinder);
        expect(roundedImage.showDot, isTrue);

        final roundedImageSemantics = tester.getSemantics(roundedImageFinder);
        expect(roundedImageSemantics.label, 'Episode image');
        expect(roundedImageSemantics.tooltip, 'Unplayed episode');

        final playButtonFinder = find.byType(PlayEpisodeButton);
        expect(playButtonFinder, findsOneWidget);
        expect(tester.getSemantics(playButtonFinder), matchesSemantics(
            isButton: true,
            hasTapAction: true,
            // Assuming PlayEpisodeButton has a default label "Play episode" or similar
            // This might need to be adjusted based on PlayEpisodeButton's actual semantics
            label: contains('Play'), // Placeholder, actual label depends on button's implementation
        ));

        final queueButtonFinder = find.byType(QueueButton);
        expect(queueButtonFinder, findsOneWidget);
        expect(tester.getSemantics(queueButtonFinder), matchesSemantics(
            isButton: true,
            hasTapAction: true,
            // Assuming QueueButton has a default label "Add to queue" or similar
            label: contains('Queue'), // Placeholder
        ));

        final inkWellFinder = find.byType(InkWell);
        final semantics = tester.getSemantics(inkWellFinder);
        expect(semantics, matchesSemantics(
            hasTapAction: true,
            isFocusable: true,
            label: contains(mockEpisode.title), // Check if title is part of the merged label
        ));
        // Check other parts of the label if necessary, e.g., description, date.
        // The exact merged label can be complex, so contains checks are safer.
        expect(semantics.label, contains(mockEpisode.description!.removeHtmlTags()));
        expect(semantics.label, contains(mockEpisode.duration!.prettyPrint()));

      });
    });

    testWidgets('renders correctly when played and checks key semantics', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(tester, episode: mockEpisode, isPlayed: true);
        await tester.pumpAndSettle();

        expect(find.byType(EpisodeListItem), findsOneWidget);
        final roundedImageFinder = find.byType(RoundedImage);
        expect(roundedImageFinder, findsOneWidget);
        final roundedImage = tester.widget<RoundedImage>(roundedImageFinder);
        expect(roundedImage.showDot, isFalse);

        final roundedImageSemanticsPlayed = tester.getSemantics(roundedImageFinder);
        expect(roundedImageSemanticsPlayed.label, 'Episode image');
        expect(roundedImageSemanticsPlayed.tooltip, 'Played episode');

        // PlayEpisodeButton semantics might change when played (e.g. label "Pause episode")
        final playButtonFinder = find.byType(PlayEpisodeButton);
        expect(playButtonFinder, findsOneWidget);
        // Add specific semantic check for played state of PlayEpisodeButton if its label/tooltip changes
      });
    });

    testWidgets('renders correctly with trailing widget', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final mockTrailingWidget = Icon(Icons.more_horiz, key: UniqueKey());
        await pumpWidgetUnderTest(
          tester,
          episode: mockEpisode,
          isPlayed: false,
          trailing: mockTrailingWidget,
        );
        await tester.pumpAndSettle();

        expect(find.byType(EpisodeListItem), findsOneWidget);
        expect(find.byIcon(Icons.more_horiz), findsOneWidget);
        expect(find.byType(PlayEpisodeButton), findsNothing);
        expect(find.byType(QueueButton), findsNothing);
      });
    });

    testWidgets('renders correctly with missing optional data', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final minimalEpisode = Episode(
          id: 'minimal-ep-id-a11y',
          podcastId: 'minimal-podcast-id-a11y',
          title: 'Minimal Episode A11y',
          url: 'http://example.com/minimal_a11y.mp3',
          description: null,
          pubDate: null,
          duration: null,
          imageUrl: 'https://example.com/minimal_image_a11y.png',
          author: null, chaptersUrl: null, episodeNumber: null, seasonNumber: null,
          explicit: false, guid: 'minimal-guid-a11y', fileExtension: 'mp3',
          filename: 'minimal_a11y.mp3', filesize: 10000,
        );

        await pumpWidgetUnderTest(tester, episode: minimalEpisode, isPlayed: false);
        await tester.pumpAndSettle();

        expect(find.byType(EpisodeListItem), findsOneWidget);
        expect(find.text(minimalEpisode.title), findsOneWidget);
        expect(find.byType(RoundedImage), findsOneWidget);
        expect(find.byType(PubDateText), findsNothing);
        expect(find.textContaining('•'), findsNothing);
        expect(find.text(minimalEpisode.description ?? "dummy_desc_a11y"), findsNothing);
        expect(find.byType(PlayEpisodeButton), findsOneWidget);
        expect(find.byType(QueueButton), findsOneWidget);
      });
    });

    testWidgets('passes accessibility guidelines when unplayed', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(tester, episode: mockEpisode, isPlayed: false);
        await tester.pumpAndSettle();
        await tester.testA11yGuidelines();
      });
    });

    testWidgets('passes accessibility guidelines when played', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(tester, episode: mockEpisode, isPlayed: true);
        await tester.pumpAndSettle();
        await tester.testA11yGuidelines();
      });
    });
  });
}
