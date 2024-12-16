import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'duration_model.mapper.dart';

@MappableClass()
class DurationModel extends OfflineFirstSerdes<int, int>
    with DurationModelMappable {
  final Duration duration;

  DurationModel(this.duration);

  factory DurationModel.fromRest(int durationMillis) => DurationModel(
        Duration(seconds: durationMillis),
      );

  factory DurationModel.fromSupabase(int durationMillis) {
    return DurationModel(
      Duration(seconds: durationMillis),
    );
  }

  factory DurationModel.fromSqlite(int durationMillis) => DurationModel(
        Duration(seconds: durationMillis),
      );

  factory DurationModel.fromGraphql(int durationMillis) => DurationModel(
        Duration(seconds: durationMillis),
      );

  @override
  int toSqlite() {
    return duration.inSeconds;
  }

  @override
  int toSupabase() {
    return duration.inSeconds;
  }

  @override
  int toRest() {
    return duration.inSeconds;
  }

  @override
  int toGraphql() {
    return duration.inSeconds;
  }
}
