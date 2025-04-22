import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/data/play_queue_item.model.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/data/podcast_search.model.dart';
import 'package:podcast_core/data/podcast_with_status.dart';
import 'package:podcast_core/data/user_episode_status.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

// This needs to be overridden by the app to provide a concrete implementation
@riverpod
Repository repository(RepositoryRef ref) {
  throw UnimplementedError();
}

abstract class Repository {
  Future<UserEpisodeStatus> getUserEpisodeStatus(String episodeId);

  Stream<List<UserEpisodeStatus>> watchUserEpisodeStatus();

  Future<void> markEpisodeListened(
    EpisodeWithStatus episodeWithStatus, {
    bool isPlayed = true,
  });

  Future<void> updateEpisodePosition(Episode episode, Duration position);

  Stream<List<Episode>> watchEpisodesFor({required String podcastId});

  Future<void> updateLastSeenPodcast(Podcast podcast);

  Future<List<Podcast>> getPodcasts();

  Stream<List<Podcast>> watchPodcasts();

  Future<void> subscribeToPodcast(String rssUrl);

  Future<void> unsubscribeFromPodcast(String rssUrl);

  Future<void> refreshPodcast(String rssUrl);

  Future<List<PlayQueueItem>> getPlayQueue();

  Future<PlayQueueItem> getPlayQueueItem(Episode episode);

  Stream<List<PlayQueueItem>> watchPlayQueue();

  Future<void> updatePlayQueueItemPosition(Episode episode, int position);

  Future<void> deletePlayQueueItem(PlayQueueItem item);

  ProviderListenable<Object?> get userPodcastSubscriptionsChangesProvider;

  ProviderListenable<Object?> get episodesInsertedProvider;

  Future<List<PodcastSearch>> findPodcasts([String? searchTerm]);

  Future<List<PodcastWithStatus>> getPodcastsWithCount();

  Future<void> checkInUser();
}
