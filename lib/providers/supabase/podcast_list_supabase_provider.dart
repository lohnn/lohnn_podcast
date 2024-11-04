import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'podcast_list_supabase_provider.g.dart';

@riverpod
class PodcastListSupabase extends _$PodcastListSupabase {
  @override
  Future<void> build() async {}

  Future<void> migrateFromFirebase(String rssUrl) async {
    final response = await Supabase.instance.client.functions.invoke(
      'add_podcast',
      body: rssUrl,
    );
    print(response.data);

    // TODO: Call remote to add podcast and episodes
    // TODO: Push update to episode_user_status for episodes that have status
  }
}
