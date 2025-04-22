import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/duration_model.dart';
import 'package:podcast_core/data/user_episode_status.model.dart';

part 'user_episode_status_impl.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'user_episode_status'),
)
@MappableClass()
class UserEpisodeStatusImpl extends OfflineFirstWithSupabaseModel
    with UserEpisodeStatusImplMappable
    implements UserEpisodeStatus {
  @override
  @Supabase(unique: true)
  @Sqlite(unique: true)
  final String episodeId;
  @override
  final bool isPlayed;
  @Supabase(name: 'current_position')
  final DurationModel backingCurrentPosition;

  UserEpisodeStatusImpl({
    required this.episodeId,
    required this.isPlayed,
    required this.backingCurrentPosition,
  });

  @override
  Duration get currentPosition => backingCurrentPosition.duration;
}
