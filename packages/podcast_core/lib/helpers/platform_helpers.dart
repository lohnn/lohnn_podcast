import 'dart:io';

import 'package:flutter/foundation.dart';

bool isWeb = kIsWeb || kIsWasm;
bool isDesktop = !Platform.isAndroid && !Platform.isIOS;

bool get isRunningTest => Platform.environment.containsKey('FLUTTER_TEST');
