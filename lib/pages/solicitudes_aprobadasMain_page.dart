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
    //print(datosA.id);
    formularios = arg['formulario'] as FormulariosModel;
    animal = arg['animal'] as AnimalModel;
    return Scaffold(
        //backgroundColor: Color.fromARGB(223, 221, 248, 153),
        backgroundColor: const Color.fromARGB(223, 245, 247, 240),
        appBar: AppBar(
          title: const Text('Datos de mascota adoptada'),
          backgroundColor: Colors.green,
          actions: [
            PopupMenuButton<int>(
                onSelected: (item) => onSelected(context, item),
                icon: const Icon(Icons.manage_accounts),
                itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("Soporte"),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text("Cerrar Sesión"),
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
              child: Container(
                //color: Colors.lightGreenAccent,
                //padding: new EdgeInsets.only(top: 230.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Información de la mascota adoptada',
                            style: TextStyle(
                              fontSize: 28,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.blueAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(
                            color: Colors.transparent,
                          ),
                          _mostrarFoto(),
                          const Divider(
                            color: Colors.white,
                          ),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Nombre: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${animal.nombre}                                ',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Etapa de vida: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${animal.etapaVida}      ',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Raza: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  animal.raza,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.transparent,
                          ),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Color: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${animal.color}               ',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Tamaño: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${animal.tamanio}      ',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Sexo: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  animal.sexo,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const Divider(
                            color: Colors.white,
                          ),
                          Text(
                            'Información del adoptante',
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                'Dirección: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                'Teléfono: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
              ),
            )
          ],
        ));
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 1:
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
      if (foto != null) {
        // return Image.file(
        //   foto!,
        //   fit: BoxFit.cover,
        //   height: 300.0,
        // );
      }
      return Image.asset('assets/no-image.png');
    }
  }
}
