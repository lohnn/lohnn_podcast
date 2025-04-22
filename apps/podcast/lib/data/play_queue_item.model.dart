// Your model definition can live anywhere in lib/**/* as long as it has the .model.dart suffix
// Assume this file is saved at my_app/lib/src/users/user.model.dart

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/episode_impl.model.dart';
import 'package:podcast_core/data/play_queue_item.model.dart' as core;

part 'play_queue_item.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'user_play_queue'),
)
@MappableClass()
class PlayQueueItem extends OfflineFirstWithSupabaseModel
    with PlayQueueItemMappable
    implements core.PlayQueueItem {
  @override
  @Supabase(unique: true, foreignKey: 'episode_id', ignoreTo: true)
  final EpisodeImpl episode;
  @override
  final int queueOrder;

  @override
  @Supabase(unique: true, ignoreFrom: true)
  @Sqlite(unique: true, index: true)
  String get episodeId => episode.id;

  PlayQueueItem({required this.episode, required this.queueOrder});
}
