import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nodos2/models/controller.dart';
import 'package:path/path.dart';
import 'asignacion.dart';
import 'figuras/figuras.dart';
import 'johonson.dart';
import 'models/modelos.dart';
import 'noroeste.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Nodo nodoOrigen = Nodo(valor: "", x: 0, y: 0);
  Nodo nodoDestino = Nodo(valor: "", x: 0, y: 0);
  Nodo nodoSeleccionado = Nodo(valor: "", x: 0, y: 0);
  int click = 0;
  List<Nodo> nodos = [];
  List<Enlace> enlaces = [];
  TextEditingController _pesoController = TextEditingController();
  //instancia del controlador de nodos y enlaces
  GrafoController grafoController = Get.put(GrafoController());
  NodoIFController nodoIFController = Get.put(NodoIFController());
  //instancia del controlador de archivos
  String nombre_archivo = "";
  //controlador para Asignacion
  AsignacionController asignacionController = Get.put(AsignacionController());
  //controlador para Noroeste
  NoroesteController noroesteController = Get.put(NoroesteController());

  List<Enlace> camino = [];
  List<Enlace> rutaCritica = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GRAFO: $nombre_archivo'),
        actions: [
          //Icono para guardar el grafo
          IconButton(
              onPressed: () {
                //preguntar por el nombre del archivo en el que se guardara el grafo
                //y luego llamar al metodo guardarGrafo
                showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController _nombreController =
                          TextEditingController();
                      return AlertDialog(
                        title: Text('Guardar grafo'),
                        content: TextField(
                          controller: _nombreController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nombre del archivo'),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Grafo grafo =
                                    Grafo(nodos: nodos, enlaces: enlaces);
                                grafo.guardarGrafo(_nombreController.text);
                                Navigator.pop(context);
                                setState(() {
                                  nombre_archivo = _nombreController.text;
                                });
                              },
                              child: Text('Guardar'))
                        ],
                      );
                    });
              },
              icon: Icon(Icons.save)),
          //Icono para cargar el grafo
          IconButton(
              onPressed: () {
                //seleccionar el archivo del que se cargara el grafo
                //y luego llamar al metodo cargarGrafo
                FilePicker.platform
                    .pickFiles(type: FileType.custom, allowedExtensions: [
                  'txt',
                ]).then((result) {
                  if (result != null) {
                    nodos = [];
                    enlaces = [];
                    File file = File(result.files.single.path ?? "");
                    Grafo grafo = Grafo(nodos: nodos, enlaces: enlaces);
                    grafo.cargarGrafo(file);
                    setState(() {
                      //actualizar los nodos y enlaces, y el nombre del archivo
                      nombre_archivo = basename(file.path);
                      nodos = grafo.nodos;
                      enlaces = grafo.enlaces;
                    });
                  }
                });
              },
              icon: Icon(Icons.upload_file)),
          IconButton(
              onPressed: () {
                setState(() {
                  nodos = [];
                  enlaces = [];
                  nombre_archivo = "";
                });
              },
              icon: Icon(Icons.delete)),
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('HELP'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add_circle),
                          label: Text(
                              'Para Agregar un nodo, seleccione la opcion "Agregar nodo (+)" y seleccione en el lugar donde desea agregarlo.'),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.edit_location),
                          label: Text(
                              ' Para Mover un nodo, seleccione la opcion "Mover nodo (Lápiz en una ubicación)" y arrastre el nodo.'),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.remove_circle),
                          label: Text(
                              ' Para Eliminar un nodo, seleccione la opcion "Remover nodo (-)de fondo oscuro" y seleccione el nodo que desea eliminar.'),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_right_alt_outlined),
                          label: Text(
                              'Para agregar un enlace, seleccione la opcion "Agregar enlace (->)" y seleccione el nodo de origen y luego en el nodo de destino. '),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.remove_circle_outline_rounded),
                          label: Text(
                              'Para eliminar un enlace, seleccione la opcion "Remover enlace (-)de fondo claro" y seleccione el un Nodo donde le aparecerá una lista de enlaces del nodo, eliminelo con el icono de basurero.'),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add_road_outlined),
                          label: Text(
                              'Para agregar un peso a un enlace, seleccione la opcion "Agregar valor al enlace (icono de vía con un +)" y seleccione el Nodo que tiene el enlace a Editar. Seleccione de la lista el enlace.'),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.generating_tokens_outlined),
                          label: Text(
                              'Para cambiar el nombre del grafo presione el icono que muestra a la izquierda. Y luego escriba el nombre del grafo.'),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.list),
                          label: Text(
                              'Para generar la matriz de adyacencia presione el icono que muestra a la izquierda.'),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.clear),
                          label: Text(
                              'Para limpiar toda la pantalla presione el icono que muestra a la izquierda y luego presione la pantalla'),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.group),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Integrantes'),
                    content: Text(
                      '1. Geraldine Ibieta \n\n'
                      '2. Carlos Camargo \n\n'
                      '3. Andre Panique \n\n'
                      '4. Omar Rodriguez \n\n'
                      '5. Mirko Alarcon \n\n'
                      '6. Carlos Zarate \n\n',
                      style: TextStyle(fontSize: 20),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      //BARRA LATERAL PARA SELECCIONAR ALGORITMOS
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('ALGORITMOS'),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 15, 51, 80),
              ),
            ),
            ListTile(
              title: Text('ALGORITMO DE JOHNSON'),
              onTap: () {
                //instanciar los nodos y enlaces al controlador, los nodos son originales y nodojohnson es el que se va a modificar
                grafoController.nodos = nodos;
                grafoController.enlaces = enlaces;

                grafoController.nodosJohnson = nodos;
                grafoController.enlacesJohnson = enlaces;
                grafoController.enlacesRutaCritica = enlaces;
                //instanciamos un grafo para poder usar los metodos de la clase grafo
                Grafo grafo = Grafo(
                    nodos: grafoController.nodos,
                    enlaces: grafoController.enlaces);
                grafo.reasignarPesos();
                grafo.eliminarNodoExtra();
                //seleccionar el nodo origen mostrando una lista de nodos, guardar el nodo origen en la variable nodoOrigen, luego mostrar en otro dialog la lista de nodos destino y guardar el nodo destino en la variable nodoDestino
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text('Seleccionar nodo origen'),
                      children: nodos.map((nodo) {
                        return SimpleDialogOption(
                          child: Text(nodo.valor),
                          onPressed: () {
                            setState(() {
                              nodoOrigen = nodo;
                              nodoIFController.setNodoInicial(nodo.valor);
                            });
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    );
                  },
                ).then((_) {
                  // Mostrar lista de nodos para seleccionar el nodo destino
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text('Seleccionar nodo destino'),
                        children: nodos.map((nodo) {
                          return SimpleDialogOption(
                            child: Text(nodo.valor),
                            onPressed: () {
                              setState(() {
                                nodoDestino = nodo;
                                nodoIFController.setNodoFinal(nodo.valor);
                              });
                              Navigator.pop(context);
                              camino =
                                  grafo.caminoMasCorto(nodoOrigen, nodoDestino);

                              rutaCritica =
                                  grafo.rutaCritica(nodoOrigen, nodoDestino);
                              grafoController.enlacesRutaCritica = rutaCritica;
                              grafoController.enlacesJohnson = camino;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Johnson()),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  );
                });
              },
            ),
            ExpansionTile(
              title: Text('ALGORITMO DE ASIGNACIÓN'),
              children: <Widget>[
                ListTile(
                  title: Text('MINIMIZAR COSTO'),
                  onTap: () {
                    //ir a la pantalla de asignacion
                    if (nodos.length > 0 && enlaces.length > 0) {
                      Grafo grafo = Grafo(nodos: nodos, enlaces: enlaces);
                      List<List<dynamic>> matriz = grafo.matrizAdyacencia();
                      List<List<dynamic>> resResultante =
                          grafo.resultadoConCeros(matriz, true);

                      //ingresar datos al controlador
                      asignacionController.matrizResultante = resResultante;
                      List<List<dynamic>> matrizOriginal =
                          grafo.matrizAdyacencia();
                      asignacionController.matrizOriginal = matrizOriginal;
                      List<List<dynamic>> asignacionbinaria =
                          grafo.maxMinMatrizBinaria(
                              matrizOriginal, resResultante, true);
                      asignacionController.matrizBinaria = asignacionbinaria;

                      asignacionController.costoOptimo = grafo.calcularCosto(
                          matrizOriginal, asignacionbinaria);
                      asignacionController.maxMin = "MINIMIZCION";

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Asignacion()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('No se ha creado un grafo'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cerrar'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                ListTile(
                  title: Text('MAXIMIZAR BENEFICIO'),
                  onTap: () {
                    //ir a la pantalla de asignacion
                    if (nodos.length > 0 && enlaces.length > 0) {
                      Grafo grafo = Grafo(nodos: nodos, enlaces: enlaces);
                      List<List<dynamic>> matriz = grafo.matrizAdyacencia();
                      List<List<dynamic>> resResultante =
                          grafo.resultadoConCeros(matriz, false);
                      //ingresar datos al controlador
                      asignacionController.matrizResultante = resResultante;
                      List<List<dynamic>> matrizOriginal =
                          grafo.matrizAdyacencia();
                      asignacionController.matrizOriginal = matrizOriginal;
                      List<List<dynamic>> asignacionbinaria =
                          grafo.maxMinMatrizBinaria(
                              matrizOriginal, resResultante, false);
                      asignacionController.matrizBinaria = asignacionbinaria;
                      //imprimir la matriz de asignacion

                      asignacionController.costoOptimo = grafo.calcularCosto(
                          matrizOriginal, asignacionbinaria);
                      asignacionController.maxMin = "MAXIMIZACION";

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Asignacion()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('No se ha creado un grafo'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cerrar'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            ListTile(
              title: Text('ALGORITMO DE NOROESTE'),
              onTap: () async {
                if (nodos.length > 0 && enlaces.length > 0) {
                  Grafo grafo = Grafo(nodos: nodos, enlaces: enlaces);
                  List<List<dynamic>> matriz = grafo.matrizAdyacencia();

                  // Crear una nueva matriz con una fila y columna extra
                  List<List<dynamic>> extendedMatrix =
                      List.generate(matriz.length + 1, (i) {
                    if (i == matriz.length) {
                      return List.filled(matriz[0].length + 1, null);
                    } else {
                      return List.from(matriz[i])..add(null);
                    }
                  });

                  // Asignar "Demanda" y "Oferta" en la matriz
                  extendedMatrix[matriz.length][0] = "Demanda";
                  extendedMatrix[0][matriz[0].length] = "Oferta";

                  // Ingresar demandas
                  for (int i = 1; i < extendedMatrix[0].length - 1; i++) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController demandaController =
                            TextEditingController();
                        return AlertDialog(
                          title: Text('Ingrese la demanda del nodo ' +
                              extendedMatrix[0][i]),
                          content: TextField(
                            controller: demandaController,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                extendedMatrix[extendedMatrix.length - 1][i] =
                                    int.parse(demandaController.text);
                                Navigator.of(context).pop();
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }

                  // Ingresar ofertas
                  for (int i = 1; i < extendedMatrix.length - 1; i++) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController ofertaController =
                            TextEditingController();
                        return AlertDialog(
                          title: Text('Ingrese la oferta del nodo ' +
                              extendedMatrix[i][0]),
                          content: TextField(
                            controller: ofertaController,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                extendedMatrix[i]
                                        [extendedMatrix[0].length - 1] =
                                    int.parse(ofertaController.text);
                                Navigator.of(context).pop();
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  for (int i = 0; i < extendedMatrix.length; i++) {
                    for (int j = 0; j < extendedMatrix[i].length; j++) {
                      if (extendedMatrix[i][j] == null) {
                        extendedMatrix[i][j] =
                            " "; // Reemplaza null por un espacio vacío
                      }
                    }
                  }
                  List<List<dynamic>> copia = List.from(extendedMatrix);
                  noroesteController.matrizone = List.from(extendedMatrix);
                  // impresion de la matriz
                  for (int i = 0;
                      i < noroesteController.matrizone.length;
                      i++) {
                    print(noroesteController.matrizone[i]);
                  }
                  noroesteController.matrizResultante = grafo.noroeste(copia);

                  // Ingresar datos al controlador
                  // Ir a la pantalla de asignacion
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Noroeste()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('No se ha creado un grafo'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: Nodos(nodos: nodos),
            child: Container(),
          ),
          CustomPaint(
            painter: EnlaceDirigido(enlaces: enlaces, ruta: false),
            child: Container(),
          ),
          //OPCION AGREAGAR NODO
          if (_currentIndex == 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    nodos.add(Nodo(
                      valor: " ",
                      x: details.localPosition.dx,
                      y: details.localPosition.dy,
                    ));
                  });
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          //OPCION REMOVER NODO
          if (_currentIndex == 1)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    try {
                      nodos.forEach((nodo) {
                        if (sqrt(pow(nodo.x - details.localPosition.dx, 2) +
                                pow(nodo.y - details.localPosition.dy, 2)) <
                            25) {
                          nodos.remove(nodo);
                          enlaces.removeWhere((enlace) =>
                              enlace.origen == nodo || enlace.destino == nodo);
                        }
                      });
                    } catch (e) {}
                  });
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          //OPCION MOVER NODO
          if (_currentIndex == 2)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    nodos.forEach((nodo) {
                      if (sqrt(pow(nodo.x - details.localPosition.dx, 2) +
                              pow(nodo.y - details.localPosition.dy, 2)) <
                          25) {
                        nodo.x = details.localPosition.dx;
                        nodo.y = details.localPosition.dy;
                      }
                    });
                  });
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          //OPCION AGREGAR ENLACE
          if (_currentIndex == 3)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    nodos.forEach((nodo) {
                      if (sqrt(pow(nodo.x - details.localPosition.dx, 2) +
                              pow(nodo.y - details.localPosition.dy, 2)) <
                          25) {
                        if (click == 0) {
                          nodoOrigen = nodo;
                          click = 1;
                        } else {
                          nodoDestino = nodo;
                          enlaces.add(Enlace(
                              origen: nodoOrigen,
                              destino: nodoDestino,
                              id: enlaces.length + 1,
                              peso: 0));
                          click = 0;
                        }
                      }
                    });
                  });
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),

          //OPCION MOSTRAR UNA LISTA DE LOS ENLACES Y PODER EDITARLOS O ELIMINARLOS opcion 4
          if (_currentIndex == 4)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    nodos.forEach((nodo) {
                      if (sqrt(pow(nodo.x - details.localPosition.dx, 2) +
                              pow(nodo.y - details.localPosition.dy, 2)) <
                          25) {
                        nodoSeleccionado = nodo;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Enlaces del nodo ${nodo.valor}'),
                              content: Container(
                                height: 200,
                                width: 200,
                                child: ListView.builder(
                                  itemCount: enlaces
                                      .where((enlace) =>
                                          enlace.origen == nodo ||
                                          enlace.destino == nodo)
                                      .length,
                                  itemBuilder: (context, index) {
                                    final enlacesFiltrados = enlaces
                                        .where((enlace) =>
                                            enlace.origen == nodo ||
                                            enlace.destino == nodo)
                                        .toList();
                                    final enlace = enlacesFiltrados[index];
                                    return ListTile(
                                      title: Text(
                                          'Origen: ${enlace.origen.valor} - Destino: ${enlace.destino.valor}'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            enlaces.remove(
                                                enlace); // Remueve el enlace de la lista original
                                          });
                                          Navigator.of(context)
                                              .pop(); // Cierra el dialogo
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
                  });
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),

          if (_currentIndex == 5)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onLongPressStart: (LongPressStartDetails details) {
                  setState(() {
                    nodos.forEach((nodo) {
                      if (sqrt(pow(nodo.x - details.localPosition.dx, 2) +
                              pow(nodo.y - details.localPosition.dy, 2)) <
                          25) {
                        nodoSeleccionado = nodo;
                        final enlacesFiltrados = enlaces
                            .where((enlace) =>
                                enlace.origen == nodo || enlace.destino == nodo)
                            .toList();
                        final opciones = enlacesFiltrados
                            .map((enlace) =>
                                'Enlace ${enlace.id} - Peso ${enlace.peso}')
                            .toList();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Nodo ${nodo.valor}'),
                              content: Container(
                                height: 200,
                                width: 200,
                                child: Column(
                                  children: [
                                    Text('Nodo: ${nodo.valor}'),
                                    Text('X: ${nodo.x}'),
                                    Text('Y: ${nodo.y}'),
                                    Text('Enlaces: ${enlacesFiltrados.length}'),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: opciones.length,
                                        itemBuilder: (context, index) {
                                          final enlace =
                                              enlacesFiltrados[index];
                                          return ListTile(
                                            title: Text(opciones[index]),
                                            onTap: () {
                                              _pesoController =
                                                  TextEditingController(
                                                      text: enlace.peso
                                                          .toString());
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  _pesoController =
                                                      TextEditingController(
                                                          text: enlace.peso
                                                              .toString());
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Editar peso del enlace ${enlace.id}'),
                                                    content: Container(
                                                      height: 200,
                                                      width: 200,
                                                      child: Column(
                                                        children: [
                                                          TextField(
                                                            controller:
                                                                _pesoController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: 'Peso',
                                                            ),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                enlace
                                                                    .peso = value
                                                                        .isEmpty
                                                                    ? 0
                                                                    : int.parse(
                                                                        value);
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Cancelar'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            enlace.peso =
                                                                int.parse(
                                                                    _pesoController
                                                                        .text);
                                                            int index = enlaces
                                                                .indexWhere(
                                                                    (e) =>
                                                                        e.id ==
                                                                        enlace
                                                                            .id);
                                                            enlaces[index] =
                                                                enlace;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Guardar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
                  });
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          //OPCION CAMBIAR NOMBRE
          if (_currentIndex == 6)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    try {
                      nodos.forEach((nodo) {
                        if (sqrt(pow(nodo.x - details.localPosition.dx, 2) +
                                pow(nodo.y - details.localPosition.dy, 2)) <
                            25) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Ingrese el nombre del nodo"),
                                  content: TextField(
                                    onChanged: (value) {
                                      nodo.valor = value;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Aceptar"))
                                  ],
                                );
                              });
                        }
                      });
                    } catch (e) {}
                  });
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.add_circle),
              tooltip: 'Agregar nodo',
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.edit_location),
              tooltip: 'Mover nodo',
              onPressed: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            GestureDetector(
              onLongPress: () => setState(() {
                _currentIndex = 10;
              }),
              child: IconButton(
                icon: Icon(Icons.remove_circle),
                tooltip: 'Remover nodo',
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right_alt_outlined),
              tooltip: 'Agregar enlace',
              onPressed: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.remove_circle_outline_rounded),
              tooltip: 'Remover enlace',
              onPressed: () {
                setState(() {
                  _currentIndex = 4;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.add_road_outlined),
              tooltip: 'Agregar valor enlace',
              onPressed: () {
                setState(() {
                  _currentIndex = 5;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.generating_tokens_outlined),
              tooltip: 'Cambiar nombre nodo',
              onPressed: () {
                setState(() {
                  _currentIndex = 6;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.list),
              tooltip: 'Generar Matriz de Adyacencia',
              onPressed: () {
                setState(() {
                  if (nodos.length > 0) {
                    generarMatrizAdyacencia();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('No hay nodos para generar la matriz'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Enlace> obtenerEnlacesAdyacentes(Nodo nodo) {
    List<Enlace> enlacesAdyacentes = [];
    for (Enlace enlace in enlaces) {
      if (enlace.origen == nodo || enlace.destino == nodo) {
        enlacesAdyacentes.add(enlace);
      }
    }
    return enlacesAdyacentes;
  }

  void generarMatrizAdyacencia() {
    List<List<String>> matriz = [];

    // Insertar primera fila con los números de los nodos y un espacio en blanco
    List<String> nombresNodos =
        nodos.map((nodo) => "Nodo ${nodo.valor}").toList();
    nombresNodos.insert(0, "");
    matriz.add(List<String>.filled(nombresNodos.length, "0"));
    for (int i = 1; i < nombresNodos.length; i++) {
      List<String> fila = List<String>.filled(nombresNodos.length, "0");

      // Insertar nombre del nodo en primera columna
      fila[0] = nodos[i - 1].valor;

      matriz.add(fila);
    }

    for (Enlace enlace in enlaces) {
      int origen = nodos.indexOf(enlace.origen) + 1;
      int destino = nodos.indexOf(enlace.destino) + 1;
      matriz[origen][destino] = enlace.peso.toString();
      matriz[destino][origen] = enlace.peso.toString();
    }

    List<DataColumn> columnas = List<DataColumn>.generate(
      nombresNodos.length,
      (index) {
        if (index == 0) {
          return DataColumn(label: Text("Nodo"));
        }
        return DataColumn(label: Text(nodos[index - 1].valor));
      },
    );

    List<DataRow> filas = List<DataRow>.generate(
      nombresNodos.length - 1,
      (index) => DataRow(
        cells: List<DataCell>.generate(
          nombresNodos.length,
          (j) => DataCell(Text(matriz[index + 1][j].toString())),
        ),
      ),
    );
    Grafo grafo = Grafo(nodos: nodos, enlaces: enlaces);
    // grafo.generarMatrizAdyacencia();

    showDialog(
      context: this.context,
      builder: (context) {
        return AlertDialog(
          title: Text('Matriz de Adyacencia'),
          content: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: columnas,
                  rows: filas,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
