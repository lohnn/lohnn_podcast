import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

MenuController useMenuController() {
  return use(const _MenuControllerHook());
}

class _MenuControllerHook extends Hook<MenuController> {
  const _MenuControllerHook();

  @override
  _MenuControllerHookState createState() => _MenuControllerHookState();
}

class _MenuControllerHookState
    extends HookState<MenuController, _MenuControllerHook> {
  late final MenuController _controller = MenuController();

  @override
  MenuController build(BuildContext context) {
    return _controller;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
