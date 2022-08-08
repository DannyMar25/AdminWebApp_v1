import 'dart:html';

import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';

import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SolicitudAprobadaMainPage extends StatefulWidget {
  const SolicitudAprobadaMainPage({Key? key}) : super(key: key);

  //const SeguimientoPage({Key? key}) : super(key: key);

  @override
  State<SolicitudAprobadaMainPage> createState() =>
      _SolicitudAprobadaMainPageState();
}

class _SolicitudAprobadaMainPageState extends State<SolicitudAprobadaMainPage> {
  final formKey = GlobalKey<FormState>();
  FirebaseStorage storage = FirebaseStorage.instance;
  AnimalModel animal = AnimalModel();
  File? foto;
  DatosPersonalesModel datosA = DatosPersonalesModel();
  FormulariosModel formularios = FormulariosModel();
  final userProvider = UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    //if (dat == arg['datosper']) {
    datosA = arg['datosper'] as DatosPersonalesModel;
    print(datosA.id);
    formularios = arg['formulario'] as FormulariosModel;
    animal = arg['animal'] as AnimalModel;
    return Scaffold(
        backgroundColor: const Color.fromARGB(223, 221, 248, 153),
        appBar: AppBar(
          title: const Text('Datos de mascota adoptada'),
          backgroundColor: Colors.green,
          actions: [
            PopupMenuButton<int>(
                onSelected: (item) => onSelected(context, item),
                icon: const Icon(Icons.manage_accounts),
                itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                        child: Text("Informacion"),
                        value: 0,
                      ),
                      const PopupMenuItem<int>(
                        child: Text("Ayuda"),
                        value: 1,
                      ),
                      const PopupMenuItem<int>(
                        child: Text("Cerrar Sesion"),
                        value: 2,
                      )
                    ]),
          ],
        ),
        drawer: const MenuWidget(),
        body: Stack(
          alignment: Alignment.center,
          children: [
            //Background(),
            //_verGaleria(context),
            //Text('Hola'),
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Informacion de la mascota adoptada',
                          style: TextStyle(
                            fontSize: 28,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Colors.blueAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        _mostrarFoto(),
                        const Divider(
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Nombre: ',
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              '${animal.nombre}                                ',
                              textAlign: TextAlign.left,
                            ),
                            const Text(
                              'Edad: ',
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              '${animal.etapaVida}      ',
                              textAlign: TextAlign.left,
                            ),
                            const Text(
                              'Raza: ',
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              animal.raza,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Color: ',
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              '${animal.color}               ',
                              textAlign: TextAlign.left,
                            ),
                            const Text(
                              'Tamaño: ',
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              '${animal.tamanio}      ',
                              textAlign: TextAlign.left,
                            ),
                            const Text(
                              'Sexo: ',
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              animal.sexo,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const Divider(),
                        const Divider(
                          color: Colors.white,
                        ),
                        Text(
                          'Informacion del adoptante',
                          style: TextStyle(
                            fontSize: 28,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Colors.blueAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        const Divider(
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Nombre: ',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${datosA.nombreCom}  ',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text(
                              'Direccion: ',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              datosA.direccion,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text(
                              'Telefono: ',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              datosA.telfCel,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text(
                              'Correo: ',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              datosA.email,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                    //_crearBoton(context),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 2:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
    }
  }

  Widget _mostrarFoto() {
    if (animal.fotoUrl != '') {
      return FadeInImage(
        image: NetworkImage(animal.fotoUrl),
        placeholder: const AssetImage('assets/jar-loading.gif'),
        height: 300,
        fit: BoxFit.contain,
      );
    } else {
      // if (foto != null) {
      //   return Image.file(
      //     foto!,
      //     fit: BoxFit.cover,
      //     height: 300.0,
      //   );
      // }
      return Image.asset('assets/no-image.png');
    }
  }
}
