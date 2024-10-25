import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode_supabase.model.dart';
import 'package:podcast/providers/firebase/user_provider.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  Future<void> fetchSupabaseData() async {
    await for (final temp in Repository().subscribe<EpisodeSupabase>(
      policy: OfflineFirstGetPolicy.alwaysHydrate,
    )) {
      print(temp);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        fetchSupabaseData();
        return null;
      },
      [],
    );
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              ref.read(userPodProvider.notifier).logIn();
            },
            child: const Text('Log in'),
          ),
        ],
      ),
    );
  }
}
