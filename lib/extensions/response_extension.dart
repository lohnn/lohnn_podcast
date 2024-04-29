import 'package:dio/dio.dart';
import 'package:xml/xml.dart';

extension ResponseExtensions<E> on Response<E> {
  List<T> dataAsList<T>(FromJson<T> convert) {
    return (data! as List).dataAsList(convert);
  }

  Set<T> dataAsSet<T>(FromJson<T> convert) {
    return (data! as List).dataAsSet(convert);
  }

  T dataAsSingle<T>(FromJson<T> convert) {
    return convert(data! as Map<String, dynamic>);
  }

  T xmlAsSingle<T>(FromXml<T> convert) {
    return convert(XmlDocument.parse(data! as String));
  }
}

extension JsonFormatExtension<E> on List<E> {
  List<T> dataAsList<T>(FromJson<T> convert) {
    return cast<Map<String, dynamic>>().map(convert).toList();
  }

  Set<T> dataAsSet<T>(FromJson<T> convert) {
    return cast<Map<String, dynamic>>().map(convert).toSet();
  }
}

typedef FromJson<T> = T Function(Map<String, dynamic> json);
typedef FromXml<T> = T Function(XmlDocument xml);

abstract class ToJson {
  Map<String, dynamic> toJson();
}
