import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:podcast_core/screens/error_screen.dart';
import 'package:podcast_core/screens/loading_screen.dart';

abstract class AsyncValueWidget<T> extends HookConsumerWidget {
  const AsyncValueWidget({super.key});

  ProviderBase<AsyncValue<T>> get provider;

  Widget buildWithData(BuildContext context, WidgetRef ref, T data);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(provider);
    return Material(
      child: switch (asyncValue) {
        AsyncValue<T>(value: final T data, hasValue: true) => buildWithData(
          context,
          ref,
          data,
        ),
        final AsyncError<T> state when !state.isLoading => ErrorScreen(
          state,
          onRefresh: () => ref.invalidate(provider),
        ),
        _ => const LoadingScreen(),
      },
    );
  }
}
