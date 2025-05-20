extension DurationExtensions on Duration {
  String prettyPrint() {
    // final negativeSign = isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(inMinutes.remainder(60).abs());
    final twoDigitSeconds = twoDigits(inSeconds.remainder(60).abs());
    return '${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
