import 'package:flutter/material.dart';

class Johnson extends StatefulWidget {
  const Johnson({Key? key}) : super(key: key);

  @override
  State<Johnson> createState() => _JohnsonState();
}

class _JohnsonState extends State<Johnson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JOHNSON'),
      ),
      body: const Center(
        child: Text('JOHNSON'),
      ),
    );
  }
}
