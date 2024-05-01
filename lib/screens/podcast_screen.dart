import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/screens/async_value_screen.dart';

class PodcastScreen extends AsyncValueWidget<Podcast> {
  final Podcast podcast;

  const PodcastScreen(this.podcast, {super.key});

  @override
  ProviderBase<AsyncValue<Podcast>> get provider => throw UnimplementedError();

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<Podcast> data,
  ) {
    // TODO: implement buildWithData
    throw UnimplementedError();
  }
}
