import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/widgets/podcast_list_tile.dart';
import 'package:podcast_core/widgets/rounded_image.dart';
import '../test_data_models/test_podcast.dart';
import '../../helpers/widget_tester_helpers.dart'; // Added import

// Mocks
class MockVoidCallback extends Mock implements VoidCallback {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockImageUrl = Uri.parse('http://example.com/image_a11y.png');
  const mockName = 'Test Podcast Name for A11y';
  final mockPodcastFromFactory = testPodcast.copyWith(
    title: 'Factory Podcast Title A11y',
    artwork: Uri.parse('http://example.com/factory_image_a11y.png'),
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
    testWidgets('renders correctly basic state and checks key semantics', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidget(tester, imageUrl: mockImageUrl, name: mockName, onTap: mockOnTap);
        await tester.pumpAndSettle();

        expect(find.byType(PodcastListTile), findsOneWidget);

        final listTileFinder = find.byType(ListTile);
        expect(listTileFinder, findsOneWidget);
        final listTileSemantics = tester.getSemantics(listTileFinder);
        expect(listTileSemantics, matchesSemantics(
            hasTapAction: true,
            isFocusable: true, // ListTile itself is focusable if it has an onTap
            label: contains(mockName),
        ));
        // Check that the name is indeed part of the ListTile's primary content for semantics
        expect(find.descendant(of: listTileFinder, matching: find.text(mockName)), findsOneWidget);


        final roundedImageFinder = find.byType(RoundedImage);
        expect(roundedImageFinder, findsOneWidget);
        final roundedImage = tester.widget<RoundedImage>(roundedImageFinder);
        expect(roundedImage.showDot, isFalse);
        expect(roundedImage.imageUri, mockImageUrl);

        final roundedImageSemantics = tester.getSemantics(roundedImageFinder);
        expect(roundedImageSemantics.label, 'Podcast image');
        expect(roundedImageSemantics.tooltip, isEmpty);


        final listTileWidget = tester.widget<ListTile>(listTileFinder);
        expect(listTileWidget.trailing, isNull);
      });
    });

    testWidgets('renders correctly with showDot true', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidget(tester, imageUrl: mockImageUrl, name: mockName, onTap: mockOnTap, showDot: true);
        await tester.pumpAndSettle();

        final roundedImage = tester.widget<RoundedImage>(find.byType(RoundedImage));
        expect(roundedImage.showDot, isTrue);
        // No change in semantic label or tooltip for RoundedImage based on showDot in PodcastListTile
        final roundedImageSemantics = tester.getSemantics(find.byType(RoundedImage));
        expect(roundedImageSemantics.label, 'Podcast image');
        expect(roundedImageSemantics.tooltip, isEmpty);
      });
    });

    testWidgets('renders correctly with trailing widget', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final mockTrailingWidget = Icon(Icons.arrow_forward, key: UniqueKey());
        await pumpWidget(
            tester, imageUrl: mockImageUrl, name: mockName, onTap: mockOnTap, trailing: mockTrailingWidget);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
        final listTile = tester.widget<ListTile>(find.byType(ListTile));
        expect(listTile.trailing, isNotNull);
      });
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidget(tester, imageUrl: mockImageUrl, name: mockName, onTap: mockOnTap);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(PodcastListTile));
        await tester.pump();

        verify(() => mockOnTap()).called(1);
      });
    });

    testWidgets('renders correctly using .podcast factory and checks key semantics', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        const trailingText = Text('Factory Trailing A11y');
        await pumpFactoryWidget(
          tester,
          podcast: mockPodcastFromFactory,
          onTap: mockOnTap,
          showDot: true,
          trailing: trailingText,
        );
        await tester.pumpAndSettle();

        final listTileFinder = find.byType(ListTile);
        expect(listTileFinder, findsOneWidget);
        final listTileSemantics = tester.getSemantics(listTileFinder);
        expect(listTileSemantics, matchesSemantics(
            hasTapAction: true,
            isFocusable: true,
            label: contains(mockPodcastFromFactory.title),
        ));
        expect(listTileSemantics.label, contains('Factory Trailing A11y')); // Trailing text also part of label

        expect(find.text(mockPodcastFromFactory.title), findsOneWidget);
        expect(find.text('Factory Trailing A11y'), findsOneWidget);

        final roundedImage = tester.widget<RoundedImage>(find.byType(RoundedImage));
        expect(roundedImage.showDot, isTrue);
        expect(roundedImage.imageUri, mockPodcastFromFactory.artwork);

        final roundedImageSemantics = tester.getSemantics(find.byType(RoundedImage));
        expect(roundedImageSemantics.label, 'Podcast image'); // Semantic label is static
        expect(roundedImageSemantics.tooltip, isEmpty);

        await tester.tap(find.byType(PodcastListTile));
        await tester.pump();
        verify(() => mockOnTap()).called(1);
      });
    });

    testWidgets('passes accessibility guidelines', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidget(tester, imageUrl: mockImageUrl, name: mockName, onTap: mockOnTap, showDot: false);
        await tester.pumpAndSettle();
        await tester.testA11yGuidelines();
      });
    });

    testWidgets('passes accessibility guidelines for .podcast factory', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        const trailingText = Text('Factory A11y Check');
        await pumpFactoryWidget(
          tester,
          podcast: mockPodcastFromFactory,
          onTap: mockOnTap,
          showDot: true,
          trailing: trailingText,
        );
        await tester.pumpAndSettle();
        await tester.testA11yGuidelines();
      });
    });
  });
}
