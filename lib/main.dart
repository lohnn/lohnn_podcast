import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/firebase_options.dart';
import 'package:podcast/providers/firebase/user_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/screens/logged_in_screen.dart';
import 'package:podcast/screens/login_screen.dart';
import 'package:rive/rive.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Repository.configure(databaseFactory);
  await Repository().initialize();

  // Set up crash tracking
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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
                  controller!.addEventListener(
                    (event) {
                      Future.microtask(() {
                        if (event.name == 'Done') {
                          hasShownAnimation.value = true;
                        }
                      });
                    },
                  );
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
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    User? data,
  ) {
    return switch (data) {
      null => const LoginScreen(),
      _ => const LoggedInScreen(),
    };
  }
}
