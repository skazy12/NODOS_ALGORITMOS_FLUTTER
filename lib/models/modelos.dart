import 'dart:io';
import 'package:collection/collection.dart';
import 'dart:math';

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
          if (enlace.origen == origen && enlace.destino == destino) {
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

    return camino;
  }

  //INICIO METODO DE ASIGNACION
  //MATRIZ DE ADYACENCIA SIN SUMAS CON NOMBRES DE LOS NODOS EN LA PRIMERA FILA Y COLUMNA, RETORNA UNA LISTA DE LISTAS DINAMICAS
  List<List<dynamic>> matrizAdyacencia() {
    List<List<dynamic>> matriz = [];
    List<dynamic> fila = [];
    //agrega los nombres de los nodos a la primera fila
    fila.add(" ");
    for (Nodo nodo in nodos) {
      fila.add(nodo.valor);
    }
    matriz.add(fila);
    //agrega los nombres de los nodos a la primera columna y los pesos de los enlaces a la matriz
    for (Nodo nodo in nodos) {
      fila = [];
      fila.add(nodo.valor);
      for (Nodo nodo2 in nodos) {
        if (nodo == nodo2) {
          fila.add(0);
        } else {
          Enlace? enlace = enlaces.firstWhereOrNull(
              (enlace) => (enlace.origen == nodo && enlace.destino == nodo2));
          if (enlace != null) {
            fila.add(enlace.peso);
          } else {
            fila.add(0);
          }
        }
      }
      matriz.add(fila);
    }

    // eliminamos las filas con ceros
    matriz.removeWhere((fila) => fila.every((valor) => valor == 0));

    // eliminamos las columnas con ceros
    for (int i = matriz[0].length - 1; i > 0; i--) {
      bool todosCeros = true;
      for (int j = 1; j < matriz.length; j++) {
        if (matriz[j][i] != 0) {
          todosCeros = false;
          break;
        }
      }
      if (todosCeros) {
        for (int j = 0; j < matriz.length; j++) {
          matriz[j].removeAt(i);
        }
      }
    }
    matriz.removeWhere((fila) => fila.skip(1).every((valor) => valor == 0));

    return matriz;
  }

