import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episodes_filter_state.dart';
import 'package:podcast_core/extensions/text_style_extensions.dart';
import 'package:podcast_core/providers/episodes_filter_provider.dart';
import 'package:podcast_core/widgets/rive/podcast_animation.dart';
import 'package:podcast_core/widgets/rive/podcast_animation_config.dart';

class FilterEpisodesPopup extends ConsumerWidget {
  const FilterEpisodesPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(episodesFilterProvider);
    final filterStateNotifier = ref.read(episodesFilterProvider.notifier);

    final theme = Theme.of(context);
    return Focus(
      autofocus: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Filter episodes', style: theme.textTheme.titleLarge),
            trailing: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: PodcastAnimation(
                  animationArtboard: PodcastAnimationConfig.delete(
                    isDefaultFilterState: filterState.isDefault,
                  ),
                ),
              ),
              tooltip: 'Clear all filters',
              onPressed: filterState.isDefault
                  ? null
                  : filterStateNotifier.clear,
            ),
          ),
          const Divider(),
          Semantics(
            label: 'Hide played episodes',
            toggled: filterState.hideListenedEpisodes,
            child: ListTile(
              title: const Text('Hide played episodes'),
              onTap: () {
                filterStateNotifier.setHideListened(
                  !filterState.hideListenedEpisodes,
                );
              },
              trailing: Semantics(
                excludeSemantics: true,
                child: ExcludeFocus(
                  child: IgnorePointer(
                    child: Switch(
                      value: filterState.hideListenedEpisodes,
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Sort by',
              style: theme.textTheme.bodySmall?.withOpacity(),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: filterStateNotifier.changeSortBy,
                      value: filterState.sortBy,
                      items: [
                        for (final sortBy in SortBy.values)
                          DropdownMenuItem(
                            value: sortBy,
                            child: Text(sortBy.name),
                          ),
                      ],
                    ),
                  ),
                  Tooltip(
                    excludeFromSemantics: true,
                    message: 'Change sort order',
                    child: Semantics(
                      label: 'Reverse sort order',
                      value: filterState.sortAscending
                          ? 'Sort ascending'
                          : 'Sort descending',
                      child: InkResponse(
                        onTap: filterStateNotifier.reverseSortOrder,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: PodcastAnimation(
                            animationArtboard: PodcastAnimationConfig.sortOrder(
                              isSortingAscending: filterState.sortAscending,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
