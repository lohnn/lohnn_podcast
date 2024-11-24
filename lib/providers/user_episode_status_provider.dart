import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode_with_status.dart';
import 'package:podcast/data/user_episode_status.model.dart';
import 'package:podcast/helpers/equatable_map.dart';
import 'package:podcast/providers/app_lifecycle_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_episode_status_provider.g.dart';

@riverpod
class UserEpisodeStatusPod extends _$UserEpisodeStatusPod {
  @override
  Stream<EquatableMap<String, UserEpisodeStatus>> build() async* {
    final lifecycleState = ref.watch(appLifecycleStatePodProvider);
    if (lifecycleState != AppLifecycleState.resumed) return;

    ref.keepAlive();
    await for (final status
        in Repository().subscribeToRealtime<UserEpisodeStatus>()) {
      yield {
        for (final status in status) status.episodeId: status,
      }.equatable;
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
