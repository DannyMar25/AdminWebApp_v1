import 'dart:html';

import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class InformacionSeguimientoPage extends StatefulWidget {
  //const SeguimientoPage({Key? key}) : super(key: key);

  @override
  State<InformacionSeguimientoPage> createState() =>
      _InformacionSeguimientoPageState();
}

class _InformacionSeguimientoPageState
    extends State<InformacionSeguimientoPage> {
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
        backgroundColor: const Color.fromARGB(223, 245, 247, 240),
        appBar: AppBar(
          title: const Text('Segimiento de mascota adoptada'),
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
        drawer: _menuWidget(),
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
                    _crearBoton(context),
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

  Widget _obtenerImagenes() {
    Reference ref = storage.ref().child(
        'gs://flutter-varios-1637a.appspot.com/animales/0H05tnjVPjfF1E8DBw0p');

    String url = ref.getDownloadURL() as String;
    //Image.network(url);
    return Image.network(url);
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

  Widget _crearBoton(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
                style: ButtonStyle(
                  //padding: new EdgeInsets.only(top: 5),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    return Colors.green;
                  }),
                ),
                label: const Text('Ver Vacunas'),
                icon: const Icon(Icons.fact_check),
                autofocus: true,
                onPressed: () {
                  // Navigator.pushNamed(context, 'registroVacunas',
                  //     arguments: animal);
                  Navigator.pushReplacementNamed(context, 'verRegistroVacunas',
                      arguments: {
                        'datosper': datosA,
                        'formulario': formularios,
                        'animal': animal
                      });
                }),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return Colors.green;
                    }),
                  ),
                  label: const Text('Ver Desparasitaciones'),
                  icon: const Icon(Icons.fact_check),
                  autofocus: true,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'verRegistroDesp',
                        arguments: {
                          'datosper': datosA,
                          'formulario': formularios,
                          'animal': animal
                        });
                  }),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    return Colors.green;
                  }),
                ),
                label: const Text('Ver fotos'),
                icon: const Icon(Icons.fact_check),
                autofocus: true,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'verEvidenciaP1',
                      arguments: {
                        'datosper': datosA,
                        'formulario': formularios,
                        'animal': animal
                      });
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    return Colors.green;
                  }),
                ),
                label: const Text('Ver Archivos'),
                icon: const Icon(Icons.fact_check),
                autofocus: true,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'verEvidenciaP2',
                      arguments: {
                        'datosper': datosA,
                        'formulario': formularios,
                        'animal': animal
                      });
                }),
          ),
        ]),
      ],
    );
  }

  Widget _menuWidget() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pet-care.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.pages,
              color: Colors.green,
            ),
            title: const Text('Ir a Seguimiento Principal'),
            onTap: () => Navigator.pushReplacementNamed(
                context, 'seguimientoInfo', arguments: {
              'datosper': datosA,
              'formulario': formularios,
              'animal': animal
            }),
          ),
          ListTile(
            leading: const Icon(
              Icons.check,
              color: Colors.green,
            ),
            title: const Text('Ver Registros Vacunas'),
            onTap: () => Navigator.pushReplacementNamed(
                context, 'verRegistroVacunas', arguments: {
              'datosper': datosA,
              'formulario': formularios,
              'animal': animal
            }),
          ),
          ListTile(
            leading: const Icon(Icons.check, color: Colors.green),
            title: const Text('Ver Registro Desparasitacion'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'verRegistroDesp',
                  arguments: {
                    'datosper': datosA,
                    'formulario': formularios,
                    'animal': animal
                  });
            },
          ),
          ListTile(
            leading: const Icon(Icons.check, color: Colors.green),
            title: const Text('Ver Fotos'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'verEvidenciaP1',
                  arguments: {
                    'datosper': datosA,
                    'formulario': formularios,
                    'animal': animal
                  });
            },
          ),
          ListTile(
            leading: const Icon(Icons.check, color: Colors.green),
            title: const Text('Ver Archivos'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'verEvidenciaP2',
                  arguments: {
                    'datosper': datosA,
                    'formulario': formularios,
                    'animal': animal
                  });
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.pages,
              color: Colors.green,
            ),
            title: const Text('Ir a Lista adopciones'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, 'seguimientoPrincipal'),
          ),
        ],
      ),
    );
  }
}
