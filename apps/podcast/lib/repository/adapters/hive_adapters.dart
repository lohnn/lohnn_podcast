import 'package:hive_ce/hive.dart';
import 'package:podcast/data/episode_impl.model.dart';
import 'package:podcast/data/episode_user_status.model.dart';
import 'package:podcast/data/play_queue_item.model.dart';
import 'package:podcast/data/podcast_impl.model.dart';
import 'package:podcast/data/user_episode_status_impl.model.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<EpisodeImpl>(),
  AdapterSpec<EpisodeUserStatus>(),
  AdapterSpec<PlayQueueItem>(),
  AdapterSpec<PodcastImpl>(),
  AdapterSpec<UserEpisodeStatusImpl>(),
])
// Annotations must be on some element
// ignore: unused_element
Future<void> _() async {}
