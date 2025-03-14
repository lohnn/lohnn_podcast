import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';

void main(List<String> args) {
  final String? outputFile;
  if (args.indexOf('-o') case final fileIndex when fileIndex != -1 &&
      args.length > fileIndex + 1) {
    outputFile = args[fileIndex + 1];
  } else {
    outputFile = null;
  }

  final pubspecFile = File('apps/podcast/pubspec.yaml');
  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspec = Pubspec.parse(pubspecContent);

  final releaseVersion = pubspec.version;
  if (releaseVersion == null) {
    stdout.writeln('No version found in pubspec.yaml');
    exit(1);
  }

  final changelogFile = File('apps/podcast/CHANGELOG.md');
  final changelogContent = changelogFile.readAsStringSync();

  final escapedReleaseVersion = RegExp.escape(
    releaseVersion.canonicalizedVersion,
  );

  final versionRegex = RegExp(
    '\\#\\#\\s$escapedReleaseVersion\\s*(\n(.*\n)*?)\\#\\#',
  );

  final changelogForVersion = switch (versionRegex
      .allMatches(changelogContent)
      .firstOrNull
      ?.group(1)
      ?.trim()) {
    null || '' => 'No release notes found for version $releaseVersion',
    final notes => notes,
  };

  if (outputFile != null) {
    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsStringSync(changelogForVersion);
    stdout.writeln('Release notes written to $outputFile');
  }

  stdout.writeln(changelogForVersion);
}
