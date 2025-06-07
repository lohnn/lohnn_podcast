import 'package:mockito/mockito.dart';

abstract class _VoidCallbackClass extends Mock {
  void call();
}

// ignore: avoid_implementing_value_types
class MockVoidCallback extends Mock implements _VoidCallbackClass {}
