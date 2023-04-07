import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nodos2/figuras/figuras.dart';
import 'package:nodos2/models/controller.dart';

import 'models/modelos.dart';

class Johnson extends StatefulWidget {
  const Johnson({Key? key}) : super(key: key);

  @override
  State<Johnson> createState() => _JohnsonState();
}

class _JohnsonState extends State<Johnson> {
  //recuperar el grafo modificado
  List<Nodo> nodos = Get.find<GrafoController>().nodosJohnson;
  List<Enlace> enlaces = Get.find<GrafoController>().enlacesJohnson;
  List<Enlace> enlacesRutaCritica =
      Get.find<GrafoController>().enlacesRutaCritica;
  NodoIFController nodoIFController = Get.find<NodoIFController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
                'JOHNSON DE NODO "${nodoIFController.nodoInicial}" A NODO "${nodoIFController.nodoFinal}"'),
          ),
          body: Stack(
            children: [
              CustomPaint(
                painter: Nodos(nodos: nodos),
                child: Container(),
              ),
              CustomPaint(
                painter:
                    EnlaceRutaCritica(enlaces: enlacesRutaCritica, ruta: false),
                child: Container(),
              ),
              CustomPaint(
                painter: EnlaceMejorRuta(enlaces: enlaces, ruta: false),
                child: Container(),
              ),
            ],
          )),
    );
  }

  void _onBackPressed() {
    //al volver atras el grafo debe volver a su estado original
    Get.find<GrafoController>().resetGrafo();
    Get.back();
  }
}
