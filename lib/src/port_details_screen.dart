import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class PortDetailsScreen extends StatefulWidget {
  final SerialPort port;
  const PortDetailsScreen({
    required this.port,
    Key? key,
  }) : super(key: key);

  @override
  State<PortDetailsScreen> createState() => _PortDetailsScreenState();
}

class _PortDetailsScreenState extends State<PortDetailsScreen> {
  String? response;

  @override
  void initState() {
    super.initState();

    AppLifecycleListener(
      onInactive: () => widget.port.close(),
      onResume: () => widget.port.openReadWrite(),
    );
  }

  @override
  void dispose() {
    widget.port.close();
    super.dispose();
  }

  void _initializePort() {
    widget.port.openReadWrite();
    widget.port.config = SerialPortConfig()
      ..baudRate = 9600
      ..bits = 8
      ..stopBits = 1
      ..parity = SerialPortParity.none
      ..setFlowControl(SerialPortFlowControl.none);

    _listenToPort();
  }

  void _sendMessage(String message) {
    if (!widget.port.isOpen) return;

    widget.port.write(Uint8List.fromList(message.codeUnits));

    // widget.port.write(Uint8List.fromList([0xf6, 0xa0, 0x80, 0x10, 0x78, 0xf4]));
  }

  void _listenToPort() {
    SerialPortReader reader = SerialPortReader(widget.port);

    reader.stream.listen((data) {
      print('Data: $data');
      setState(() {
        response = String.fromCharCodes(data);
      });
    });
  }

  void _readData() {
    setState(() {
      response = String.fromCharCodes(widget.port.read(100));
      print(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.port.name ?? 'Unknown')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _initializePort,
              child: const Text('Initialize Port'),
            ),
            ElevatedButton(
              onPressed: () => _sendMessage('Hello World!'),
              child: const Text('Send Hello World'),
            ),
            ElevatedButton(
              onPressed: () => _sendMessage('Goper'),
              child: const Text('Send Goper'),
            ),
            ElevatedButton(
              onPressed: _readData,
              child: const Text('Read Data'),
            ),
            const SizedBox(height: 100),
            const Text(
              'RESPOSTA:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              response ?? 'NADA',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
