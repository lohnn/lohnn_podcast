import 'package:freezed_annotation/freezed_annotation.dart';

part 'podcast.freezed.dart';
part 'podcast.g.dart';

@freezed
class Podcast with _$Podcast {
  const factory Podcast({
    required String name,
    required String rssUrl,
  }) = _Podcast;

  factory Podcast.fromJson(Map<String, dynamic> json) =>
      _$PodcastFromJson(json);
}
