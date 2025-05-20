import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episodes_filter_state.dart';
import 'package:podcast_core/providers/episodes_filter_provider.dart';

class FilterEpisodesPopup extends ConsumerWidget {
  const FilterEpisodesPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(episodesFilterProvider);
    final filterStateNotifier = ref.read(episodesFilterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            'Filter episodes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          trailing: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                key: ValueKey(filterState.isDefault),
                filterState.isDefault ? Icons.delete_outline : Icons.delete,
              ),
            ),
            tooltip: 'Clear all filters',
            onPressed: filterState.isDefault ? null : filterStateNotifier.clear,
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text('Hide played episodes'),
          onTap: () {
            filterStateNotifier.setHideListened(
              !filterState.hideListenedEpisodes,
            );
          },
          trailing: Switch(
            value: filterState.hideListenedEpisodes,
            onChanged: filterStateNotifier.setHideListened,
          ),
        ),
        ListTile(
          title: const Text('Sort by'),
          subtitle: DropdownButton(
            isExpanded: true,
            onChanged: filterStateNotifier.changeSortBy,
            value: filterState.sortBy,
            items: [
              for (final sortBy in SortBy.values)
                DropdownMenuItem(value: sortBy, child: Text(sortBy.name)),
            ],
          ),
          // TODO: Add a better icon for this
          trailing: IconButton(
            onPressed: filterStateNotifier.reverseSortOrder,
            tooltip: 'Change sort order',
            icon: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: filterState.sortAscending ? -1.0 : 1.0),
              curve: Curves.easeOutBack,
              duration: const Duration(milliseconds: 200),
              builder: (BuildContext context, double scaleY, Widget? child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(1.0, scaleY),
                  child: child,
                );
              },
              child: const Icon(Icons.sort),
            ),
          ),
        ),
      ],
    );
  }
}
