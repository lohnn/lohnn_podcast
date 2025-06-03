import 'dart:async';
import 'dart:developer' as developer;

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:podcast/data/mappers/uri_mapper.dart';
import 'package:podcast/repository/repository_impl.dart';
import 'package:podcast_core/repository.dart';
import 'package:podcast_core/screens/logged_in/logged_in_screen.dart';
import 'package:podcast_core/widgets/entry_animation_screen.dart';
import 'package:podcast_core/widgets/podcast_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    hierarchicalLoggingEnabled = true;
    Logger.root.level = Level.OFF;
    Logger.root.onRecord.listen((record) {
      developer.log(
        record.message,
        time: record.time,
        level: record.level.value,
        name: record.loggerName,
        stackTrace: record.stackTrace,
        error: record.error,
        sequenceNumber: record.sequenceNumber,
        zone: record.zone,
      );
    });
  }

  MapperContainer.globals.use(const UriMapper());

  runApp(
    ProviderScope(
      overrides: [repositoryProvider.overrideWith((ref) => RepositoryImpl())],
      child: const PodcastApp(
        child: EntryAnimationScreen(child: LoggedInScreen()),
      ),
    ),
  );
}
