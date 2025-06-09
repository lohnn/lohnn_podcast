import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for LogicalKeyboardKey
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_core/providers/podcast_episode_list_provider.dart';
import 'package:podcast_core/screens/dialogs/add_podcast_dialog.dart';
import '../../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension and testA11yGuidelines

// --- Mocks ---
class MockPodcastEpisodeListNotifier extends Mock
    implements PodcastEpisodeListNotifier {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockPodcastEpisodeListNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockPodcastEpisodeListNotifier();
    // Stub the addPodcast method
    when(() => mockNotifier.addPodcast(any())).thenAnswer((_) async => true); // Assume it returns bool
  });

  Future<void> pumpAddPodcastDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          podcastEpisodeListPodProvider.overrideWith((ref) => mockNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddPodcastDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      ),
    );
    // Tap the button to show the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle(); // Dialog animation and text field focus
  }

  group('AddPodcastDialog Accessibility and Functionality Tests', () {
    testWidgets('Dialog structure, initial state, focus, and a11y',
        (tester) async {
      await pumpAddPodcastDialog(tester);

      // Verify dialog presence and title
      final dialogFinder = find.byType(AlertDialog); // AddPodcastDialog wraps AlertDialog
      expect(dialogFinder, findsOneWidget);
      expect(find.text('Add Podcast'), findsOneWidget);

      // Verify TextField
      final urlFieldFinder = find.byType(TextField);
      expect(urlFieldFinder, findsOneWidget);

      // Verify Buttons
      final cancelButtonFinder = find.widgetWithText(TextButton, 'Cancel');
      expect(cancelButtonFinder, findsOneWidget);
      final addButtonFinder = find.widgetWithText(TextButton, 'Add');
      expect(addButtonFinder, findsOneWidget);

      // --- Accessibility Checks ---
      // Dialog Semantics (AlertDialog handles isModal)
      expect(tester.getSemantics(dialogFinder),
          matchesSemantics(label: 'Add Podcast', isModal: true));

      // Initial Focus (should be on the TextField)
      // FocusManager.instance.primaryFocus is not reliable in widget tests this way.
      // Instead, check if the TextField widget itself has autofocus or was focused by the dialog.
      // AddPodcastDialog's TextField has autofocus: true.
      final textFieldWidget = tester.widget<TextField>(urlFieldFinder);
      expect(textFieldWidget.autofocus, isTrue, reason: "TextField should autofocus");
      // To truly test focus, one might need more complex focus traversal tests or integration tests.
      // For widget tests, checking autofocus and relying on testA11yGuidelines is often sufficient.

      // TextField Accessibility
      expect(
          tester.getSemantics(urlFieldFinder),
          matchesSemantics(
            label: 'Podcast RSS URL', // From InputDecoration decorator
            isTextField: true,
            isFocused: true, // Due to autofocus
            // Other properties like isEnabled could be checked too
          ));

      // "Add" Button Accessibility (initially disabled)
      final addButtonWidget = tester.widget<TextButton>(addButtonFinder);
      expect(addButtonWidget.onPressed, isNull, reason: "Add button should be initially disabled"); // Disabled
      expect(tester.getSize(addButtonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(addButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSemantics(addButtonFinder),
          matchesSemantics(label: 'Add', isButton: true, isEnabled: false, hasTapAction: false));

      // "Cancel" Button Accessibility
      expect(tester.getSize(cancelButtonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(cancelButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSemantics(cancelButtonFinder),
          matchesSemantics(label: 'Cancel', isButton: true, isEnabled: true, hasTapAction: true));

      await tester.testA11yGuidelines(label: 'AddPodcastDialog Initial State');
    });

    testWidgets('Entering URL enables Add button, interaction, and a11y', (tester) async {
      await pumpAddPodcastDialog(tester);

      final urlFieldFinder = find.byType(TextField);
      final addButtonFinder = find.widgetWithText(TextButton, 'Add');

      // Verify Add button is initially disabled
      TextButton addButtonWidget = tester.widget<TextButton>(addButtonFinder);
      expect(addButtonWidget.onPressed, isNull);

      // Enter text
      const testUrl = 'http://example.com/feed.xml';
      await tester.enterText(urlFieldFinder, testUrl);
      await tester.pumpAndSettle(); // Let the state update

      // Verify Add button is now enabled
      addButtonWidget = tester.widget<TextButton>(addButtonFinder);
      expect(addButtonWidget.onPressed, isNotNull);
      expect(tester.getSemantics(addButtonFinder),
          matchesSemantics(label: 'Add', isButton: true, isEnabled: true, hasTapAction: true));

      // Tap Add button
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle(); // Allow for dialog dismissal and async operations

      // Verify provider action
      verify(() => mockNotifier.addPodcast(testUrl)).called(1);

      // Verify dialog is dismissed
      expect(find.byType(AddPodcastDialog), findsNothing);
    });

    testWidgets('Cancel button dismisses dialog', (tester) async {
      await pumpAddPodcastDialog(tester);

      expect(find.byType(AddPodcastDialog), findsOneWidget); // Dialog is open

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle(); // Dialog dismiss animation

      expect(find.byType(AddPodcastDialog), findsNothing); // Dialog is closed
    });

    group('Focus Traversal Tests', () {
      testWidgets('Focus traversal order is logical when Add is disabled',
          (tester) async {
        await pumpAddPodcastDialog(tester);

        final urlFieldFinder = find.byType(TextField);
        final cancelButtonFinder = find.widgetWithText(TextButton, 'Cancel');
        final addButtonFinder = find.widgetWithText(TextButton, 'Add');

        // 1. Initial focus on TextField (due to autofocus)
        expect(tester.getSemantics(urlFieldFinder),
            matchesSemantics(isFocused: true),
            reason: "TextField should have initial focus.");

        // 2. Tab from TextField to Cancel button (Add is disabled)
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(tester.getSemantics(cancelButtonFinder),
            matchesSemantics(isFocused: true),
            reason: "Focus should move to Cancel button.");
        expect(tester.getSemantics(urlFieldFinder),
            matchesSemantics(isFocused: false));
        expect(tester.getSemantics(addButtonFinder), // Add button is disabled
            matchesSemantics(isFocused: false, isEnabled: false));


        // 3. Tab from Cancel button back to TextField (wrapping around, Add is disabled)
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(tester.getSemantics(urlFieldFinder),
            matchesSemantics(isFocused: true),
            reason: "Focus should wrap back to TextField.");
        expect(tester.getSemantics(cancelButtonFinder),
            matchesSemantics(isFocused: false));

        await tester.testA11yGuidelines(label: 'AddPodcastDialog - Focus Traversal Add Disabled');
      });

      testWidgets('Focus traversal order is logical when Add is enabled',
          (tester) async {
        await pumpAddPodcastDialog(tester);

        final urlFieldFinder = find.byType(TextField);
        final addButtonFinder = find.widgetWithText(TextButton, 'Add');
        final cancelButtonFinder = find.widgetWithText(TextButton, 'Cancel');

        // Enable Add button by entering text
        await tester.enterText(urlFieldFinder, 'http://example.com/feed.xml');
        await tester.pumpAndSettle(); // Ensure state updates and button enables

        // 1. Initial focus still on TextField
        expect(tester.getSemantics(urlFieldFinder),
            matchesSemantics(isFocused: true),
            reason: "TextField should still have focus after text entry.");

        // 2. Tab from TextField to Add button
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(tester.getSemantics(addButtonFinder),
            matchesSemantics(isFocused: true),
            reason: "Focus should move to Add button.");
        expect(tester.getSemantics(urlFieldFinder),
            matchesSemantics(isFocused: false));
        expect(tester.getSemantics(cancelButtonFinder),
            matchesSemantics(isFocused: false));

        // 3. Tab from Add button to Cancel button
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(tester.getSemantics(cancelButtonFinder),
            matchesSemantics(isFocused: true),
            reason: "Focus should move to Cancel button.");
        expect(tester.getSemantics(addButtonFinder),
            matchesSemantics(isFocused: false));

        // 4. Tab from Cancel button back to TextField (wrapping)
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(tester.getSemantics(urlFieldFinder),
            matchesSemantics(isFocused: true),
            reason: "Focus should wrap back to TextField.");
        expect(tester.getSemantics(cancelButtonFinder),
            matchesSemantics(isFocused: false));

        await tester.testA11yGuidelines(label: 'AddPodcastDialog - Focus Traversal Add Enabled');
      });

      testWidgets('Shift+Tab focus traversal order is logical when Add is enabled', (tester) async {
        await pumpAddPodcastDialog(tester);

        final urlFieldFinder = find.byType(TextField);
        final addButtonFinder = find.widgetWithText(TextButton, 'Add');
        final cancelButtonFinder = find.widgetWithText(TextButton, 'Cancel');

        // Enable Add button
        await tester.enterText(urlFieldFinder, 'http://example.com/feed.xml');
        await tester.pumpAndSettle();

        // Ensure initial focus is on TextField
        expect(tester.getSemantics(urlFieldFinder), matchesSemantics(isFocused: true));

        // Shift+Tab from TextField should go to Cancel (wraps to last)
        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.pump();
        expect(tester.getSemantics(cancelButtonFinder), matchesSemantics(isFocused: true), reason: "Shift+Tab from TextField should go to Cancel.");

        // Shift+Tab from Cancel should go to Add
        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.pump();
        expect(tester.getSemantics(addButtonFinder), matchesSemantics(isFocused: true), reason: "Shift+Tab from Cancel should go to Add.");

        // Shift+Tab from Add should go to TextField
        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.pump();
        expect(tester.getSemantics(urlFieldFinder), matchesSemantics(isFocused: true), reason: "Shift+Tab from Add should go to TextField.");
      });
    });
  });
}
