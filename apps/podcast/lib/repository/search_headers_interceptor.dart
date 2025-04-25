import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:podcast/secrets.dart';

class SearchHeadersInterceptor extends Interceptor {
  const SearchHeadersInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiHeaderTime =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

    final hash = sha1.convert(
      utf8.encode(
        Secrets.searchApiKey + Secrets.searchApiSecret + apiHeaderTime,
      ),
    );

    options.headers.addAll({
      'User-Agent': 'LohnnPodcast/1.0',
      'X-Auth-Key': Secrets.searchApiKey,
      'X-Auth-Date': apiHeaderTime,
      'Authorization': hash,
    });
    return handler.next(options);
  }
}
