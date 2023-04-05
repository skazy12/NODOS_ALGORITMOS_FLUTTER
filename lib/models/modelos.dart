import 'dart:io';

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
    print("Grafo cargado");
  }
}
