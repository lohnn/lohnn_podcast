import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:go_router/go_router.dart';

import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/providers/podcast_episode_list_provider.dart';
import 'package:podcast_core/screens/modals/podcast_details_modal.dart';
import 'package:podcast_core/widgets/podcast_details.dart'; // To verify its presence
import 'package:podcast_core/routes/app_routes.dart'; // For navigation paths

import '../../../test_data_models/test_podcast.dart';
import '../../helpers/widget_tester_helpers.dart';

// --- Mocks ---
class MockPodcastEpisodeListNotifier extends StateNotifier<List<Podcast>>
    with Mock
    implements PodcastEpisodeListNotifier {
  MockPodcastEpisodeListNotifier(List<Podcast> state) : super(state);

  @override
  Future<bool> subscribeToPodcast(Podcast podcast) async {
    // Allow mocking this behavior
    return super.noSuchMethod(
      Invocation.method(#subscribeToPodcast, [podcast]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }

  @override
  Future<void> unsubscribeFromPodcast(PodcastId podcastId) async {
    return super.noSuchMethod(
      Invocation.method(#unsubscribeFromPodcast, [podcastId]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }

  @override
  bool isSubscribed(PodcastId podcastId) {
    return super.noSuchMethod(
      Invocation.method(#isSubscribed, [podcastId]),
      returnValue: false, // Default to not subscribed
      returnValueForMissingStub: false,
    );
  }
}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestPodcast testPodcast;
  late MockPodcastEpisodeListNotifier mockPodcastListNotifier;
  late MockGoRouter mockGoRouter;

  setUp(() {
    testPodcast = TestPodcast.mocked(
      id: 'pd1',
      title: 'Tech Insights',
      author: 'The Techie',
      description: 'Deep dives into technology.',
      artwork: 'http://example.com/tech_insights_artwork.png',
    );
    mockPodcastListNotifier = MockPodcastEpisodeListNotifier([]); // Initial state
    mockGoRouter = MockGoRouter();

    // Stub default behaviors
    when(() => mockGoRouter.push(any())).thenAnswer((_) async => {});
    when(() => mockGoRouter.pop()).thenAnswer((_) {}); // For closing the modal via Navigator.pop(context)
    when(() => mockPodcastListNotifier.subscribeToPodcast(any())).thenAnswer((_) async => true);
    when(() => mockPodcastListNotifier.unsubscribeFromPodcast(any())).thenAnswer((_) async {});
  });

  Future<void> pumpPodcastDetailsModal(WidgetTester tester, {required Podcast podcast}) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(
          ProviderScope(
            overrides: [
              podcastEpisodeListPodProvider.overrideWith((ref) => mockPodcastListNotifier),
            ],
            child: MaterialApp(
              home: InheritedGoRouter(
                goRouter: mockGoRouter,
                child: Scaffold(
                  body: Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () {
                        PodcastDetailsModal.show(context, podcast: podcast);
                      },
                      child: const Text('Show Details Modal'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
    await tester.tap(find.text('Show Details Modal'));
    await tester.pumpAndSettle(); // Modal animation
  }

  group('PodcastDetailsModal Accessibility and Functionality Tests', () {
    testWidgets(
        'Modal with unsubscribed podcast: displays info, actions, correct semantics, and meets a11y',
        (tester) async {
      when(() => mockPodcastListNotifier.isSubscribed(testPodcast.id)).thenReturn(false);
      await pumpPodcastDetailsModal(tester, podcast: testPodcast);

      // Modal Semantics
      final modalFinder = find.byType(PodcastDetailsModal);
      expect(modalFinder, findsOneWidget);
      // AlertDialog/ModalBottomSheet handles isModal. Label is often from content.
      // Check that the podcast title is part of the modal's announced content.
      // A specific overall label for the modal might not be set, relying on its prominent text.

      // Verify PodcastDetails content (high-level)
      expect(find.byType(PodcastDetails), findsOneWidget);
      expect(find.text(testPodcast.title), findsAtLeastNWidgets(1)); // Title in Details and potentially AppBar
      expect(find.text(testPodcast.author!), findsOneWidget);

      // --- Action Buttons ---
      // Subscribe Button
      final subscribeButtonFinder = find.widgetWithText(TextButton, 'Subscribe');
      expect(subscribeButtonFinder, findsOneWidget);
      expect(tester.getSize(subscribeButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSemantics(subscribeButtonFinder), matchesSemantics(label: 'Subscribe', isButton: true, isEnabled: true, hasTapAction: true));

      // View Episodes Button
      final viewEpisodesButtonFinder = find.widgetWithText(TextButton, 'View Episodes');
      expect(viewEpisodesButtonFinder, findsOneWidget);
      expect(tester.getSize(viewEpisodesButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSemantics(viewEpisodesButtonFinder), matchesSemantics(label: 'View Episodes', isButton: true, isEnabled: true, hasTapAction: true));

      // Share Button (assuming it's always present for now)
      final shareButtonFinder = find.widgetWithText(TextButton, 'Share');
      expect(shareButtonFinder, findsOneWidget);
      expect(tester.getSize(shareButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSemantics(shareButtonFinder), matchesSemantics(label: 'Share', isButton: true, isEnabled: true, hasTapAction: true));

      await tester.testA11yGuidelines(label: 'PodcastDetailsModal - Unsubscribed');

      // Interactions
      await tester.tap(subscribeButtonFinder);
      await tester.pumpAndSettle();
      verify(() => mockPodcastListNotifier.subscribeToPodcast(testPodcast)).called(1);

      // Pop the modal before the next navigation to avoid context issues.
      // If subscribe closes modal, this is fine. If not, pop manually for test isolation.
      // Assuming subscribe does not pop, and view episodes is next.
      // Navigator.of(tester.element(modalFinder)).pop(); // Or use mockGoRouter.pop() if modal uses it
      // await tester.pumpAndSettle();

      await tester.tap(viewEpisodesButtonFinder);
      await tester.pumpAndSettle();
      final expectedPath = AppRoutes.podcastEpisodes(podcastId: testPodcast.id.id).path;
      verify(() => mockGoRouter.push(expectedPath)).called(1);
    });

    testWidgets(
        'Modal with subscribed podcast: displays Unsubscribe action and meets a11y',
        (tester) async {
      when(() => mockPodcastListNotifier.isSubscribed(testPodcast.id)).thenReturn(true);
      await pumpPodcastDetailsModal(tester, podcast: testPodcast);

      // Unsubscribe Button
      final unsubscribeButtonFinder = find.widgetWithText(TextButton, 'Unsubscribe');
      expect(unsubscribeButtonFinder, findsOneWidget);
      expect(tester.getSize(unsubscribeButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSemantics(unsubscribeButtonFinder), matchesSemantics(label: 'Unsubscribe', isButton: true, isEnabled: true, hasTapAction: true));

      // Other buttons like "View Episodes" and "Share" should still be there
      expect(find.widgetWithText(TextButton, 'View Episodes'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Share'), findsOneWidget);


      await tester.testA11yGuidelines(label: 'PodcastDetailsModal - Subscribed');

      // Interaction
      await tester.tap(unsubscribeButtonFinder);
      await tester.pumpAndSettle();
      verify(() => mockPodcastListNotifier.unsubscribeFromPodcast(testPodcast.id)).called(1);
    });

    testWidgets('Close button (AppBar) dismisses the modal', (tester) async {
      when(() => mockPodcastListNotifier.isSubscribed(testPodcast.id)).thenReturn(false);
      await pumpPodcastDetailsModal(tester, podcast: testPodcast);

      expect(find.byType(PodcastDetailsModal), findsOneWidget);

      // Find the close button in the AppBar (standard for modals shown this way)
      final closeButtonFinder = find.byIcon(Icons.close);
      expect(closeButtonFinder, findsOneWidget);

      expect(tester.getSemantics(closeButtonFinder), matchesSemantics(isButton: true, isEnabled: true, hasTapAction: true, label: 'Close'));

      await tester.tap(closeButtonFinder);
      await tester.pumpAndSettle(); // Allow modal to dismiss

      expect(find.byType(PodcastDetailsModal), findsNothing);
      // Verify mockGoRouter.pop() was called if the modal uses it for closing.
      // PodcastDetailsModal.show uses Navigator.pop(context) internally.
      // Direct verification of Navigator.pop() is tricky without a navigator mock observer.
      // However, the fact that it's gone is the primary check.
    });
  });
}
