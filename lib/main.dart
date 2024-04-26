import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/firebase/user_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/screens/login_screen.dart';
import 'package:podcast/screens/podcast_screen.dart';

Future<void> main() async {
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: const MainApp(),
      ),
    ),
  );
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
      _ => const PodcastScreen(),
    };
  }
}
