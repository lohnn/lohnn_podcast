import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/providers/podcast_search_provider.dart'; // Actual search provider
import 'package:podcast_core/screens/logged_in/podcast_search_screen.dart';
import 'package:podcast_core/widgets/podcast_list_tile.dart';

import '../../../test_data_models/test_podcast.dart';
import '../../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension and testA11yGuidelines

// --- Mocks ---
// We need to mock the Notifier, not the provider's state directly for actions.
class MockPodcastSearchNotifier
    extends StateNotifier<AsyncValue<List<Podcast>>>
    with Mock
    implements PodcastSearchNotifier {
  MockPodcastSearchNotifier(AsyncValue<List<Podcast>> state) : super(state);

  // Mock the search method if it's defined on the Notifier
  // For this example, we assume 'searchPodcasts' is the method.
  // If it's different, adjust the mock.
  @override
  Future<void> searchPodcasts(String query) async {
    // This method will be verified. The actual state changes will be managed by
    // directly setting the 'state' property of this mock in tests.
    // Or, by using when(...).thenAnswer(...) for more complex async flows.
    return super.searchPodcasts(query); // This calls the mocked method
  }

  void setState(AsyncValue<List<Podcast>> newState) {
    state = newState;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockPodcastSearchNotifier mockSearchNotifier;
  late TestPodcast testPodcast1;
  late TestPodcast testPodcast2;

  setUp(() {
    // Initial state for the notifier, can be overridden in tests.
    mockSearchNotifier = MockPodcastSearchNotifier(const AsyncData([]));
    testPodcast1 = TestPodcast.mocked(id: 'pd1', title: 'Tech Talks Weekly');
    testPodcast2 = TestPodcast.mocked(id: 'pd2', title: 'History Uncovered');

    // Stub the searchPodcasts method if you want to verify its call without complex state logic here
    // or if you want to control its execution flow precisely in tests.
    when(() => mockSearchNotifier.searchPodcasts(any())).thenAnswer((_) async {});
  });

  Future<void> pumpPodcastSearchScreen(WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(
          ProviderScope(
            overrides: [
              podcastSearchProvider.overrideWith((ref) => mockSearchNotifier),
            ],
            child: const MaterialApp(
              home: PodcastSearchScreen(),
            ),
          ),
        ));
    await tester.pumpAndSettle(); // Allow initial frame to settle
  }

  group('PodcastSearchScreen Accessibility and Functionality Tests', () {
    testWidgets(
        'Initial state: renders search field, placeholder, and meets a11y',
        (tester) async {
      // Set initial state for the notifier if different from setUp
      mockSearchNotifier.setState(const AsyncData([])); // Explicitly empty results
      await pumpPodcastSearchScreen(tester);

      final searchFieldFinder = find.byType(TextField);
      expect(searchFieldFinder, findsOneWidget);

      // Check TextField semantics
      final textField = tester.widget<TextField>(searchFieldFinder);
      expect(textField.decoration?.hintText, 'Search for podcasts...');
      expect(textField.decoration?.labelText, 'Search'); // Assuming a labelText

      expect(
          tester.getSemantics(searchFieldFinder),
          matchesSemantics(
            label: 'Search', // Or combines with hintText if labelText is null
            hintText: 'Search for podcasts...',
            isTextField: true,
            isFocusable: true,
          ));

      // Check initial placeholder message (if any when data is empty but not loading/error)
      // This screen might show nothing, or a specific "start searching" message.
      // Assuming it shows a specific message for empty initial state:
      final initialMessageFinder = find.text("Search for podcasts by name or keyword.");
      expect(initialMessageFinder, findsOneWidget);
      expect(tester.getSemantics(initialMessageFinder), matchesSemantics(label: "Search for podcasts by name or keyword.", isInSemanticTree: true));


      await tester.testA11yGuidelines(label: 'SearchScreen - Initial State');
    });

    testWidgets(
        'Performs search, shows loading, then results, and meets a11y',
        (tester) async {
      await pumpPodcastSearchScreen(tester); // Initial state

      const searchTerm = 'tech';
      final searchFieldFinder = find.byType(TextField);

      // Simulate search term entry and submission
      // Stub the searchPodcasts method to control state changes
      when(() => mockSearchNotifier.searchPodcasts(searchTerm)).thenAnswer((_) async {
        mockSearchNotifier.setState(const AsyncLoading());
        // Simulate network delay before results
        await Future.delayed(const Duration(milliseconds: 50));
        mockSearchNotifier.setState(AsyncData([testPodcast1, testPodcast2]));
      });

      await tester.enterText(searchFieldFinder, searchTerm);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump(); // First pump for search trigger + loading state

      // Verify search was called
      verify(() => mockSearchNotifier.searchPodcasts(searchTerm)).called(1);

      // Check Loading State
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Add semantics check for loading indicator if needed, usually default is fine.
      // e.g. expect(tester.getSemantics(find.byType(CircularProgressIndicator)), matchesSemantics(isFocusable: false));
      await tester.testA11yGuidelines(label: 'SearchScreen - Loading State');

      await tester.pumpAndSettle(); // Pump through delays and state changes to show results

      // Check Results State
      expect(find.byType(PodcastListTile), findsNWidgets(2));
      expect(find.text(testPodcast1.title), findsOneWidget);
      expect(find.text(testPodcast2.title), findsOneWidget);
      // Brief check on result item semantics (detailed tests in PodcastListTile_test.dart)
      expect(tester.getSemantics(find.text(testPodcast1.title)), matchesSemantics(label: testPodcast1.title));
      await tester.testA11yGuidelines(label: 'SearchScreen - Results State');
    });

    testWidgets('No results found state: displays message and meets a11y',
        (tester) async {
      when(() => mockSearchNotifier.searchPodcasts(any())).thenAnswer((_) async {
        mockSearchNotifier.setState(const AsyncLoading());
        await Future.delayed(const Duration(milliseconds: 50));
        mockSearchNotifier.setState(const AsyncData([])); // Empty list for no results
      });

      await pumpPodcastSearchScreen(tester);
      await tester.enterText(find.byType(TextField), 'nonexistent term');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump(); // Loading
      await tester.pumpAndSettle(); // Settle to no results state

      final noResultsFinder = find.text('No podcasts found. Try a different search.');
      expect(noResultsFinder, findsOneWidget);
      expect(tester.getSemantics(noResultsFinder), matchesSemantics(label: 'No podcasts found. Try a different search.', isInSemanticTree: true));
      await tester.testA11yGuidelines(label: 'SearchScreen - No Results');
    });

    testWidgets('Error state: displays error message and meets a11y',
        (tester) async {
      final exception = Exception('Network error');
      when(() => mockSearchNotifier.searchPodcasts(any())).thenAnswer((_) async {
        mockSearchNotifier.setState(const AsyncLoading());
        await Future.delayed(const Duration(milliseconds: 50));
        mockSearchNotifier.setState(AsyncError(exception, StackTrace.current));
      });

      await pumpPodcastSearchScreen(tester);
      await tester.enterText(find.byType(TextField), 'trigger error');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump(); // Loading
      await tester.pumpAndSettle(); // Settle to error state

      final errorFinder = find.text('Error searching. Please try again.');
      expect(errorFinder, findsOneWidget);
      expect(tester.getSemantics(errorFinder), matchesSemantics(label: 'Error searching. Please try again.', isInSemanticTree: true));
      await tester.testA11yGuidelines(label: 'SearchScreen - Error State');
    });
  });
}
