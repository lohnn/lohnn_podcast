import 'package:freezed_annotation/freezed_annotation.dart';

class DurationConverter implements JsonConverter<Duration, int> {
  const DurationConverter();

  @override
  Duration fromJson(int seconds) => Duration(seconds: seconds);

  @override
  int toJson(Duration duration) => duration.inSeconds;
}
