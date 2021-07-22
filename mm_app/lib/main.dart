import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mm_app/notification_service.dart';
import 'package:mm_app/servo.dart';
import 'BluetoothDeviceListEntry.dart';
import 'authenticationPages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FingerprintPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         title: Text('Connection'),
//       ),
//       body: SelectBondedDevicePage(
//         onCahtPage: (device1) {
//           BluetoothDevice device = device1;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) {
//                 return ChatPage(server: device);
//               },
//             ),
//           );
//         },
//       ),
//     ));
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  List<BluetoothDevice> devices = [BluetoothDevice()];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _getBTState();
    _stateChangeListner();
    _listBondedDevices();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _getBTState() {
    FlutterBluetoothSerial.instance.state.then((state) {

      _bluetoothState = state;
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      }
      setState(() {});
    });
  }

  _stateChangeListner() {
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      _bluetoothState = state;
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      }else{
        devices.clear();
      }
      print("State is Enabled: ${state.isEnabled}");
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      // resume
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      }
    }
  }

  _listBondedDevices() {
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bodedDevices) {
      devices = bodedDevices;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MAR Course Project")),
      body: Container(
        padding: EdgeInsets.only(top: 20.0, left: 10.0),
        child: Column(children: <Widget>[
          SwitchListTile(
            title: Text('Enable Bluetooth'),
            value: _bluetoothState.isEnabled,
            onChanged: (bool value) {
              future() async {
                if (value) {
                  await FlutterBluetoothSerial.instance.requestEnable();
                } else {
                  await FlutterBluetoothSerial.instance.requestDisable();
                }
              }

              future().then((_) {
                setState(() {});
              });
            },
          ),
          ListTile(
            title: Text("Bluetooth STATUS"),
            subtitle: Text(_bluetoothState.toString()),
            trailing: ElevatedButton(
                child: Text("Settings"),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                }),
          ),
          Expanded(
              child: ListView(
            children: devices
                .map((_device) => BluetoothDeviceListEntry(
                      device: _device,
                      enabled: true,
                      onTap: () {
                        _startDetailPage(context, _device);
                        print(_device.name);
                      },
                    ))
                .toList(),
          ))
        ]),
      ),
    );
  }
  void _startDetailPage(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ChatPage(server: server);
    }));
  }
}
