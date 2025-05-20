import 'package:podcast_core/data/episodes_filter_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episodes_filter_provider.g.dart';

@riverpod
class EpisodesFilter extends _$EpisodesFilter {
  @override
  EpisodesFilterState build() {
    return const EpisodesFilterState();
  }

  void clear() {
    state = const EpisodesFilterState();
  }

  // ignore: avoid_positional_boolean_parameters
  void setHideListened(bool shouldHide) {
    state = state.copyWith(hideListenedEpisodes: shouldHide);
  }

  void changeSortBy(SortBy? sortBy) {
    if (sortBy == null) return;
    state = state.copyWith(sortBy: sortBy);
  }

  void reverseSortOrder() {
    state = state.copyWith(sortAscending: !state.sortAscending);
  }
}
