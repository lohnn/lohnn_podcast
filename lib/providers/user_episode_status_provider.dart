import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode_with_status.dart';
import 'package:podcast/data/user_episode_status.model.dart';
import 'package:podcast/providers/socket_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_episode_status_provider.g.dart';

@riverpod
class UserEpisodeStatusPod extends _$UserEpisodeStatusPod {
  @override
  Stream<Map<String, UserEpisodeStatus>> build() async* {
    final socketOpen = ref.watch(socketPodProvider);
    if (!socketOpen) return;
    
    ref.keepAlive();
    await for (final status
        in Repository().subscribeToRealtime<UserEpisodeStatus>()) {
      yield {
        for (final status in status) status.episodeId: status,
      };
    }
  }

  Future<void> markListened(EpisodeWithStatus episodeWithStatus) {
    return Repository().upsert<UserEpisodeStatus>(
      episodeWithStatus.status.copyWith(
        isPlayed: true,
      ),
    );
  }

  Future<void> markUnlistened(EpisodeWithStatus episodeWithStatus) {
    return Repository().upsert<UserEpisodeStatus>(
      episodeWithStatus.status.copyWith(
        isPlayed: false,
      ),
    );
  }
}
