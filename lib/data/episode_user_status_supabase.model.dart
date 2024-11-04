import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/duration_model.dart';

part 'episode_user_status_supabase.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'episodes',
  ),
)
@MappableClass()
class EpisodeUserStatusSupabase extends OfflineFirstWithSupabaseModel
    with EpisodeUserStatusSupabaseMappable {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String userId;
  @Supabase(unique: true)
  final String episodeId;
  final bool listened;
  final DurationModel currentPosition;

  EpisodeUserStatusSupabase({
    required this.userId,
    required this.episodeId,
    required this.listened,
    required this.currentPosition,
  });
}
