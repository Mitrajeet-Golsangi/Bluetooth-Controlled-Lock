import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'dart:async';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
class BluetoothDeviceListEntry extends StatefulWidget {

  final Function onTap;
  final BluetoothDevice device;

  BluetoothDeviceListEntry({this.onTap, @required this.device});

  @override
  _BluetoothDeviceListEntryState createState() => _BluetoothDeviceListEntryState();
}

class _BluetoothDeviceListEntryState extends State<BluetoothDeviceListEntry> {
  final LocalAuthentication auth = LocalAuthentication();

  _SupportState _supportState = _SupportState.unknown;

  bool _canCheckBiometrics;

  List<BiometricType> _availableBiometrics;

  String _authorized = 'Not Authorized';

  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
          ? _SupportState.supported
          : _SupportState.unsupported),
    );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    setState(
            () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      leading: Icon(Icons.devices),
      title: Text(widget.device.name ?? "Unknown device"),
      subtitle: Text(widget.device.address.toString()),
      trailing: TextButton.icon(
        icon: Icon(Icons.bluetooth_audio_sharp),
        label: Text('Connect'),
        onPressed: _authorized == 'Authorized' ? widget.onTap : _authenticate,
        // onPressed: widget.onTap,
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
          primary: Colors.white
        ),
      ),
    );
  }
}