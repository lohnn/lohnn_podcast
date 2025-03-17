// Your model definition can live anywhere in lib/**/* as long as it has the .model.dart suffix
// Assume this file is saved at my_app/lib/src/users/user.model.dart

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/uri_model.dart';

part 'podcast_search.model.mapper.dart';

@MappableClass()
class PodcastSearch extends OfflineFirstWithSupabaseModel
    with PodcastSearchMappable {
  final int id;
  @MappableField()
  final UriModel url;
  final String title;
  final String description;
  final String author;
  @MappableField()
  final UriModel artwork;
  final String lastPublished;
  final String language;
  final Map<int, String> categories;

  PodcastSearch({
    required this.id,
    required this.url,
    required this.title,
    required this.description,
    required this.artwork,
    required this.author,
    required this.lastPublished,
    required this.language,
    this.categories = const {},
  });
}
