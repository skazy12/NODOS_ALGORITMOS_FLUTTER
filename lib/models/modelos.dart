class Nodo {
  final int valor;
  String nombre;
  double x;
  double y;

  Nodo(
      {required this.valor,
      required this.x,
      required this.y,
      required this.nombre});
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
}
