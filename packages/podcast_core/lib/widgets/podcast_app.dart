import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/providers/episode_color_scheme_provider.dart';

class PodcastApp extends HookConsumerWidget {
  final Widget child;

  const PodcastApp({super.key, required this.child});

  Future<ColorScheme> _loadDefaultColorScheme(Brightness brightness) async {
    const icon = AssetImage(
      'assets/icons/app_icon.webp',
      package: 'podcast_core',
    );
    return await ColorScheme.fromImageProvider(
      provider: icon,
      brightness: brightness,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final iconColorSchemeFuture = useMemoized(() {
      return _loadDefaultColorScheme(brightness);
    }, [brightness]);
    final iconColorScheme = useFuture(iconColorSchemeFuture).data;

    final colorScheme = ref
        .watch(currentPlayingEpisodeColorSchemeProvider(brightness))
        .value;

    if (colorScheme ?? iconColorScheme case final colorScheme?) {
      return MaterialApp(
        theme: ThemeData.light().copyWith(colorScheme: colorScheme),
        darkTheme: ThemeData.dark().copyWith(colorScheme: colorScheme),
        debugShowCheckedModeBanner: false,
        home: child,
      );
    }

    // If the color scheme is not loaded yet, return an empty container
    return Container();
  }
}
