import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/duration_model.dart';

part 'user_episode_status.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'user_episode_status',
  ),
)
@MappableClass()
class UserEpisodeStatus extends OfflineFirstWithSupabaseModel
    with UserEpisodeStatusMappable {
  @Supabase(unique: true)
  @Sqlite(unique: true)
  final String episodeId;
  @Supabase(unique: true)
  @Sqlite(unique: true)
  final String userId;
  final bool isPlayed;
  final DurationModel currentPosition;

  UserEpisodeStatus({
    required this.episodeId,
    required this.userId,
    required this.isPlayed,
    required this.currentPosition,
  });
}
