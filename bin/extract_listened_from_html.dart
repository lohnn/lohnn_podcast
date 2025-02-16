// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:html/parser.dart';

void main() async {
  // 1. Load the HTML file
  final dir = Directory('bin/podcast-history');
  final files = dir.listSync().whereType<File>().where(
    (e) => e.path.endsWith('.html'),
  );

  final json = <String, List<String>>{};

  for (final file in files) {
    print('Extracting listened episodes from ${file.path}...');
    final htmlContent = await file.readAsString();

    // 2. Parse the HTML
    final document = parse(htmlContent);

    // 3. Extract podcast title
    final podcastTitle = document.querySelector('title')!.text;

    // 4. Find completed episodes
    final completedEpisodes =
        document
            .querySelectorAll('a.D9uPgd')
            .where(
              (element) => element.querySelector('.USCfSb') != null,
            ) // Check for checkmark icon
            .map((element) => element.querySelector('.e3ZUqe')?.text.trim())
            .where((title) => title != null)
            .cast<String>()
            .toList();

    json[podcastTitle] = completedEpisodes.toList();
  }

  File('bin/listened-episodes.json').writeAsStringSync(jsonEncode(json));
  print('${json.values.flattened.length} listened episodes extracted');
}
