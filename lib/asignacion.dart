import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import 'models/controller.dart';

class Asignacion extends StatefulWidget {
  @override
  _AsignacionState createState() => _AsignacionState();
}

class _AsignacionState extends State<Asignacion> {
  AsignacionController asignacionController = Get.find<AsignacionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asignación de Tareas: ${asignacionController.maxMin}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //AL volver AsignacionController debe volver a su estado original
            asignacionController.resetAsignacion();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMatrixTitle('Matriz Original'),
            _buildMatrixTable(
                asignacionController.matrizOriginal, false, false),
            _buildMatrixTitle('Matriz Resultante'),
            _buildMatrixTable(
                asignacionController.matrizResultante, false, false),
            _buildMatrixTitle('Matriz Binaria'),
            _buildMatrixTable(asignacionController.matrizBinaria, true, false),
            SizedBox(height: 20),
            Text(
              'Costo Total: ${asignacionController.costoOptimo}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildMatrixTitle('Matriz Original (con asignaciones)'),
            _buildMatrixTable(asignacionController.matrizOriginal, false, true),
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

  Widget _buildMatrixTable(
      List<List<dynamic>> matriz, bool highlightOnes, bool highlightOriginal) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: matriz.length,
      itemBuilder: (BuildContext context, int rowIndex) {
        return Center(
          child: Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: matriz[rowIndex].length,
              itemBuilder: (BuildContext context, int colIndex) {
                bool isNumber = matriz[rowIndex][colIndex] is num;
                bool highlight = false;

                if (highlightOnes) {
                  highlight = isNumber && matriz[rowIndex][colIndex] == 1;
                } else if (highlightOriginal) {
                  highlight = isNumber &&
                      asignacionController.matrizBinaria[rowIndex][colIndex] ==
                          1;
                }

                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    matriz[rowIndex][colIndex].toString(),
                    style: TextStyle(color: highlight ? Colors.white : null),
                  ),
                  color: highlight ? Colors.blue : null,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
