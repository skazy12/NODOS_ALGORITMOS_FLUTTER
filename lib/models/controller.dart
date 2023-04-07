import 'dart:io';
import 'package:get/get.dart';
import 'package:nodos2/models/modelos.dart';

class GrafoController extends GetxController {
  //lista de nodos y enlaces
  List<Nodo> nodos = [];
  List<Enlace> enlaces = [];
  //lista de nodos y enlaces para el algoritmo de johnson
  List<Nodo> nodosJohnson = [];
  List<Enlace> enlacesJohnson = [];
  //lista de enlaces para la ruta critica
  List<Enlace> enlacesRutaCritica = [];
  //funcion para agreagar nodos y enlaces
  void addNodo(Nodo nodo) {
    nodos.add(nodo);
    nodosJohnson.add(nodo);
  }

  void addEnlace(Enlace enlace) {
    enlaces.add(enlace);
    enlacesJohnson.add(enlace);
    enlacesRutaCritica.add(enlace);
  }

  void resetGrafo() {
    nodosJohnson = nodos;
    enlacesJohnson = enlaces;
    update();
  }
}

//nombre valor de nodo inicial y nodo final controller
class NodoIFController extends GetxController {
  String nodoInicial = '';
  String nodoFinal = '';
  void setNodoInicial(String nodo) {
    nodoInicial = nodo;
  }

  void setNodoFinal(String nodo) {
    nodoFinal = nodo;
  }
}
