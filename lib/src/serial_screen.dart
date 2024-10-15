import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_serial/src/port_details_screen.dart';

class SerialScreen extends StatefulWidget {
  const SerialScreen({Key? key}) : super(key: key);

  @override
  State<SerialScreen> createState() => _SerialScreenState();
}

class _SerialScreenState extends State<SerialScreen> {
  final List<SerialPort> _ports = [];

  @override
  void initState() {
    super.initState();

    for (var portName in SerialPort.availablePorts) {
      _ports.add(SerialPort(portName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Serial')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: List.generate(
            _ports.length,
            (index) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PortDetailsScreen(port: _ports[index]),
                ),
              ),
              child: Text(_ports[index].name ?? 'Unknown'),
            ),
          ),
        ),
      ),
    );
  }
}
