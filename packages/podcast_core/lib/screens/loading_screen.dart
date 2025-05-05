import 'dart:async';

import 'package:flutter/material.dart';
import 'package:podcast_core/widgets/plasma_sphere_widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  static Future<T> showLoading<T>({
    required BuildContext context,
    required Future<T> job,
  }) async {
    final completer = Completer<BuildContext>();
    // ignore: unawaited_futures
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (!completer.isCompleted) {
          completer.complete(context);
        }
        return const LoadingScreen();
      },
    );
    final dialogContext = await completer.future;
    try {
      return await job;
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } finally {
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: ParticleLoading());
  }
}
