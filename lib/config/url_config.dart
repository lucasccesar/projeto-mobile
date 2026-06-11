import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }

    if (Platform.isIOS) {
      return 'http://localhost:8080';
    }

    return 'http://localhost:8080';
  }
}