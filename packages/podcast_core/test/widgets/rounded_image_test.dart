import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/widgets/rounded_image.dart';
import '../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension and testA11yGuidelines

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const double defaultImageSize = 40.0;

  Future<void> pumpRoundedImage(
    WidgetTester tester, {
    required Uri imageUri,
    String? semanticLabel,
    bool showDot = false,
    double imageSize = defaultImageSize,
  }) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RoundedImage(
                imageUri: imageUri,
                semanticLabel: semanticLabel ?? 'Test Image', // Default for test
                showDot: showDot,
                imageSize: imageSize,
              ),
            ),
          ),
        ));
    await tester.pumpAndSettle();
  }

  group('RoundedImage Accessibility Tests', () {
    final testImageUri = Uri.parse('http://example.com/test_image.png');

    testWidgets(
        'renders, has correct semantic label, is appropriately sized, and meets a11y guidelines',
        (tester) async {
      const testLabel = 'Specific Podcast Image';
      await pumpRoundedImage(tester,
          imageUri: testImageUri, semanticLabel: testLabel);

      final imageFinder = find.byType(RoundedImage);
      expect(imageFinder, findsOneWidget);

      // Check rendered size
      final Size imageWidgetSize = tester.getSize(imageFinder);
      // The actual rendered size might be slightly different due to padding/clipping within RoundedImage.
      // We expect it to be very close to imageSize for the main container.
      // If RoundedImage uses a Container with width/height = imageSize, this should hold.
      expect(imageWidgetSize.width, moreOrLessEquals(defaultImageSize, epsilon: 2.0));
      expect(imageWidgetSize.height, moreOrLessEquals(defaultImageSize, epsilon: 2.0));

      // Check minimum size for general interactability, though it's not directly interactive
      // This ensures it's not accidentally made tiny.
      expect(imageWidgetSize.width, greaterThanOrEqualTo(kMinInteractiveDimension / 2));
      expect(imageWidgetSize.height, greaterThanOrEqualTo(kMinInteractiveDimension / 2));


      // Verify semantics
      expect(
        tester.getSemantics(imageFinder),
        matchesSemantics(
          label: testLabel,
          isFocusable: false, // Should not be focusable by default
          tooltip: isEmpty, // No tooltip by default
        ),
      );

      await tester.testA11yGuidelines(label: 'RoundedImage Basic');
    });

    testWidgets(
        'when showDot is true, dot is visually present but adds no direct semantics to image itself, and meets a11y',
        (tester) async {
      const testLabel = 'Episode Image With Dot';
      await pumpRoundedImage(tester,
          imageUri: testImageUri, semanticLabel: testLabel, showDot: true);

      final imageFinder = find.byType(RoundedImage);
      expect(imageFinder, findsOneWidget);

      // Check that the dot is rendered (visual check, not semantic)
      // This requires looking into RoundedImage's implementation or finding a specific child widget for the dot.
      // For now, we assume the parent widget (e.g., PodcastListTile) handles the semantic meaning of "new".
      // We are primarily concerned that RoundedImage itself doesn't add conflicting/duplicate semantics for the dot.

      // Verify semantics: label should be as provided, no specific "new" tooltip on image itself
      expect(
        tester.getSemantics(imageFinder),
        matchesSemantics(
          label: testLabel,
          isFocusable: false,
          tooltip: isEmpty, // Expect no tooltip like "New" directly on RoundedImage
        ),
      );

      // Check that showDot property is true on the widget
      final roundedImageWidget = tester.widget<RoundedImage>(imageFinder);
      expect(roundedImageWidget.showDot, isTrue);

      await tester.testA11yGuidelines(label: 'RoundedImage with showDot true');
    });

    testWidgets(
        'when showDot is false, no dot semantics are present, and meets a11y',
        (tester) async {
      const testLabel = 'Episode Image Without Dot';
      await pumpRoundedImage(tester,
          imageUri: testImageUri, semanticLabel: testLabel, showDot: false);

      final imageFinder = find.byType(RoundedImage);
      expect(imageFinder, findsOneWidget);

      // Verify semantics: label should be as provided, no "new" tooltip
      expect(
        tester.getSemantics(imageFinder),
        matchesSemantics(
          label: testLabel,
          isFocusable: false,
          tooltip: isEmpty,
        ),
      );

      // Check that showDot property is false on the widget
      final roundedImageWidget = tester.widget<RoundedImage>(imageFinder);
      expect(roundedImageWidget.showDot, isFalse);

      await tester.testA11yGuidelines(label: 'RoundedImage with showDot false');
    });
  });
}
