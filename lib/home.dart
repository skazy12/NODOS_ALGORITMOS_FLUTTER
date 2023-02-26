import 'dart:math';

import 'package:flutter/material.dart';

import 'figuras/figuras.dart';
import 'models/modelos.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Nodo nodoOrigen = Nodo(valor: 0, x: 0, y: 0);
  Nodo nodoDestino = Nodo(valor: 0, x: 0, y: 0);
  Nodo nodoSeleccionado = Nodo(valor: 0, x: 0, y: 0);
  int click = 0;
  List<Nodo> nodos = [];
  List<Enlace> enlaces = [];
  TextEditingController _pesoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grafo'),
        //Boton de ayuda para desplegar un dialogo con la ayuda
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Ayuda'),
                    //TEXTO DE AYUDA
                    content: Text('Aquí va la ayuda'),
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
      body: Stack(
        children: [
          CustomPaint(
            painter: Nodos(nodos: nodos),
            child: Container(),
          ),
          CustomPaint(
            painter: Enlaces(enlaces: enlaces),
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
                        valor: nodos.length + 1,
                        x: details.localPosition.dx,
                        y: details.localPosition.dy));
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
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Agregar nodo',
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Mover nodo',
              onPressed: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              tooltip: 'Remover nodo',
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Agregar enlace',
              onPressed: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              tooltip: 'Remover enlace',
              onPressed: () {
                setState(() {
                  _currentIndex = 4;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Agregar valor enlace',
              onPressed: () {
                setState(() {
                  _currentIndex = 5;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.calculate),
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
    List<List<int>> matriz = [];

    // Insertar primera fila con los números de los nodos y un espacio en blanco
    List<String> nombresNodos =
        nodos.map((nodo) => "Nodo ${nodo.valor}").toList();
    nombresNodos.insert(0, "");
    matriz.add(List<int>.filled(nombresNodos.length, 0));
    for (int i = 1; i < nombresNodos.length; i++) {
      List<int> fila = List<int>.filled(nombresNodos.length, 0);

      // Insertar nombre del nodo en primera columna
      fila[0] = i;

      matriz.add(fila);
    }

    for (Enlace enlace in enlaces) {
      int origen = nodos.indexOf(enlace.origen) + 1;
      int destino = nodos.indexOf(enlace.destino) + 1;
      matriz[origen][destino] = enlace.peso;
      matriz[destino][origen] = enlace.peso;
    }

    List<DataColumn> columnas = List<DataColumn>.generate(
      nombresNodos.length,
      (index) {
        if (index == 0) {
          return DataColumn(label: Text(""));
        }
        return DataColumn(label: Text(nombresNodos[index]));
      },
    );

    List<DataRow> filas = List<DataRow>.generate(
      nombresNodos.length - 1,
      (index) => DataRow(
        cells: List<DataCell>.generate(
          nombresNodos.length,
          (j) => DataCell(Text(matriz[index + 1][j].toString() + " ")),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Matriz de Adyacencia'),
          content: SingleChildScrollView(
            child: DataTable(
              columns: columnas,
              rows: filas,
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
