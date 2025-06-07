import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:podcast_core/widgets/pub_date_text.dart';
import '../helpers/widget_tester_helpers.dart'; // For testA11yGuidelines

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpPubDateText(WidgetTester tester, DateTime date) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PubDateText(date),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Helper to format date for comparison.
  // This MUST match the formatting used within PubDateText widget.
  // If PubDateText uses a different format (e.g., from AppLocalizations or a fixed one),
  // this helper or the expected string needs to be adjusted accordingly.
  String formatDateForTest(DateTime date) {
    // Assuming PubDateText uses 'MMM d, yyyy' or similar.
    // Let's use a common format like DateFormat.yMMMd which produces "Oct 26, 2023".
    // If PubDateText uses something like "October 26, 2023", then DateFormat('MMMM d, yyyy') would be needed.
    // For this example, we'll stick to yMMMd as a common, reasonable default.
    return DateFormat.yMMMd().format(date);
  }

  group('PubDateText Accessibility Tests', () {
    testWidgets(
        'renders formatted date, has correct semantics, and meets a11y guidelines for date 1',
        (tester) async {
      final testDate = DateTime(2023, 10, 26); // October 26, 2023
      await pumpPubDateText(tester, testDate);

      final expectedFormattedDate = formatDateForTest(testDate); // e.g., "Oct 26, 2023"

      // Check if the text is rendered
      final textFinder = find.text(expectedFormattedDate);
      expect(textFinder, findsOneWidget);

      // Check semantics
      expect(
        tester.getSemantics(textFinder),
        matchesSemantics(
          label: expectedFormattedDate,
          isFocusable: false, // Text widgets are not focusable by default
          isInSemanticTree: true, // Should be part of the semantics tree
        ),
      );

      // General a11y guidelines
      await tester.testA11yGuidelines(label: 'PubDateText Oct 26, 2023');
    });

    testWidgets(
        'renders formatted date, has correct semantics, and meets a11y guidelines for date 2',
        (tester) async {
      final testDate = DateTime(2024, 1, 15); // January 15, 2024
      await pumpPubDateText(tester, testDate);

      final expectedFormattedDate = formatDateForTest(testDate); // e.g., "Jan 15, 2024"

      // Check if the text is rendered
      final textFinder = find.text(expectedFormattedDate);
      expect(textFinder, findsOneWidget);

      // Check semantics
      expect(
        tester.getSemantics(textFinder),
        matchesSemantics(
          label: expectedFormattedDate,
          isFocusable: false,
          isInSemanticTree: true,
        ),
      );

      // General a11y guidelines
      await tester.testA11yGuidelines(label: 'PubDateText Jan 15, 2024');
    });

    testWidgets(
        'renders formatted date for a date with single digit day and meets a11y',
        (tester) async {
      final testDate = DateTime(2024, 3, 5); // March 5, 2024
      await pumpPubDateText(tester, testDate);

      final expectedFormattedDate = formatDateForTest(testDate); // e.g., "Mar 5, 2024"

      // Check if the text is rendered
      final textFinder = find.text(expectedFormattedDate);
      expect(textFinder, findsOneWidget);

      // Check semantics
      expect(
        tester.getSemantics(textFinder),
        matchesSemantics(
          label: expectedFormattedDate,
          isFocusable: false,
          isInSemanticTree: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'PubDateText Mar 5, 2024');
    });
  });
}
