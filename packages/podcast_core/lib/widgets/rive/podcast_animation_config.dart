import 'package:flutter/material.dart';

abstract class PodcastAnimationConfig {
  const PodcastAnimationConfig();

  /// The name of the animation.
  String get artboardName;

  Map<String, dynamic> params(BuildContext context);

  bool get isIcon => false;

  static const PodcastAnimationConfig idleLogo = IdleAnimation();

  static PodcastAnimationConfig delete({required bool isDefaultFilterState}) =>
      DeleteAnimation(filterStateIsDefault: isDefaultFilterState);

  static PodcastAnimationConfig sortOrder({required bool isSortingAscending}) =>
      SortOrderAnimation(isActive: isSortingAscending);

  static PodcastAnimationConfig queue({required bool isAlreadyInQueue}) =>
      QueueAnimation(isActive: isAlreadyInQueue);

  static PodcastAnimationConfig download({required double? progress}) =>
      DownloadAnimation(progress: progress);

  static PodcastAnimationConfig playPause({required bool isPlaying}) =>
      PlayPauseAnimation(isActive: isPlaying);
}

class IdleAnimation extends PodcastAnimationConfig {
  const IdleAnimation();

  @override
  String get artboardName => 'Icon idle animation';

  @override
  Map<String, dynamic> params(BuildContext context) => {};
}

class DownloadAnimation extends PodcastAnimationConfig {
  const DownloadAnimation({required this.progress});

  final double? progress;

  @override
  String get artboardName => 'Download';

  @override
  Map<String, dynamic> params(BuildContext context) => {'Progress': progress};
}

abstract class DualStateIcon extends PodcastAnimationConfig {
  const DualStateIcon({required this.isActive});

  final bool isActive;

  @override
  Map<String, dynamic> params(BuildContext context) => {
    'Color': Theme.of(context).colorScheme.primary,
    'Active': isActive,
  };

  @override
  bool get isIcon => true;
}

final class DeleteAnimation extends DualStateIcon {
  const DeleteAnimation({required bool filterStateIsDefault})
    : super(isActive: !filterStateIsDefault);

  @override
  String get artboardName => 'Delete';
}

final class PlayPauseAnimation extends DualStateIcon {
  const PlayPauseAnimation({required super.isActive});

  @override
  String get artboardName => 'PlayPause';
}

final class SortOrderAnimation extends DualStateIcon {
  const SortOrderAnimation({required super.isActive});

  @override
  String get artboardName => 'Sort order';
}

final class QueueAnimation extends DualStateIcon {
  const QueueAnimation({required super.isActive});

  @override
  String get artboardName => 'Queue';
}
