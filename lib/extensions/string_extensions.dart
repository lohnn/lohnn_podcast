import 'package:intl/intl.dart';

extension StringExtensions on String {
  String removeHtmlTags() => Bidi.stripHtmlIfNeeded(this).trim();
}
