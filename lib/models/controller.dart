import 'dart:io';
import 'package:get/get.dart';
import 'package:nodos2/asignacion.dart';
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

class AsignacionController extends GetxController {
  List<List<dynamic>> matrizOriginal = [];
  List<List<dynamic>> matrizResultante = [];
  List<List<dynamic>> matrizBinaria = [];
  String maxMin = '';
  dynamic costoOptimo = 0;
  //getter y setter de la matriz original
  void setMatrizOriginal(List<List<dynamic>> matriz) {
    matrizOriginal = matriz;
  }

  //getter y setter de la matriz de asignacion
  void setMatrizResultante(List<List<dynamic>> matriz) {
    matrizResultante = matriz;
  }

  //getter y setter de la matriz binaria
  void setMatrizBinaria(List<List<dynamic>> matriz) {
    matrizBinaria = matriz;
  }

  //setter de maxmin
  void setMaxMin(String maxmin) {
    maxMin = maxmin;
  }

  //metodo para resetear todas las matrices y variables
  void resetAsignacion() {
    matrizOriginal = [];
    matrizResultante = [];
    matrizBinaria = [];
    maxMin = '';
    costoOptimo = 0;
    update();
  }
}

class NoroesteController extends GetxController {
  List<List<dynamic>> matrizone = [];
  List<List<dynamic>> matrizResultante = [];

  dynamic costoOptimo = 0;

  //metodo para resetear todas las matrices y variables
  //setter de la matriz original

  void resetNorth() {
    matrizone = [];
    matrizResultante = [];

    costoOptimo = 0;
    update();
  }
}
