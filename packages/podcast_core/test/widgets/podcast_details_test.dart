import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // In case any descendant widget uses it
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/widgets/podcast_details.dart';
import 'package:podcast_core/widgets/rounded_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'; // If checking HtmlWidget presence

import '../../test_data_models/test_podcast.dart';
import '../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension and testA11yGuidelines

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestPodcast completePodcast;
  late TestPodcast minimalPodcast;

  setUp(() {
    completePodcast = TestPodcast.mocked(
      id: 'pd1_complete',
      title: 'The Complete Story of Everything',
      author: 'Dr. Universe',
      description: '<p>A <b>very long</b> and <i>detailed</i> description about the podcast.</p>',
      artwork: 'http://example.com/complete_artwork.png',
    );

    minimalPodcast = TestPodcast.mocked(
      id: 'pd2_minimal',
      title: 'Minimalist Views',
      author: null, // No author
      description: null, // No description
      artwork: 'http://example.com/minimal_artwork.png',
    );
  });

  Future<void> pumpPodcastDetails(
    WidgetTester tester, {
    required Podcast podcast,
    bool isDense = false,
    List<Widget> actions = const [], // Default to no actions for these tests
  }) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(
          ProviderScope( // ProviderScope in case any descendant widgets use Riverpod
            child: MaterialApp(
              home: Scaffold(
                body: PodcastDetails(
                  podcast: podcast,
                  actions: actions,
                  isDense: isDense,
                ),
              ),
            ),
          ),
        ));
    await tester.pumpAndSettle();
  }

  group('PodcastDetails Accessibility Tests', () {
    testWidgets(
        'Complete podcast data (isDense: false): displays all info, correct semantics, and meets a11y',
        (tester) async {
      await pumpPodcastDetails(tester, podcast: completePodcast, isDense: false);

      // Verify UI elements
      final imageFinder = find.byType(RoundedImage);
      expect(imageFinder, findsOneWidget);
      expect(find.text(completePodcast.title), findsOneWidget);
      expect(find.text(completePodcast.author!), findsOneWidget); // Author is present
      // Description is HTML, so find by HtmlWidget or its content
      final htmlWidgetFinder = find.byType(HtmlWidget);
      expect(htmlWidgetFinder, findsOneWidget);
      // Check if some part of the description text is rendered (more robust than exact HTML match)
      expect(find.textContaining('very long', findRichText: true), findsOneWidget);


      // Verify Semantics
      expect(tester.getSemantics(imageFinder), matchesSemantics(label: 'Podcast artwork'));

      final titleFinder = find.text(completePodcast.title);
      expect(tester.getSemantics(titleFinder), matchesSemantics(label: completePodcast.title, isInSemanticTree: true, isHeader: true)); // Titles often are headers

      final authorFinder = find.text(completePodcast.author!);
      expect(tester.getSemantics(authorFinder), matchesSemantics(label: completePodcast.author!, isInSemanticTree: true));

      // HtmlWidget's semantics can be complex. Check it's in the tree and has some value.
      final htmlSemantics = tester.getSemantics(htmlWidgetFinder);
      expect(htmlSemantics.isInSemanticTree, isTrue);
      expect(htmlSemantics.value, isNotNull); // Or contains(completePodcast.description.removeHtmlTags()) if applicable
      expect(htmlSemantics.value, contains('very long'));


      await tester.testA11yGuidelines(label: 'PodcastDetails - Complete Data, Not Dense');
    });

    testWidgets(
        'Minimal podcast data (isDense: false): displays available info gracefully and meets a11y',
        (tester) async {
      await pumpPodcastDetails(tester, podcast: minimalPodcast, isDense: false);

      // Verify UI elements
      final imageFinder = find.byType(RoundedImage);
      expect(imageFinder, findsOneWidget);
      expect(find.text(minimalPodcast.title), findsOneWidget);

      // Author and Description should not be found if null
      expect(find.text(completePodcast.author!), findsNothing); // Using completePodcast's author to ensure it's not accidentally rendered
      expect(find.byType(HtmlWidget), findsNothing); // No description means no HtmlWidget

      // Verify Semantics
      expect(tester.getSemantics(imageFinder), matchesSemantics(label: 'Podcast artwork'));
      final titleFinder = find.text(minimalPodcast.title);
      expect(tester.getSemantics(titleFinder), matchesSemantics(label: minimalPodcast.title, isInSemanticTree: true, isHeader: true));

      await tester.testA11yGuidelines(label: 'PodcastDetails - Minimal Data, Not Dense');
    });

    testWidgets(
        'Complete podcast data (isDense: true): displays info correctly and meets a11y',
        (tester) async {
      await pumpPodcastDetails(tester, podcast: completePodcast, isDense: true);

      // Verify key UI elements in dense mode
      final imageFinder = find.byType(RoundedImage);
      expect(imageFinder, findsOneWidget);
      expect(find.text(completePodcast.title), findsOneWidget);
      // Author might still be present in dense mode, depending on implementation
      expect(find.text(completePodcast.author!), findsOneWidget);

      // Description might be hidden or truncated in dense mode.
      // If hidden, HtmlWidget might not be found. If truncated, its content would differ.
      // Let's assume for now it's not rendered or significantly reduced.
      // If it IS rendered, its semantics should be checked.
      // For this test, we'll assume it's not present or not a primary concern for dense a11y.
      // expect(find.byType(HtmlWidget), findsNothing); // This depends on dense implementation

      // Verify Semantics of present elements
      expect(tester.getSemantics(imageFinder), matchesSemantics(label: 'Podcast artwork'));
      final titleFinder = find.text(completePodcast.title);
      expect(tester.getSemantics(titleFinder), matchesSemantics(label: completePodcast.title, isInSemanticTree: true, isHeader: true));
      final authorFinder = find.text(completePodcast.author!);
      expect(tester.getSemantics(authorFinder), matchesSemantics(label: completePodcast.author!, isInSemanticTree: true));


      await tester.testA11yGuidelines(label: 'PodcastDetails - Complete Data, Dense');
    });

    // Test for "Read more" if PodcastDetails itself implements it.
    // If HtmlWidget handles expansion, that's an internal behavior of HtmlWidget.
    // testWidgets('Long description handles "Read more" accessibility', (tester) async {
    //   // Setup podcast with very long description
    //   // Pump PodcastDetails
    //   // Find "Read more" button/action
    //   // Check its tap target, label, role
    //   // Tap it
    //   // Verify expanded content is accessible
    //   // await tester.testA11yGuidelines();
    // });
  });
}
