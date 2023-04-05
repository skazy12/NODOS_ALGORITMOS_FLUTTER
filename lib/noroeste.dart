import 'package:flutter/material.dart';

class Noroeste extends StatefulWidget {
  const Noroeste({Key? key}) : super(key: key);

  @override
  State<Noroeste> createState() => _NoroesteState();
}

class _NoroesteState extends State<Noroeste> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noroeste'),
      ),
      body: const Center(
        child: Text('Noroeste'),
      ),
    );
  }
}
