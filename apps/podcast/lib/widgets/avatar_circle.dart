import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/user_provider.dart';
import 'package:podcast_core/extensions/nullability_extensions.dart';
import 'package:podcast_core/podcast_theme/podcast_theme_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarCircle extends ConsumerWidget {
  const AvatarCircle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUrl = ref.watch(userPodProvider).valueOrNull?.avatarUrl;

    return Container(
      // The size of the gradient circle
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.deepOrange,
        gradient: SweepGradient(
          colors: [
            ...PodcastThemeColors.avatarCircleGradientColors,
            PodcastThemeColors.avatarCircleGradientColors.first,
          ],
        ),
      ),
      child: Container(
        // The size of the spacing between the gradient circle and the avatar
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          foregroundImage: avatarUrl?.let(NetworkImage.new),
          radius: 14,
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.account_circle, size: 28),
        ),
      ),
    );
  }
}

extension on User {
  String? get avatarUrl =>
      userMetadata?['avatar_url'] as String? ??
      userMetadata?['picture'] as String?;
}
