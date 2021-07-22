import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthAPI {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      bool res =  await _auth.authenticate(
        localizedReason: 'Scan Fingerprint or password to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      return res;
    } on PlatformException catch (e) {
      return false;
    }
  }
}
