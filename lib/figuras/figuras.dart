import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/modelos.dart';

class Nodos extends CustomPainter {
  List<Nodo> nodos;
  Nodos({required this.nodos});

  @override
  void paint(Canvas canvas, Size size) {
    //
    final paint = Paint();
    final borde = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    nodos.forEach((nodo) {
      paint.color = Color.fromARGB(255, 45, 40, 63);
      canvas.drawCircle(Offset(nodo.x, nodo.y), 25, paint);
      canvas.drawCircle(Offset(nodo.x, nodo.y), 25, borde);
      final texto = TextPainter(
        text: TextSpan(
          text: nodo.valor.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      texto.layout();
      texto.paint(canvas, Offset(nodo.x - texto.width / 2, nodo.y - 10));
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class Enlaces extends CustomPainter {
  final List<Enlace> enlaces;
  Enlaces({required this.enlaces});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 0, 0, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final borde = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    enlaces.forEach((enlace) {
      if (enlace.origen == enlace.destino) {
        // Dibujar curva tangente a la circunferencia
        final radio = 30.0; // ajusta este valor a tu gusto
        final centro_x = enlace.origen.x;
        final centro_y = enlace.origen.y;
        final angulo_inicio = -pi / 2;
        final angulo_fin = 3 * pi / 2;
        final oval =
            Rect.fromCircle(center: Offset(centro_x, centro_y), radius: radio);
        final path = Path();

        // Mover el lápiz al punto inicial de la curva
        path.moveTo(centro_x + radio, centro_y);

        // Dibujar la curva superior
        path.arcToPoint(Offset(centro_x - radio, centro_y),
            radius: Radius.circular(radio));

        // Dibujar la curva inferior
        path.arcToPoint(Offset(centro_x + radio, centro_y),
            radius: Radius.circular(radio));

        // Dibujar texto encima de la curva
        final texto = "En Nº ${enlace.id}: ${enlace.peso.toString()}";
        final textPainter = TextPainter(
          text: TextSpan(
            text: texto,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        // Mover el lápiz al punto inicial del texto
        path.moveTo(centro_x - textPainter.width / 2,
            centro_y - radio - textPainter.height);

        // Dibujar el texto
        textPainter.paint(
          canvas,
          Offset(centro_x - textPainter.width / 2,
              centro_y - radio - textPainter.height),
        );

        canvas.drawPath(path, paint);
        canvas.drawPath(path, borde);
      } else {
        // Dibujar línea recta
        final media_x = (enlace.origen.x + enlace.destino.x) / 2;
        final media_y = (enlace.origen.y + enlace.destino.y) / 2;
        canvas.drawLine(Offset(enlace.origen.x, enlace.origen.y),
            Offset(enlace.destino.x, enlace.destino.y), paint);
        canvas.drawLine(Offset(enlace.origen.x, enlace.origen.y),
            Offset(enlace.destino.x, enlace.destino.y), borde);

        // Dibujar texto
        final texto = TextSpan(
          text: "En Nº ${enlace.id}: ${enlace.peso.toString()}",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 13,
          ),
        );
        final textPainter = TextPainter(
          text: texto,
          textDirection: TextDirection.ltr,
        );

        // Obtener el path de la línea recta
        final path = Path();
        path.moveTo(enlace.origen.x, enlace.origen.y);
        path.lineTo(enlace.destino.x, enlace.destino.y);

        // Calcular la distancia entre los nodos origen y destino
        final distancia = sqrt(pow(enlace.destino.x - enlace.origen.x, 2) +
            pow(enlace.destino.y - enlace.origen.y, 2));

        if (distancia > 0) {
          // Dibujar texto en el centro de la línea recta
          final desplazamiento = 20.0; // ajusta este valor a tu gusto
          final despl_x =
              desplazamiento * (enlace.destino.y - enlace.origen.y) / distancia;
          final despl_y =
              desplazamiento * (enlace.origen.x - enlace.destino.x) / distancia;
          textPainter.layout(minWidth: 0, maxWidth: size.width - media_x);
          textPainter.paint(
              canvas, Offset(media_x + despl_x, media_y + despl_y));
        }
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
