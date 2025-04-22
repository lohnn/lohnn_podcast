// Your model definition can live anywhere in lib/**/* as long as it has the .model.dart suffix
// Assume this file is saved at my_app/lib/src/users/user.model.dart

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/uri_model.dart';
import 'package:podcast_core/data/podcast_search.model.dart' as core;

part 'podcast_search.model.mapper.dart';

@MappableClass()
class PodcastSearch extends OfflineFirstWithSupabaseModel
    with PodcastSearchMappable
    implements core.PodcastSearch {
  @override
  final int id;
  @Supabase(name: 'url')
  @MappableField(key: 'url')
  final UriModel backingUrl;
  @override
  final String title;
  @override
  final String description;
  @override
  final String author;
  @Supabase(name: 'artwork')
  @MappableField(key: 'artwork')
  final UriModel backingArtwork;
  @override
  final String lastPublished;
  @override
  final String language;
  @override
  final Map<int, String> categories;

  PodcastSearch({
    required this.id,
    required this.backingUrl,
    required this.title,
    required this.description,
    required this.backingArtwork,
    required this.author,
    required this.lastPublished,
    required this.language,
    this.categories = const {},
  });

  @override
  @Supabase(ignore: true)
  Uri get artwork => backingArtwork.uri;

  @override
  @Supabase(ignore: true)
  Uri get url => backingUrl.uri;
}
