import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterHelpers on WidgetTester {
  Future<void> testA11yGuidelines() async {
    final handle = ensureSemantics();

    // Checks that tappable nodes have a minimum size of 48 by 48 pixels
    // for Android.
    await expectLater(this, meetsGuideline(androidTapTargetGuideline));

    // Checks that tappable nodes have a minimum size of 44 by 44 pixels
    // for iOS.
    await expectLater(this, meetsGuideline(iOSTapTargetGuideline));

    // Checks that touch targets with a tap or long press action are labeled.
    await expectLater(this, meetsGuideline(labeledTapTargetGuideline));

    // Checks whether semantic nodes meet the minimum text contrast levels.
    // The recommended text contrast is 3:1 for larger text
    // (18 point and above regular).
    await expectLater(this, meetsGuideline(textContrastGuideline));
    handle.dispose();
  }
}
