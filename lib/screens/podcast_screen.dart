import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/podcast_list_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';

class PodcastScreen extends AsyncValueWidget<List<Podcast>> {
  const PodcastScreen({super.key});

  @override
  ProviderBase<AsyncValue<List<Podcast>>> get provider => podcastProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<List<Podcast>> data,
  ) {
    return ListView(
      children: [
        for (final podcast in data.value) Text(podcast.id),
      ],
    );
  }
}
