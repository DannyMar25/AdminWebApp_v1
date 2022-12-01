import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/donaciones_provider.dart';
import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(
                Icons.warning_outlined,
                color: Colors.yellow,
                size: 50,
              ),
              Text('¡Atención!'),
            ],
          ),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      });
}

void mostrarAlertaOk(BuildContext context, String mensaje, String ruta) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              Text('Información correcta'),
            ],
          ),
          content: Text(mensaje),
          actions: [
            TextButton(
                child: const Text('Ok'),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () => Navigator.pushNamed(context, ruta)),
          ],
        );
      });
}

void mostrarAlertaOk1(
    BuildContext context, String mensaje, String ruta, String titulo) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              Text(titulo),
            ],
          ),
          content: Text(mensaje),
          actions: [
            TextButton(
                child: const Text('Ok'),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () => Navigator.pushNamed(context, ruta)),
          ],
        );
      });
}

void mostrarMensaje(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Información correcta'),
          content: Text(mensaje),
          actions: [
            TextButton(
                child: const Text('Ok'),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () => Navigator.of(context).pop()),
          ],
        );
      });
}

void mostrarAlertaAuth(BuildContext context, String mensaje, String ruta) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Correo inválido'),
          content: Text(mensaje),
          actions: [
            TextButton(
                child: const Text('Ok'),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () => Navigator.pushNamed(context, ruta)),
          ],
        );
      });
}

void mostrarAlertaBorrar(BuildContext context, String mensaje, String id) {
  final animalProvider = AnimalesProvider();
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(
                Icons.warning_outlined,
                color: Colors.yellow,
                size: 50,
              ),
              Text('¡Atención!'),
            ],
          ),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: const Text('Si'),
              onPressed: () {
                animalProvider.borrarAnimal(id);
                mostrarAlertaOk(
                    context, 'El registro ha sido eliminado.', 'home');
                //Navigator.pushNamed(context, 'home');
              },
              //onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Cancelar'),
              //onPressed: () {},
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      });
}

void mostrarAlertaBorrarDonacion(
    BuildContext context, String mensaje, String id) {
  final donacionesProvider = DonacionesProvider();
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿ Está seguro de borrar el registro.?'),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: const Text('Si'),
              onPressed: () {
                donacionesProvider.borrarDonacion(id);
                mostrarAlertaOk(
                    context, 'El registro ha sido eliminado.', 'home');
                //Navigator.pushNamed(context, 'home');
              },
              //onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Cancelar'),
              //onPressed: () {},
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      });
}

String? validarEmail(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value)) {
    return 'Ingrese una dirección de correo valida.';
  } else {
    return null;
  }
}
