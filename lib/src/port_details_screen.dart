import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class PortDetailsScreen extends StatefulWidget {
  final String portName;
  const PortDetailsScreen({
    required this.portName,
    Key? key,
  }) : super(key: key);

  @override
  State<PortDetailsScreen> createState() => _PortDetailsScreenState();
}

class _PortDetailsScreenState extends State<PortDetailsScreen> {
  var response;

  late final SerialPort port;

  @override
  void initState() {
    super.initState();

    port = SerialPort(widget.portName);

    AppLifecycleListener(
      onInactive: () => port.close(),
      onResume: () => port.openReadWrite(),
    );
  }

  @override
  void dispose() {
    port.close();
    port.dispose();
    super.dispose();
  }

  void _initializePort() {
    if (port.isOpen) return;

    port.openReadWrite();

    port.config = SerialPortConfig()
      ..baudRate = 9600
      ..bits = 8
      ..stopBits = 1
      ..parity = SerialPortParity.none
      ..setFlowControl(SerialPortFlowControl.none);

    _listenToPort();
  }

  void _sendMessage(String message) {
    if (!port.isOpen) return;

    final Uint8List bytes = Uint8List.fromList(message.codeUnits);

    print('Sending: $message');

    port.write(bytes);
  }

  void _readSpeed() {
    if (!port.isOpen) return;

    final Uint8List bytes = Uint8List.fromList([0xf6, 0x10, 0x8c, 0xbe, 0xf4]);

    port.write(bytes);
  }

  void _sendSpeed() {
    if (!port.isOpen) return;

    final Uint8List bytes =
        Uint8List.fromList([0xf6, 0xa0, 0x80, 0x10, 0x78, 0xf4]);

    port.write(bytes);
  }

  void _listenToPort() {
    SerialPortReader reader = SerialPortReader(port);

    reader.stream.listen((data) {
      print('Data: $data');

      setState(() {
        response = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(port.name ?? 'Unknown')),
      body: SizedBox(
        width: double.infinity,
        child: Center(
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
                onPressed: _readSpeed,
                child: const Text('Read Speed'),
              ),
              ElevatedButton(
                onPressed: _sendSpeed,
                child: const Text('Send Speed'),
              ),
              const SizedBox(height: 100),
              const Text(
                'RESPOSTA:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                '$response',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
