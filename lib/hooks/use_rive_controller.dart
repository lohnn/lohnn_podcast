import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast/extensions/nullability_extensions.dart';
import 'package:rive/rive.dart';

RiveAnimationController<RuntimeArtboard> useRiveController<RuntimeArtboard>({
  required VoidCallback onDone,
}) {
  return use(_RiveControllerHook(onDone));
}

class _RiveControllerHook<RuntimeArtboard>
    extends Hook<RiveAnimationController<RuntimeArtboard>> {
  final VoidCallback onDone;

  const _RiveControllerHook(this.onDone);

  @override
  HookState<RiveAnimationController<RuntimeArtboard>,
          Hook<RiveAnimationController<RuntimeArtboard>>>
      createState() => _RiveAnimationHookState();
}

class _RiveAnimationHookState<RuntimeArtboard> extends HookState<
    RiveAnimationController<RuntimeArtboard>,
    _RiveControllerHook<RuntimeArtboard>> {
  late final RiveAnimationController<RuntimeArtboard> _controller;

  @override
  void initHook() {
    _controller = _RiveAnimationControllerImpl(onStop: hook.onDone)
        as RiveAnimationController<RuntimeArtboard>;
  }

  @override
  RiveAnimationController<RuntimeArtboard> build(BuildContext context) {
    return _controller;
  }
}

class _RiveAnimationControllerImpl
    extends RiveAnimationController<RuntimeArtboard> {
  final bool autoplay;
  final VoidCallback? onStart;
  final VoidCallback? onStop;

  _RiveAnimationControllerImpl({
    double mix = 1,
    this.autoplay = true,
    this.onStart,
    this.onStop,
  }) : _mix = mix.clamp(0, 1).toDouble() {
    isActiveChanged.addListener(onActiveChanged);
  }

  LinearAnimationInstance? _instance;
  double _mix;

  LinearAnimationInstance? get instance => _instance;

  double get mix => _mix;

  set mix(double value) => _mix = value.clamp(0, 1).toDouble();

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (_instance == null || !_instance!.keepGoing) {
      isActive = false;
    }

    _instance!
      ..animation.apply(_instance!.time, coreContext: artboard, mix: mix)
      ..advance(elapsedSeconds);
  }

  @override
  bool init(RuntimeArtboard artboard) {
    _instance = artboard.animationByName(artboard.animations.first.name);
    isActive = autoplay;
    return _instance != null;
  }

  void onActiveChanged() {
    isActive
        ? onStart?.call()
        : WidgetsBinding.instance.let(
            (animationInstance) => animationInstance
              ..addPostFrameCallback(
                (_) => onStop?.call(),
              ),
          );
  }

  @override
  void dispose() {
    isActiveChanged.removeListener(onActiveChanged);
    super.dispose();
  }
}
