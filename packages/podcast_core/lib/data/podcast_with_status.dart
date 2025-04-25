import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast_core/data/podcast_search.model.dart';

part 'podcast_with_status.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class PodcastWithStatus with PodcastWithStatusMappable {
  final PodcastSearch podcast;
  final int? totalEpisodes;
  final int? listenedEpisodes;
  final bool? hasUnseenEpisodes;

  const PodcastWithStatus({
    required this.podcast,
    required int this.listenedEpisodes,
    required int this.totalEpisodes,
    required bool this.hasUnseenEpisodes,
  });

  const PodcastWithStatus.notListened({required this.podcast})
      : totalEpisodes = null,
        listenedEpisodes = null,
        hasUnseenEpisodes = null;
}
