import 'package:dart_mappable/dart_mappable.dart';

class UriMapper extends SimpleMapper<Uri> {
  const UriMapper();

  @override
  Uri decode(covariant String value) {
    return Uri.parse(value);
  }

  @override
  String? encode(Uri self) {
    return self.toString();
  }
}
