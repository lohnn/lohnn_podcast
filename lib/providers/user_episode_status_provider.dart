import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/user_episode_status.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_episode_status_provider.g.dart';

@Riverpod(keepAlive: true)
class UserEpisodeStatusPod extends _$UserEpisodeStatusPod {
  @override
  Stream<Map<String, UserEpisodeStatus>> build() async* {
    await for (final status
        in Repository().subscribeToRealtime<UserEpisodeStatus>()) {
      yield {
        for (final status in status) status.episodeId: status,
      };
    }
  }
}
