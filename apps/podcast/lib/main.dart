import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/default_firebase_config.dart';
import 'package:podcast/helpers/platform_helpers.dart';
import 'package:podcast/providers/app_lifecycle_state_provider.dart';
import 'package:podcast/providers/user_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/screens/logged_in/logged_in_screen.dart';
import 'package:podcast/screens/login_screen.dart';
import 'package:rive/rive.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    hierarchicalLoggingEnabled = true;
    Logger.root.level = Level.ALL;
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

  // @TODO: Add Firebase configuration to the init-script?
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'lohnn-podcast',
  );

  if (isWeb) {
    // Change default factory on the web
    databaseFactory = databaseFactoryFfiWeb;
  } else if (isDesktop) {
    databaseFactory = databaseFactoryFfi;
  }
  await Repository.configure(databaseFactory);
  await Repository().initialize();

  const icon = AssetImage('assets/icons/app_icon.webp');
  final lightColorScheme = await ColorScheme.fromImageProvider(provider: icon);
  final darkColorScheme = await ColorScheme.fromImageProvider(
    provider: icon,
    brightness: Brightness.dark,
  );

  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData.light().copyWith(colorScheme: lightColorScheme),
        darkTheme: ThemeData.dark().copyWith(colorScheme: darkColorScheme),
        debugShowCheckedModeBanner: false,
        home: const EntryAnimationScreen(),
      ),
    ),
  );
}

class EntryAnimationScreen extends HookWidget {
  const EntryAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hasShownAnimation = useState(false);

    return Stack(
      key: const ValueKey('EntryAnimationScreen.entryAnimation'),
      children: [
        const MainApp(key: ValueKey('EntryAnimationScreen.mainApp')),
        if (!hasShownAnimation.value) ...[
          const Positioned.fill(
            child: RiveAnimation.asset(
              fit: BoxFit.cover,
              'assets/animations/podcast_icon_background.riv',
              animations: ['Enter'],
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: RiveAnimation.asset(
                'assets/animations/podcast_icon_foreground.riv',
                animations: const ['Enter'],
                onInit: (artboard) {
                  final controller = StateMachineController.fromArtboard(
                    artboard,
                    'State Machine 1',
                  );
                  controller!.addEventListener((event) {
                    Future.microtask(() {
                      if (event.name == 'Done') {
                        hasShownAnimation.value = true;
                      }
                    });
                  });
                  artboard.addController(controller);
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class MainApp extends AsyncValueWidget<User?> {
  const MainApp({super.key});

  @override
  ProviderBase<AsyncValue<User?>> get provider => userPodProvider;

  @override
  Widget buildWithData(BuildContext context, WidgetRef ref, User? data) {
    useOnAppLifecycleStateChange((previous, current) {
      // Open and close the socket connection based on the app lifecycle state
      ref.read(appLifecycleStatePodProvider.notifier).lifecycleState = current;
    });
    return switch (data) {
      null => const LoginScreen(),
      _ => const LoggedInScreen(),
    };
  }
}
