import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PodcastApp extends HookWidget {
  final Widget child;

  const PodcastApp({super.key, required this.child});

  Future<({ColorScheme light, ColorScheme dark})> _loadColorScheme() async {
    const icon = AssetImage(
      'assets/icons/app_icon.webp',
      package: 'podcast_core',
    );
    final lightColorScheme = await ColorScheme.fromImageProvider(
      provider: icon,
    );
    final darkColorScheme = await ColorScheme.fromImageProvider(
      provider: icon,
      brightness: Brightness.dark,
    );

    return (light: lightColorScheme, dark: darkColorScheme);
  }

  @override
  Widget build(BuildContext context) {
    final iconColorSchemeFuture = useMemoized(_loadColorScheme);
    final iconColorScheme = useFuture(iconColorSchemeFuture);

    if (iconColorScheme.data case (:final light, :final dark)) {
      return MaterialApp(
        theme: ThemeData.light().copyWith(colorScheme: light),
        darkTheme: ThemeData.dark().copyWith(colorScheme: dark),
        debugShowCheckedModeBanner: false,
        home: child,
      );
    }

    // If the color scheme is not loaded yet, return an empty container
    return Container();
  }
}
