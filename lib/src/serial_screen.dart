import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_serial/src/port_details_screen.dart';

class SerialScreen extends StatefulWidget {
  const SerialScreen({Key? key}) : super(key: key);

  @override
  State<SerialScreen> createState() => _SerialScreenState();
}

class _SerialScreenState extends State<SerialScreen> {
  @override
  void initState() {
    super.initState();

    print(SerialPort.availablePorts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Serial')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: List.generate(
            SerialPort.availablePorts.length,
            (index) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PortDetailsScreen(
                    portName: SerialPort.availablePorts[index],
                  ),
                ),
              ),
              child: Text(SerialPort.availablePorts[index]),
            ),
          ),
        ),
      ),
    );
  }
}
