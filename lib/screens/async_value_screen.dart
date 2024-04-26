import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/screens/error_screen.dart';
import 'package:podcast/screens/loading_screen.dart';

abstract class AsyncValueWidget<T> extends HookConsumerWidget {
  const AsyncValueWidget({super.key});

  ProviderBase<AsyncValue<T>> get provider;

  Widget buildWithData(BuildContext context, WidgetRef ref, AsyncData<T> data);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: switch (ref.watch(provider)) {
        AsyncData<T> data => buildWithData(context, ref, data),
        AsyncError<T> state when !state.isLoading => ErrorScreen(
            state,
            onRefresh: () => ref.invalidate(provider),
          ),
        _ => const LoadingScreen(),
      },
    );
  }
}
