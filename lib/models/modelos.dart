import 'dart:io';
import 'package:collection/collection.dart';

class Nodo {
  String valor;

  double x;
  double y;

  Nodo({
    required this.valor,
    required this.x,
    required this.y,
  });
}

class Enlace {
  final Nodo origen;
  final Nodo destino;
  final int id;

  int peso;

  Enlace({
    required this.id,
    required this.origen,
    required this.destino,
    required this.peso,
  });
}

class Grafo {
  List<Nodo> nodos;
  List<Enlace> enlaces;

  Grafo({required this.nodos, required this.enlaces});

  //metodo para generar la matriz de adyacencia

  void generarMatrizAdyacencia() {
    List<List<String>> matriz = [];

    // Insertar primera fila con los nombres de los nodos
    List<String> nombresNodos = nodos.map((nodo) => nodo.valor).toList();
    nombresNodos.insert(0, "");
    nombresNodos.add("SUMA");
    matriz.add(nombresNodos);

    // Suma de los pesos de los enlaces por columna
    List<int> sumasColumnas = List.filled(nombresNodos.length, 0);

    for (Nodo origen in nodos) {
      List<String> fila = [origen.valor];

      // Suma de los pesos de los enlaces por fila
      int sumaFila = 0;

      for (Nodo destino in nodos) {
        int peso = 0;
        for (Enlace enlace in enlaces) {
          if (enlace.origen == origen && enlace.destino == destino ||
              enlace.origen == destino && enlace.destino == origen) {
            peso = enlace.peso;
            break;
          }
        }
        fila.add(peso.toString());

        // Sumar el peso a la suma de la fila y la columna correspondiente
        sumaFila += peso;
        sumasColumnas[nodos.indexOf(destino) + 1] += peso;
      }

      // Añadir la suma de la fila a la última columna
      fila.add(sumaFila.toString());

      matriz.add(fila);
    }

    // Añadir la última fila con las sumas de las columnas
    List<String> filaSumasColumnas = ["SUMA"];
    for (int i = 1; i < sumasColumnas.length - 1; i++) {
      filaSumasColumnas.add(sumasColumnas[i].toString());
    }
    filaSumasColumnas.add(sumasColumnas.last.toString());
    matriz.add(filaSumasColumnas);

    for (List<String> fila in matriz) {
      print(fila.join("\t"));
    }
  }

  void guardarGrafo(String nombre) {
    //metodo para guardar los datos del grafo en un archivo
    String datos = "";
    for (Nodo nodo in nodos) {
      datos += "${nodo.valor},${nodo.x},${nodo.y}\n";
    }
    datos += "\n";
    for (Enlace enlace in enlaces) {
      datos +=
          "${enlace.origen.valor}:${enlace.destino.valor}:${enlace.peso}\n";
    }
    File("${nombre}.txt").writeAsStringSync(datos);
  }

  void cargarGrafo(File archivo) {
    //metodo para cargar los datos del grafo desde un archivo
    String datos = archivo.readAsStringSync();
    List<String> lineas = datos.split("\n");

    for (String linea in lineas) {
      if (linea == "") {
        continue;
      }
      List<String> datosNodo = linea.split(",");
      if (datosNodo.length == 3) {
        // Verificar si ya existe un nodo con el mismo valor
        if (nodos.any((nodo) => nodo.valor == datosNodo[0])) {
          continue;
        }
        nodos.add(Nodo(
          valor: datosNodo[0],
          x: double.tryParse(datosNodo[1]) ?? 0.0,
          y: double.tryParse(datosNodo[2]) ?? 0.0,
        ));
      }
    }
    for (String linea in lineas) {
      if (linea == "") {
        continue;
      }
      List<String> datosEnlace = linea.split(":");
      if (datosEnlace.length == 3) {
        Nodo origen = nodos.firstWhere((nodo) => nodo.valor == datosEnlace[0]);
        Nodo destino = nodos.firstWhere((nodo) => nodo.valor == datosEnlace[1]);
        int pesof = int.tryParse(datosEnlace[2]) ?? 0;
        enlaces.add(Enlace(
          id: enlaces.length + 1,
          origen: origen,
          destino: destino,
          peso: pesof,
        ));
      }
    }
  }

  Map<Nodo, double> bellmanFord() {
    Map<Nodo, double> distancias = {};
    //Agregar un nodo origen que tenga enlaces con todos los demas nodos con valor 0
    Nodo origen = Nodo(valor: "origen", x: 0, y: 0);
    nodos.add(origen);
    for (Nodo nodo in nodos) {
      if (nodo != origen) {
        enlaces.add(Enlace(
          id: enlaces.length + 1,
          origen: origen,
          destino: nodo,
          peso: 0,
        ));
      }
    }
    // Inicializar todas las distancias a infinito excepto la del nodo origen
    for (Nodo nodo in nodos) {
      distancias[nodo] = double.infinity;
    }
    distancias[origen] = 0;

    // Relajar todos los enlaces V-1 veces
    for (int i = 0; i < nodos.length - 1; i++) {
      for (Enlace enlace in enlaces) {
        Nodo u = enlace.origen;
        Nodo v = enlace.destino;
        int peso = enlace.peso;

        if (distancias[u]! + peso < distancias[v]!) {
          distancias[v] = (distancias[u]! + peso);
        }
      }
    }

    // Verificar si hay ciclos negativos
    for (Enlace enlace in enlaces) {
      Nodo u = enlace.origen;
      Nodo v = enlace.destino;
      int peso = enlace.peso;

      if (distancias[u]! + peso < distancias[v]!) {
        throw Exception('El grafo contiene ciclos negativos.');
      }
    }

    //imprimir las distancias
    // print("Distancias desde el nodo origen:");
    // for (Nodo nodo in nodos) {
    //   print("${nodo.valor}: ${distancias[nodo]}");
    // }
    return distancias;
  }