// MATRIZ DE ADYACENCIA MUTABLE:
  List<List<dynamic>> matrizAdyacencia2() {
    List<List<dynamic>> matriz = [];
    List<dynamic> fila = [];
    // agrega los nombres de los nodos a la primera fila
    fila.add(" ");
    for (Nodo nodo in nodos) {
      fila.add(nodo.valor);
    }
    matriz.add(fila);
    // agrega los nombres de los nodos a la primera columna y los pesos de los enlaces a la matriz
    for (Nodo nodo in nodos) {
      fila = [];
      fila.add(nodo.valor);
      for (Nodo nodo2 in nodos) {
        if (nodo == nodo2) {
          fila.add(0);
        } else {
          Enlace? enlace = enlaces.firstWhereOrNull(
              (enlace) => (enlace.origen == nodo && enlace.destino == nodo2));
          if (enlace != null) {
            fila.add(enlace.peso);
          } else {
            fila.add(0);
          }
        }
      }
      matriz.add(fila);
    }

    return matriz;
  }

  //INICIO
  List<List<dynamic>> resultadoConCeros(
      List<List<dynamic>> matrizCostos, bool minimizar) {
    int n = matrizCostos.length;

    if (minimizar) {
      // Paso 1: Restar el mínimo de cada fila
      for (int i = 1; i < n; i++) {
        int minimo = matrizCostos[i].sublist(1).reduce((a, b) => a < b ? a : b);
        for (int j = 1; j < n; j++) {
          matrizCostos[i][j] -= minimo;
        }
      }

      // Paso 2: Restar el mínimo de cada columna
      for (int j = 1; j < n; j++) {
        List<int> columna = [];
        for (int i = 1; i < n; i++) {
          columna.add(matrizCostos[i][j]);
        }
        int minimo = columna.reduce((a, b) => a < b ? a : b);
        for (int i = 1; i < n; i++) {
          matrizCostos[i][j] -= minimo;
        }
      }
      return matrizCostos;
    } else {
      // Paso 1: Restar el máximo de cada fila
      for (int i = 1; i < n; i++) {
        int maximo = matrizCostos[i].sublist(1).reduce((a, b) => a > b ? a : b);
        for (int j = 1; j < n; j++) {
          matrizCostos[i][j] -= maximo;
        }
      }

      // Paso 2: Restar el máximo de cada columna
      for (int j = 1; j < n; j++) {
        List<int> columna = [];
        for (int i = 1; i < n; i++) {
          columna.add(matrizCostos[i][j]);
        }
        int maximo = columna.reduce((a, b) => a > b ? a : b);
        for (int i = 1; i < n; i++) {
          matrizCostos[i][j] -= maximo;
        }
      }
      return matrizCostos;
    }
  }

  List<List<dynamic>> maxMinMatrizBinaria(List<List<dynamic>> matrizOriginal,
      List<List<dynamic>> matrizCeros, bool minimizar) {
    int n = matrizOriginal.length;
    int minmax;

    List<List<dynamic>> matrizBinaria = List.generate(
        n, (i) => List.filled(n, i == 0 ? matrizOriginal[0][i] : 0));

    // Copiar nombres de nodos en la primera fila y columna
    for (int i = 0; i < n; i++) {
      matrizBinaria[0][i] = matrizOriginal[0][i];
      matrizBinaria[i][0] = matrizOriginal[i][0];
    }

    if (minimizar) {
      minmax = 1000000;
    } else {
      minmax = -1000000;
    }

    List<List<dynamic>> combinaciones = _combinaciones(matrizCeros);

    for (List<dynamic> combinacion in combinaciones) {
      int suma = 0;
      for (int i = 1; i < n; i++) {
        suma += (matrizOriginal[i][combinacion[i - 1] + 1]) as int;
      }

      if (minimizar) {
        if (suma < minmax) {
          minmax = suma;
          for (int i = 1; i < n; i++) {
            for (int j = 1; j < n; j++) {
              matrizBinaria[i][j] = j == combinacion[i - 1] + 1 ? 1 : 0;
            }
          }
        }
      } else {
        if (suma > minmax) {
          minmax = suma;
          for (int i = 1; i < n; i++) {
            for (int j = 1; j < n; j++) {
              matrizBinaria[i][j] = j == combinacion[i - 1] + 1 ? 1 : 0;
            }
          }
        }
      }
    }

    return matrizBinaria;
  }

  List<List<dynamic>> _combinaciones(List<List<dynamic>> matrizCeros) {
    List<List<dynamic>> lista = [];
    int n = matrizCeros.length - 1;
    _helper(matrizCeros, [], lista, n);
    return lista;
  }

  void _helper(List<List<dynamic>> matrizCeros, List<dynamic> seleccion,
      List<List<dynamic>> lista, int n) {
    if (seleccion.length == n) {
      lista.add(List.from(seleccion));
      return;
    }

    int fila = seleccion.length + 1;
    for (int col = 1; col <= n; col++) {
      if (matrizCeros[fila][col] == 0 && !seleccion.contains(col - 1)) {
        seleccion.add(col - 1);
        _helper(matrizCeros, seleccion, lista, n);
        seleccion.removeLast();
      }
    }
  }

  //FIN
  //ALGORITMO DE NOROESTE
  //INICIO
  List<List<dynamic>> noroeste(List<List<dynamic>> matriz) {
    int m = matriz.length - 2; // Número de filas sin contar la fila de demanda
    int n = matriz[0].length -
        2; // Número de columnas sin contar la columna de oferta

    List<List<dynamic>> asignaciones = List.generate(
        m,
        (i) => List<dynamic>.filled(
            n, 0)); // Crear matriz de asignaciones con dimensiones m x n

    int i = 1;
    int j = 1;
    while (i <= m && j <= n) {
      int oferta = matriz[i][matriz[i].length - 1];
      int demanda = matriz[matriz.length - 1][j];

      int cantidadAsignada = min(oferta, demanda);

      asignaciones[i - 1][j - 1] = cantidadAsignada;

      if (oferta <= demanda) {
        matriz[matriz.length - 1][j] -= cantidadAsignada;
        matriz[i][matriz[i].length - 1] -= cantidadAsignada;
        i++;
      } else {
        matriz[matriz.length - 1][j] -= cantidadAsignada;
        matriz[i][matriz[i].length - 1] -= cantidadAsignada;
        j++;
      }
    }
    //imprimir asignaciones
    for (int i = 0; i < asignaciones.length; i++) {
      print(asignaciones[i]);
    }
    return asignaciones;
  }

  //FIN
/*
    for (int i = 0; i < asignaciones.length; i++) {
      print(asignaciones[i]);
    }
*/
  dynamic calcularCosto(
      List<List<dynamic>> matrizOriginal, List<List<dynamic>> asignacion) {
    num costo = 0;

    for (int i = 0; i < asignacion.length; i++) {
      for (int j = 0; j < asignacion[i].length; j++) {
        if (asignacion[i][j] == 1) {
          costo += matrizOriginal[i][j] as num;
        }
      }
    }
    //imprimir costo
    return costo;
  }

  List<List<dynamic>> original(List<List<dynamic>> matrcopia) {
    List<List<dynamic>> original = matrcopia;
    return original;
  }
}
