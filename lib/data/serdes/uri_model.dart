import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'uri_model.mapper.dart';

class UriModelHook extends MappingHook {
  const UriModelHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is String) {
      return {
        'url': value,
      };
    }
    return value;
  }
}

@MappableClass(hook: UriModelHook())
class UriModel extends OfflineFirstSerdes<String, String>
    with UriModelMappable {
  final Uri uri;

  factory UriModel(String url) => UriModel._(Uri.parse(url));

  UriModel._(this.uri);

  factory UriModel.fromRest(String data) => UriModel._(
        Uri.parse(data),
      );

  factory UriModel.fromSupabase(String data) => UriModel._(
        Uri.parse(data),
      );

  factory UriModel.fromSqlite(String data) => UriModel._(
        Uri.parse(data),
      );

  factory UriModel.fromGraphql(String data) => UriModel._(
        Uri.parse(data),
      );

  @override
  String toSqlite() {
    return uri.toString();
  }

  @override
  String toSupabase() {
    return uri.toString();
  }

  @override
  String toRest() {
    return uri.toString();
  }

  @override
  String toGraphql() {
    return uri.toString();
  }
}
