import 'package:flutter/material.dart';

class Asignacion extends StatefulWidget {
  const Asignacion({Key? key}) : super(key: key);

  @override
  State<Asignacion> createState() => _AsignacionState();
}

class _AsignacionState extends State<Asignacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASIGNACION'),
      ),
      body: const Center(
        child: Text('ASIGNACION'),
      ),
    );
  }
}
