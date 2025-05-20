import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:podcast_core/data/episode_with_status.dart';

@immutable
final class EpisodesFilterState {
  final bool hideListenedEpisodes;
  final SortBy sortBy;
  final bool sortAscending;

  const EpisodesFilterState({
    this.hideListenedEpisodes = false,
    this.sortBy = SortBy.date,
    this.sortAscending = false,
  });

  bool get isDefault => this == const EpisodesFilterState();

  EpisodesFilterState copyWith({
    bool? hideListenedEpisodes,
    SortBy? sortBy,
    bool? sortAscending,
  }) {
    return EpisodesFilterState(
      hideListenedEpisodes: hideListenedEpisodes ?? this.hideListenedEpisodes,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpisodesFilterState &&
          runtimeType == other.runtimeType &&
          hideListenedEpisodes == other.hideListenedEpisodes &&
          sortBy == other.sortBy &&
          sortAscending == other.sortAscending;

  @override
  int get hashCode => Object.hash(hideListenedEpisodes, sortBy, sortAscending);

  List<EpisodeWithStatus> sortEpisodes(
    Iterable<EpisodeWithStatus> filteredEpisodes,
  ) {
    return sortBy.sortEpisodes(filteredEpisodes, sortAscending: sortAscending);
  }
}

enum SortBy {
  date('Date'),
  title('Title'),
  duration('Duration'),
  listened('Listened');

  final String name;

  const SortBy(this.name);

  List<EpisodeWithStatus> sortEpisodes(
    Iterable<EpisodeWithStatus> filteredEpisodes, {
    required bool sortAscending,
  }) {
    return switch (this) {
      SortBy.date => filteredEpisodes.sortedByCompare(
        (episode) => episode.episode.pubDate ?? DateTime(0),
        _sortedComparable<DateTime>(sortAscending),
      ),
      SortBy.title => filteredEpisodes.sortedByCompare(
        (episode) => episode.episode.title,
        _sortedComparable<String>(sortAscending),
      ),
      SortBy.duration => filteredEpisodes.sortedByCompare(
        (episode) => episode.episode.duration ?? Duration.zero,
        _sortedComparable<Duration>(sortAscending),
      ),
      SortBy.listened => SortBy.date
          .sortEpisodes(filteredEpisodes, sortAscending: sortAscending)
          .sortedByCompare((episode) => episode.status?.isPlayed ?? false, (
            a,
            b,
          ) {
            if (sortAscending) {
              return a.compareValue(b);
            } else {
              return b.compareValue(a);
            }
          }),
    };
  }
}

Comparator<T> _sortedComparable<T extends Comparable<T>>(bool ascending) =>
    ascending ? _compareAscendingComparable : _compareDescendingComparable;

int _compareAscendingComparable<T extends Comparable<T>>(T a, T b) =>
    a.compareTo(b);

int _compareDescendingComparable<T extends Comparable<T>>(T a, T b) =>
    b.compareTo(a);

extension on bool {
  // ignore: avoid_positional_boolean_parameters
  int compareValue(bool other) {
    if (this == other) return 0;
    return this ? 1 : -1;
  }
}
