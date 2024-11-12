// Your model definition can live anywhere in lib/**/* as long as it has the .model.dart suffix
// Assume this file is saved at my_app/lib/src/users/user.model.dart

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/episode.model.dart';

part 'play_queue_item.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'user_play_queue',
  ),
)
@MappableClass()
class PlayQueueItem extends OfflineFirstWithSupabaseModel
    with PlayQueueItemMappable {
  @Supabase(unique: true, name: 'episode_id')
  final Episode episode;
  final int queueOrder;

  @Supabase(ignore: true)
  @Sqlite(unique: true, index: true)
  String get episodeId => episode.id;

  PlayQueueItem({
    required this.episode,
    required this.queueOrder,
  });
}
