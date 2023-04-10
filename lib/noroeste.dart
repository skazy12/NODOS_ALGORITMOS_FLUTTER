import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import 'models/controller.dart';

class Noroeste extends StatefulWidget {
  @override
  _NoroesteState createState() => _NoroesteState();
}

class _NoroesteState extends State<Noroeste> {
  NoroesteController noroesteController = Get.find<NoroesteController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Northwest'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //AL volver NoroesteController debe volver a su estado original
            noroesteController.resetNorth();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMatrixTitle('Matriz Original'),
            _buildMatrixTable(noroesteController.matrizone),
            _buildMatrixTitle('Matriz De asignacion'),
            _buildMatrixTable(noroesteController.matrizResultante),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrixTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMatrixTable(List<List<dynamic>> matriz) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: matriz.length,
      itemBuilder: (BuildContext context, int rowIndex) {
        return Center(
          child: Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: matriz[rowIndex].length,
              itemBuilder: (BuildContext context, int columnIndex) {
                return Container(
                  width: 60,
                  child: Center(
                    child: Text(
                      '${matriz[rowIndex][columnIndex]}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
