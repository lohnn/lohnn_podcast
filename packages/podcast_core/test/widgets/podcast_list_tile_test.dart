import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/widgets/podcast_list_tile.dart';
import 'package:podcast_core/widgets/rounded_image.dart';

import '../helpers/mock_void_callback.dart';
import '../helpers/widget_tester_helpers.dart'; // Added import
import '../test_data_models/test_podcast.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockImageUrl = Uri.parse('http://example.com/image_a11y.png');
  const mockName = 'Test Podcast Name for A11y';
  final mockPodcastFromFactory = TestPodcast.mocked(
    title: 'Factory Podcast Title A11y',
    artwork: 'http://example.com/factory_image_a11y.png',
  );

  late MockVoidCallback mockOnTap;

  setUp(() {
    mockOnTap = MockVoidCallback();
  });

  // Helper to pump the widget
  Future<void> pumpWidget(
    WidgetTester tester, {
    required Uri imageUrl,
    required String name,
    VoidCallback? onTap,
    bool showDot = false,
    Widget? trailing,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: PodcastListTile(
              imageUrl: imageUrl,
              name: name,
              onTap: onTap ?? () {},
              showDot: showDot,
              trailing: trailing,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pumpFactoryWidget(
    WidgetTester tester, {
    required Podcast podcast,
    VoidCallback? onTap,
    bool showDot = false,
    Widget? trailing,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: PodcastListTile.podcast(
              podcast,
              onTap: onTap ?? () {},
              showDot: showDot,
              trailing: trailing,
            ),
          ),
        ),
      ),
    );
  }

  group('PodcastListTile Tests', () {
    testWidgets('renders correctly basic state and checks key semantics', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpWidget(
          tester,
          imageUrl: mockImageUrl,
          name: mockName,
          onTap: mockOnTap,
        );
        await tester.pumpAndSettle();

        expect(find.byType(PodcastListTile), findsOneWidget);

        final listTileFinder = find.byType(ListTile);
        expect(listTileFinder, findsOneWidget);

        // Tap Target Size
        expect(tester.getSize(listTileFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(listTileFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

        // Semantic Label and Tappable State
        expect(
          tester.getSemantics(listTileFinder),
          matchesSemantics(
            isTappable: true,
            label: mockName, // When showDot is false, label is just the name
          ),
        );

        final roundedImageFinder = find.byType(RoundedImage);
        expect(roundedImageFinder, findsOneWidget);
        // General size check for RoundedImage
        expect(tester.getSize(roundedImageFinder).width, greaterThanOrEqualTo(24.0)); // Example reasonable min size
        expect(tester.getSize(roundedImageFinder).height, greaterThanOrEqualTo(24.0));
        final roundedImage = tester.widget<RoundedImage>(roundedImageFinder);
        expect(roundedImage.showDot, isFalse);
        expect(roundedImage.imageUri, mockImageUrl);

        final roundedImageSemantics = tester.getSemantics(roundedImageFinder);
        expect(roundedImageSemantics.label, 'Podcast image');
        expect(roundedImageSemantics.tooltip, isEmpty); // No tooltip when showDot is false

        final listTileWidget = tester.widget<ListTile>(listTileFinder);
        expect(listTileWidget.trailing, isNull);
        await tester.testA11yGuidelines(label: "PodcastListTile Basic State");
      });
    });

    testWidgets('renders correctly with showDot true and checks semantics', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpWidget(
          tester,
          imageUrl: mockImageUrl,
          name: mockName,
          onTap: mockOnTap,
          showDot: true,
        );
        await tester.pumpAndSettle();

        final listTileFinder = find.byType(ListTile);
        expect(listTileFinder, findsOneWidget);
        // Tap Target Size
        expect(tester.getSize(listTileFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(listTileFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

        // Semantic Label includes "New episodes" hint when showDot is true
        expect(
          tester.getSemantics(listTileFinder),
          matchesSemantics(
            isTappable: true,
            label: '$mockName, New episodes', // Enhanced label for showDot
          ),
        );

        final roundedImage = tester.widget<RoundedImage>(find.byType(RoundedImage));
        expect(roundedImage.showDot, isTrue);

        // RoundedImage semantics: still no tooltip directly on it, info is on parent ListTile
        final roundedImageSemantics = tester.getSemantics(find.byType(RoundedImage));
        expect(roundedImageSemantics.label, 'Podcast image');
        expect(roundedImageSemantics.tooltip, isEmpty);
        // Alternative: Add tooltip to RoundedImage if ListTile label enhancement is not desired
        // expect(roundedImageSemantics.tooltip, 'New episodes');

        await tester.testA11yGuidelines(label: "PodcastListTile with showDot true");
      });
    });

    testWidgets('renders correctly with trailing widget and checks accessibility', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        const mockTrailingText = Text('Trailing Info');
        await pumpWidget(
          tester,
          imageUrl: mockImageUrl,
          name: mockName,
          onTap: mockOnTap,
          trailing: mockTrailingText,
        );
        await tester.pumpAndSettle();

        expect(find.text('Trailing Info'), findsOneWidget);
        final listTileFinder = find.byType(ListTile);
        expect(listTileFinder, findsOneWidget);
        // Tap Target Size
        expect(tester.getSize(listTileFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(listTileFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

        // Semantic label includes trailing text
        expect(
          tester.getSemantics(listTileFinder),
          matchesSemantics(
            isTappable: true,
            label: '$mockName, Trailing Info', // Label includes non-interactive trailing text
          ),
        );
        await tester.testA11yGuidelines(label: "PodcastListTile with Trailing Widget");
      });
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidget(
          tester,
          imageUrl: mockImageUrl,
          name: mockName,
          onTap: mockOnTap,
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(PodcastListTile));
        await tester.pump();

        verify(() => mockOnTap()).called(1);
      });
    });

    testWidgets(
      'renders correctly using .podcast factory and checks key semantics',
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          const trailingTextWidget = Text('Factory Trailing A11y');
          await pumpFactoryWidget(
            tester,
            podcast: mockPodcastFromFactory,
            onTap: mockOnTap,
            showDot: true, // showDot is true
            trailing: trailingTextWidget,
          );
          await tester.pumpAndSettle();

          final listTileFinder = find.byType(ListTile);
          expect(listTileFinder, findsOneWidget);
          // Tap Target Size
          expect(tester.getSize(listTileFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
          expect(tester.getSize(listTileFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

          // Semantic Label and Tappable State
          // Includes title, "New episodes" (from showDot), and trailing text
          expect(
            tester.getSemantics(listTileFinder),
            matchesSemantics(
              isTappable: true,
              // Example: "Factory Podcast Title A11y, New episodes, Factory Trailing A11y"
              // The exact order and separators depend on how ListTile merges semantics.
              // We'll check for presence of all parts.
              label: allOf(
                contains(mockPodcastFromFactory.title),
                contains('New episodes'),
                contains('Factory Trailing A11y')
              ),
            ),
          );

          expect(find.text(mockPodcastFromFactory.title), findsOneWidget);
          expect(find.text('Factory Trailing A11y'), findsOneWidget);

          final roundedImage = tester.widget<RoundedImage>(find.byType(RoundedImage));
          expect(roundedImage.showDot, isTrue);
          expect(roundedImage.imageUri, mockPodcastFromFactory.artwork);

          final roundedImageSemantics = tester.getSemantics(find.byType(RoundedImage));
          expect(roundedImageSemantics.label, 'Podcast image');
          expect(roundedImageSemantics.tooltip, isEmpty); // Info conveyed by parent ListTile

          await tester.tap(find.byType(PodcastListTile));
          await tester.pump();
          verify(() => mockOnTap()).called(1);
          await tester.testA11yGuidelines(label: "PodcastListTile.podcast Factory");
        });
      },
    );

    // Removed standalone 'passes accessibility guidelines' tests as they are now integrated
    // into the specific state tests (basic, showDot, trailing, factory).
    // testWidgets('passes accessibility guidelines', (WidgetTester tester) async {
    //   await mockNetworkImagesFor(() async {
    //     await pumpWidget(
    //       tester,
    //       imageUrl: mockImageUrl,
    //       name: mockName,
    //       onTap: mockOnTap,
    //       showDot: false,
    //     );
    //     await tester.pumpAndSettle();
    //     await tester.testA11yGuidelines();
    //   });
    // });

    // testWidgets('passes accessibility guidelines for .podcast factory', (
    //   WidgetTester tester,
    // ) async {
    //   await mockNetworkImagesFor(() async {
    //     const trailingText = Text('Factory A11y Check');
        // await pumpFactoryWidget(
        //   tester,
        //   podcast: mockPodcastFromFactory,
        //   onTap: mockOnTap,
        //   showDot: true,
        //   trailing: trailingText,
        // );
        // await tester.pumpAndSettle();
        // await tester.testA11yGuidelines();
      // });
    // });
  });
}
