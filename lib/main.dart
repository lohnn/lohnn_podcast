import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/extensions/nullability_extensions.dart';
import 'package:podcast/firebase_options.dart';
import 'package:podcast/hooks/use_rive_controller.dart';
import 'package:podcast/providers/firebase/user_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/screens/logged_in_screen.dart';
import 'package:podcast/screens/login_screen.dart';
import 'package:rive/rive.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  final lightColorScheme = await ColorScheme.fromImageProvider(
    provider: icon,
  );
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

    return AnimatedSwitcher(
      key: const ValueKey('EntryAnimationScreen.animatedSwitcher'),
      duration: const Duration(milliseconds: 300),
      child: hasShownAnimation.value
          ? const MainApp(key: ValueKey('EntryAnimationScreen.mainApp'))
          : Stack(
              key: const ValueKey('EntryAnimationScreen.entryAnimation'),
              children: [
                Positioned.fill(
                  child: createCompatVectorGraphic(
                    fit: BoxFit.cover,
                    colorFilter:
                        (Theme.of(context).brightness == Brightness.dark)
                            .thenOrNull(
                      () => ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.darken,
                      ),
                    ),
                    loader: const AssetBytesLoader(
                      'assets/vectors/background.svg',
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: RiveAnimation.asset(
                      'assets/animations/podcast_icon.riv',
                      animations: const ['Enter'],
                      controllers: [
                        useRiveController(
                          onDone: () => hasShownAnimation.value = true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
    AsyncData<User?> data,
  ) {
    return switch (data.value) {
      null => const LoginScreen(),
      _ => const LoggedInScreen(),
    };
  }
}
