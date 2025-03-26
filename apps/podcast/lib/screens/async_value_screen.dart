import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/screens/error_screen.dart';
import 'package:podcast/screens/loading_screen.dart';

abstract class AsyncValueWidget<T> extends HookConsumerWidget {
  const AsyncValueWidget({super.key});

  ProviderBase<AsyncValue<T>> get provider;

  Widget buildWithData(BuildContext context, WidgetRef ref, T data);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temp = ref.watch(provider);
    return Material(
      child: switch (temp) {
        AsyncValue<T>(value: final T data) => buildWithData(context, ref, data),
        final AsyncError<T> state when !state.isLoading => ErrorScreen(
          state,
          onRefresh: () => ref.invalidate(provider),
        ),
        _ => const LoadingScreen(),
      },
    );
  }
}
