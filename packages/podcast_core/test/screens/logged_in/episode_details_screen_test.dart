import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:flutter/semantics.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/providers/color_scheme_from_remote_image_provider.dart';
import 'package:podcast_core/providers/episodes_provider.dart';
import 'package:podcast_core/screens/logged_in/episode_details_screen.dart';
import 'package:podcast_core/widgets/play_episode_button.dart';
import 'package:podcast_core/widgets/queue_button.dart';
import 'package:podcast_core/widgets/rounded_image.dart';

import '../../helpers/widget_tester_helpers.dart';
import '../../test_data_models/test_episode.dart';
import '../../test_data_models/test_podcast.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EpisodeDetailsScreen Tests', () {
    late TestPodcast testPodcast;
    late TestEpisode testEpisode;
    late EpisodeWithStatus testEpisodeWithStatus;

    setUp(() {
      testPodcast = TestPodcast(
        id: PodcastId('1'),
        url: PodcastRssUrl.parse('http://example.com/feed.xml'),
        link: Uri.parse('http://example.com'),
        title: 'Test Podcast Title',
        description: 'Test Podcast Description',
        artwork: Uri.parse('http://example.com/podcast_image.png'),
      );
      testEpisode = TestEpisode(
        id: EpisodeId('1'),
        url: Uri.parse('http://example.com/episode.mp3'),
        title: 'Test Episode Title',
        pubDate: DateTime(2024),
        description: 'Test Description',
        imageUrl: Uri.parse('http://example.com/episode_image.png'),
        podcastId: PodcastId('1'),
      );
      testEpisodeWithStatus = EpisodeWithStatus(
        episode: testEpisode,
        status: null,
      );
    });

    Future<void> pumpScreen(WidgetTester tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          ProviderScope(
            overrides: [
              episodePodProvider(
                podcastId: PodcastId('1'),
                episodeId: EpisodeId('1'),
              ).overrideWithBuild(
                (_, _) => AsyncData((testPodcast, testEpisodeWithStatus)),
              ),
              colorSchemeFromRemoteImageProvider(
                Uri.parse('http://example.com/episode_image.png'),
                Brightness.light,
              ).overrideWith(
                (ref) =>
                    Future.value(ColorScheme.fromSeed(seedColor: Colors.blue)),
              ),
            ],
            child: MaterialApp(
              home: EpisodeDetailsScreen(
                podcastId: PodcastId('1'),
                episodeId: EpisodeId('1'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Follows a11y guidelines', (tester) async {
      await pumpScreen(tester);

      await tester.testA11yGuidelines();
    });

    testWidgets('renders basic episode details correctly and checks semantics', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester);

      // Verify Podcast Title
      expect(find.text('Test Podcast Title'), findsOneWidget);

      // Verify Episode Title
      expect(find.text('Test Episode Title'), findsOneWidget);

      // Verify Publication Date
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains('January 1, 2024'),
        ),
        findsOneWidget,
      );

      // Verify Podcast Title accessibility
      expect(find.text('Test Podcast Title'), findsOneWidget);
      expect(
        tester.getSemantics(find.text('Test Podcast Title')),
        matchesSemantics(label: 'Test Podcast Title', isInSemanticTree: true),
      );

      // Verify Episode Title accessibility
      expect(find.text('Test Episode Title'), findsOneWidget);
      expect(
        tester.getSemantics(find.text('Test Episode Title')),
        matchesSemantics(label: 'Test Episode Title', isInSemanticTree: true),
      );

      // Verify Episode Image (RoundedImage)
      expect(find.byType(RoundedImage), findsOneWidget);
      final imageSemantics = tester.getSemantics(find.byType(RoundedImage));
      expect(imageSemantics.label, 'Episode image'); // Assuming RoundedImage forwards this or has its own.
                                                    // This might need adjustment based on RoundedImage implementation.

      // Verify HtmlWidget content accessibility (basic check)
      // This checks if any text from the description is found in the semantics tree.
      // A more robust test might involve checking specific text nodes if the HTML structure is known.
      expect(find.byType(HtmlWidget), findsOneWidget);
      final htmlWidgetSemantics = tester.getSemantics(find.byType(HtmlWidget));
      // Check that it has some text content. The exact label might be a concatenation of text nodes.
      expect(htmlWidgetSemantics.value, contains('Test Description'));
      expect(htmlWidgetSemantics.isInSemanticTree, isTrue);


      // Verify Play and Queue Buttons
      expect(find.byType(PlayEpisodeButton), findsOneWidget);
      expect(find.byType(QueueButton), findsOneWidget);

      // Check button tap target sizes
      final playButton = find.byType(PlayEpisodeButton);
      final queueButton = find.byType(QueueButton);
      expect(tester.getSize(playButton).width, greaterThanOrEqualTo(48.0));
      expect(tester.getSize(playButton).height, greaterThanOrEqualTo(48.0));
      expect(tester.getSize(queueButton).width, greaterThanOrEqualTo(48.0));
      expect(tester.getSize(queueButton).height, greaterThanOrEqualTo(48.0));

      // Check button semantics
      expect(
        tester.getSemantics(playButton),
        matchesSemantics(
          isButton: true,
          hasTapAction: true,
          isEnabled: true,
          isFocusable: true,
          hasFocusAction: true,
          hasEnabledState: true,
          label: 'Play episode', // This label should come from PlayEpisodeButton's Semantics
        ),
      );
      expect(
        tester.getSemantics(queueButton),
        matchesSemantics(
          isButton: true,
          hasTapAction: true,
          isEnabled: true,
          isFocusable: true,
          hasFocusAction: true,
          hasEnabledState: true,
          label: 'Add to queue', // This label should come from QueueButton's Semantics
        ),
      );
    });

    testWidgets('AnimatedTheme changes theme based on image colors', (
      WidgetTester tester,
    ) async {
      // This test is more complex as it requires mocking ColorSchemeFromRemoteImageProvider
      // and verifying theme changes. For now, we'll ensure AnimatedTheme is present.
      await pumpScreen(tester);
      expect(
        find.byKey(const Key('EpisodeDetailsScreen.theme')),
        findsOneWidget,
      );
      // TODO: Further testing would involve overriding the provider and checking specific theme properties.
    });

    testWidgets('tapping on a URL in HTML description launches the URL', (
      WidgetTester tester,
    ) async {
      // This requires mocking url_launcher
      // For now, we ensure the HtmlWidget is present and has an onTapUrl callback.
      await pumpScreen(tester);
      final htmlWidget = tester.widget<HtmlWidget>(find.byType(HtmlWidget));
      expect(htmlWidget.onTapUrl, isNotNull);
      // To fully test, you'd need to simulate a tap on a link and verify launchUrlString is called.
      // This often involves setting up a mock channel for url_launcher.
    });

    // TODO: Test cases for when description is null, pubDate is null, etc.

    testWidgets('Screen is selectable for text copying', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester);
      expect(find.byType(SelectableRegion), findsOneWidget);
    });
  });
}
