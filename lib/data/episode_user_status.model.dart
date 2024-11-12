import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/duration_model.dart';

part 'episode_user_status.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'episodes',
  ),
)
@MappableClass()
class EpisodeUserStatus extends OfflineFirstWithSupabaseModel
    with EpisodeUserStatusMappable {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String userId;
  @Supabase(unique: true)
  final String episodeId;
  final bool listened;
  final DurationModel currentPosition;

  EpisodeUserStatus({
    required this.userId,
    required this.episodeId,
    required this.listened,
    required this.currentPosition,
  });
}
