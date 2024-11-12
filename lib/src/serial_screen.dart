import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_serial/src/port_details_screen.dart';

class SerialScreen extends StatefulWidget {
  const SerialScreen({Key? key}) : super(key: key);

  @override
  State<SerialScreen> createState() => _SerialScreenState();
}

class _SerialScreenState extends State<SerialScreen> {
  List<String> availablePorts = SerialPort.availablePorts;

  @override
  void initState() {
    super.initState();

    _validatePorts();
  }

  void _validatePorts() async {
    availablePorts = SerialPort.availablePorts;

    print('Available ports: ${SerialPort.availablePorts}');

    // if (SerialPort.availablePorts.contains('/dev/ttyUSB0')) {
    //   availablePorts = ['/dev/ttyUSB0'];
    // } else {
      for (var port in SerialPort.availablePorts) {
        final SerialPort serialPort = SerialPort(port);

        try {
          serialPort.openReadWrite();

          serialPort.write(Uint8List.fromList([0xf6, 0x10, 0x8c, 0xbe, 0xf4]));

          await Future.delayed(const Duration(milliseconds: 500));

          final Uint8List response = serialPort.read(7);

          if (response.isEmpty) {
            availablePorts.remove(port);
          }
        } catch (e) {
          availablePorts.remove(port);
          continue;
        } finally {
          serialPort.close();
        }
      }
    // }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serial'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _validatePorts,
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: List.generate(
            availablePorts.length,
            (index) {
              final port = availablePorts[index];
              return ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PortDetailsScreen(
                      portName: port,
                    ),
                  ),
                ),
                child: Text(port),
              );
            },
          ),
        ),
      ),
    );
  }
}
