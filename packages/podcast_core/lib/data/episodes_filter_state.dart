import 'package:flutter/foundation.dart';

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
}

enum SortBy {
  date('Date'),
  title('Title'),
  duration('Duration');

  final String name;

  const SortBy(this.name);
}
