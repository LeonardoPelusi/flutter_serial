import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialScreen extends StatefulWidget {
  const SerialScreen({Key? key}) : super(key: key);

  @override
  State<SerialScreen> createState() => _SerialScreenState();
}

class _SerialScreenState extends State<SerialScreen> {
  final port = SerialPort('/dev/ttyS3');

  @override
  void initState() {
    super.initState();

    print(SerialPort.availablePorts);

    _initPort();
    _listenToPort();
    AppLifecycleListener(
      onInactive: () => port.close(),
      onResume: () => port.openReadWrite(),
    );
  }

  void _initPort() {
    try {
      port.openReadWrite();
      port.config = SerialPortConfig()
        ..baudRate = 115200
        ..bits = 8
        ..stopBits = 1
        ..parity = SerialPortParity.none
        ..setFlowControl(SerialPortFlowControl.none);
    } catch (e) {
      print(e);
    }
  }

  void _listenToPort() {
    SerialPortReader reader = SerialPortReader(port);

    // Stream<String> newData = reader.stream.map((data) {
    //   return String.fromCharCodes(data);
    // });

    // newData.listen((data) {
    //   print('Read Data: $data');
    // });

    reader.stream.listen((data) {
      print(String.fromCharCodes(data));
    });
  }

  void _sayHelloWorld() {
    if (!port.isOpen) return;

    port.write(Uint8List.fromList('Hello World'.codeUnits));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Serial')),
      body: Center(
        child: ElevatedButton(
          onPressed: _sayHelloWorld,
          child: const Text(
            'Hello Word',
            style: TextStyle(fontSize: 100),
          ),
        ),
      ),
    );
  }
}
