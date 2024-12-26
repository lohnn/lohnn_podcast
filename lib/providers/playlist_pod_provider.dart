import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:collection/collection.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/data/play_queue_item.model.dart';
import 'package:podcast/extensions/future_extensions.dart';
import 'package:podcast/extensions/list_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist_pod_provider.g.dart';

@Riverpod(keepAlive: true)
class PlaylistPod extends _$PlaylistPod {
  @override
  Stream<List<Episode>> build() async* {
    try {
      await Repository().get<PlayQueueItem>(forceLocalSyncFromRemote: true);
    } catch (_) {}

    await for (final queue in Repository().subscribe<PlayQueueItem>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: const Query(
        orderBy: [OrderBy('queueOrder')],
      ),
    )) {
      yield [for (final item in queue) item.episode];
    }
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final oldQueue = await future;
    state = AsyncData(oldQueue.reorder(oldIndex, newIndex));
    return _recalculateOrder();
  }

  Future<void> _recalculateOrder() async {
    final queue = await future;
    await queue
        .mapIndexed((index, episode) {
          return PlayQueueItem(episode: episode, queueOrder: index);
        })
        .map((item) => Repository().upsert(item))
        .wait;
  }

  /// Removes the episode from the queue and returns the next episode in the queue
  Future<Episode?> removeFromQueue(Episode episode) async {
    // TODO: If the episode is currently playing, we should start playing the next episode
    final queue = (await future).toList();
    queue.remove(episode);
    state = AsyncData(queue);

    final queueItem = await Repository()
        .get<PlayQueueItem>(query: Query.where('episodeId', episode.id))
        .first;
    await Repository().delete<PlayQueueItem>(queueItem);

    await _recalculateOrder();
    return queue.firstOrNull;
  }

  Future<void> addToTopOfQueue(Episode episode) async {
    final queue = (await future).toList();
    // Make sure to put the episode at the top of the queue if it's already in the queue
    queue.remove(episode);
    state = AsyncData([episode, ...queue]);
    return _recalculateOrder();
  }

  Future<void> addToBottomOfQueue(Episode episode) async {
    final queue = await future;
    state = AsyncData([...queue, episode]);
    return _recalculateOrder();
  }
}
