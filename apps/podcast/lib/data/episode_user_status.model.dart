import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/duration_model.dart';
import 'package:podcast_core/data/episode_user_status.model.dart' as core;

part 'episode_user_status.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'episodes'),
)
@MappableClass()
class EpisodeUserStatus extends OfflineFirstWithSupabaseModel
    with EpisodeUserStatusMappable
    implements core.EpisodeUserStatus {
  @override
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String userId;
  @override
  @Supabase(unique: true)
  final String episodeId;
  @override
  final bool listened;
  @Supabase(name: 'current_position')
  final DurationModel backingCurrentPosition;

  EpisodeUserStatus({
    required this.userId,
    required this.episodeId,
    required this.listened,
    required this.backingCurrentPosition,
  });

  @override
  @Supabase(ignore: true)
  Duration get currentPosition => backingCurrentPosition.duration;
}