  void reasignarPesos() {
    // Ejecutamos Bellman-Ford en el grafo ampliado para encontrar las distancias mínimas
    Map<Nodo, double> distancias = bellmanFord();

    // Reasignamos los pesos de los enlaces en el grafo original
    for (Enlace enlace in enlaces) {
      Nodo u = enlace.origen;
      Nodo v = enlace.destino;
      int peso = enlace.peso;

      int nuevoPeso = peso + distancias[u]!.toInt() - distancias[v]!.toInt();
      enlace.peso = nuevoPeso;
    }
  }

  void eliminarNodoExtra() {
    // Encuentra el nodo extra
    Nodo origen = nodos.firstWhere((nodo) => nodo.valor == "origen");

    // Elimina todos los enlaces que conectan el nodo extra con los demás nodos
    enlaces.removeWhere(
        (enlace) => enlace.origen == origen || enlace.destino == origen);

    // Elimina el nodo extra
    nodos.remove(origen);
  }

  //metodo para encontrar el camino mas corto entre dos nodos
  List<Enlace> caminoMasCorto(Nodo origen, Nodo destino) {
    // método para encontrar el camino mas corto entre dos nodos
    List<Enlace> camino = [];
    List<Nodo> visitados = [];
    List<Nodo> nodosPorVisitar = [];
    Map<Nodo, Nodo> antecesores = {};
    Map<Nodo, int> distancias = {};
    // inicializar las distancias
    for (Nodo nodo in nodos) {
      distancias[nodo] = 1000000;
    }
    distancias[origen] = 0;
    nodosPorVisitar.add(origen);
    while (nodosPorVisitar.isNotEmpty) {
      Nodo nodoActual = nodosPorVisitar.first;
      for (Nodo nodo in nodosPorVisitar) {
        if (distancias[nodo]! < distancias[nodoActual]!) {
          nodoActual = nodo;
        }
      }
      nodosPorVisitar.remove(nodoActual);
      visitados.add(nodoActual);
      if (nodoActual == destino) {
        break;
      }
      for (Enlace enlace in enlaces) {
        if (enlace.origen == nodoActual &&
            !visitados.contains(enlace.destino)) {
          int distancia = distancias[nodoActual]! + enlace.peso;
          if (distancia < distancias[enlace.destino]!) {
            distancias[enlace.destino] = distancia;
            antecesores[enlace.destino] = nodoActual;
            if (!nodosPorVisitar.contains(enlace.destino)) {
              nodosPorVisitar.add(enlace.destino);
            }
          }
        }
      }
    }
    // imprimir el camino
    Nodo nodoActual = destino;
    while (nodoActual != null && antecesores[nodoActual] != null) {
      Nodo nodoAnterior = antecesores[nodoActual]!;
      Enlace enlace = enlaces.firstWhere(
          (e) => e.origen == nodoAnterior && e.destino == nodoActual);
      if (enlace != null) {
        camino.add(enlace);
      }
      nodoActual = nodoAnterior;
    }
    camino = camino.reversed.toList();
    // print("Camino mas corto desde ${origen.valor} hasta ${destino.valor}:");
    // //print lista de enlaces por id
    // print(camino.map((enlace) => enlace.id).join(", "));
    // print(camino
    //     .map((enlace) => "${enlace.origen.valor} -> ${enlace.destino.valor}")
    //     .join(", "));
    return camino;
  }

  List<Enlace> rutaCritica(Nodo origen, Nodo destino) {
    // método para encontrar la peor ruta entre dos nodos
    List<Enlace> camino = [];
    List<Nodo> visitados = [];
    Map<Nodo, Enlace> antecesores = {};
    Map<Nodo, int> distancias = {};
    // inicializar las distancias
    for (Nodo nodo in nodos) {
      distancias[nodo] = -1000000;
    }
    distancias[origen] = 0;
    PriorityQueue<Nodo> nodosPorVisitar =
        PriorityQueue<Nodo>((a, b) => distancias[b]! - distancias[a]!);
    nodosPorVisitar.add(origen);
    while (nodosPorVisitar.isNotEmpty) {
      Nodo nodoActual = nodosPorVisitar.removeFirst();
      visitados.add(nodoActual);
      for (Enlace enlace in enlaces) {
        if (enlace.origen == nodoActual &&
            !visitados.contains(enlace.destino)) {
          int distancia = distancias[nodoActual]! + enlace.peso;
          if (distancia > distancias[enlace.destino]!) {
            distancias[enlace.destino] = distancia;
            antecesores[enlace.destino] = enlace;
            nodosPorVisitar.add(enlace.destino);
          }
        }
      }
    }
    // imprimir el camino
    Nodo nodoActual = destino;
    while (nodoActual != origen) {
      Enlace enlace = antecesores[nodoActual]!;
      camino.add(enlace);
      nodoActual = enlace.origen;
    }
    camino = camino.reversed.toList();
    // print("Peor ruta desde ${origen.valor} hasta ${destino.valor}:");
    // // print lista de enlaces por id
    // print(camino.map((enlace) => enlace.id).join(", "));
    // print(camino
    //     .map((enlace) => "${enlace.origen.valor} -> ${enlace.destino.valor}")
    //     .join(", "));
    return camino;
  }
}
