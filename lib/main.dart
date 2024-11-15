import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/providers/audio_player_provider.dart';
import 'package:podcast/providers/socket_provider.dart';
import 'package:podcast/providers/user_provider.dart';
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
    useOnAppLifecycleStateChange(
      (previous, current) {
        // Open and close the socket connection based on the app lifecycle state
        switch (current) {
          case AppLifecycleState.resumed:
            ref.read(socketPodProvider.notifier).open();
          case AppLifecycleState.paused:
            ref.read(socketPodProvider.notifier).close();
            ref.read(audioPlayerPodProvider.notifier).timeStopPlaying();
          case _:
        }
      },
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) async {
        final shouldClose = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you sure you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );

        if (!(shouldClose ?? false)) return;

        // Kill the app if the user tries to pop the main screen
        // Stopping the audio player
        await ref.read(audioPlayerPodProvider.notifier).dispose();
        // Stopping all sockets
        ref.read(socketPodProvider.notifier).close();
        // Closing the app
        SystemNavigator.pop();
      },
      child: switch (data) {
        null => const LoginScreen(),
        _ => const LoggedInScreen(),
      },
    );
  }
}
