import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'duration_model.mapper.dart';

@MappableClass()
class DurationModel extends OfflineFirstSerdes<int, int>
    with DurationModelMappable {
  final Duration duration;

  DurationModel(this.duration);

  factory DurationModel.fromRest(int durationMillis) => DurationModel(
        Duration(milliseconds: durationMillis),
      );

  factory DurationModel.fromSupabase(int durationMillis) {
    return DurationModel(
      Duration(milliseconds: durationMillis),
    );
  }

  factory DurationModel.fromSqlite(int durationMillis) => DurationModel(
        Duration(milliseconds: durationMillis),
      );

  factory DurationModel.fromGraphql(int durationMillis) => DurationModel(
        Duration(milliseconds: durationMillis),
      );

  @override
  int toSqlite() {
    return duration.inMilliseconds;
  }

  @override
  int toSupabase() {
    return duration.inMilliseconds;
  }

  @override
  int toRest() {
    return duration.inMilliseconds;
  }

  @override
  int toGraphql() {
    return duration.inMilliseconds;
  }
}
