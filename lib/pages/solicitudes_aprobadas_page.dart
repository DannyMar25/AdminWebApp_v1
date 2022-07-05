import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/formularios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SolicitudesAprobadasPage extends StatefulWidget {
  const SolicitudesAprobadasPage({Key? key}) : super(key: key);

  @override
  State<SolicitudesAprobadasPage> createState() =>
      _SolicitudesAprobadasPageState();
}

class _SolicitudesAprobadasPageState extends State<SolicitudesAprobadasPage> {
  final formKey = GlobalKey<FormState>();
  FormulariosProvider formulariosProvider = FormulariosProvider();
  AnimalesProvider animalesProvider = AnimalesProvider();

  //List<Future<FormulariosModel>> formulario = [];
  List<FormulariosModel> formularios = [];
  List<Future<FormulariosModel>> listaF = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  AnimalModel animal = AnimalModel();
  DatosPersonalesModel datosC = DatosPersonalesModel();
  final userProvider = UsuarioProvider();

  @override
  void initState() {
    super.initState();
    showCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOLICITUDES APROBADAS'),
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
      body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/fondoanimales.jpg"),
          //     // colorFilter: new ColorFilter.mode(
          //     //   Colors.black.withOpacity(0.9), BlendMode.dstATop),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   "SOLICITUDES APROBADAS",
                //   style: const TextStyle(
                //       fontWeight: FontWeight.bold, fontSize: 20),
                // ),
                const Padding(padding: EdgeInsets.only(bottom: 12.0)),
                _verListado()
              ],
            ),
          ),
        ),
      ),
    );
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

  showCitas() async {
    listaF = await formulariosProvider.cargarInfo();
    for (var yy in listaF) {
      FormulariosModel form = await yy;
      setState(() {
        formularios.add(form);
      });
    }
  }

  Widget _verListado() {
    return Column(
      children: [
        SizedBox(
          height: 800,
          child: ListView.builder(
            itemCount: formularios.length,
            itemBuilder: (context, i) => _crearItem(context, formularios[i]),
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, FormulariosModel formulario) {
    return ListTile(
      title: Column(
        children: [
          //Divider(color: Colors.purple),
          Card(
            child: Container(
              height: 100,
              color: Colors.white,
              child: Row(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Expanded(
                        child: Image.asset("assets/pet.jpg"),
                        flex: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: ListTile(
                              title: Text(formulario.animal!.nombre),
                              subtitle:
                                  Text("Adoptante: " + formulario.nombreClient),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: const Text("VER INFO"),
                                  onPressed: () async {
                                    datosC =
                                        await formulariosProvider.cargarDPId(
                                            formulario.id,
                                            formulario.idDatosPersonales);
                                    animal = await animalesProvider
                                        .cargarAnimalId(formulario.idAnimal);

                                    Navigator.pushReplacementNamed(
                                        context, 'verSolicitudAprobada',
                                        arguments: {
                                          'datosper': datosC,
                                          'formulario': formulario,
                                          'animal': animal
                                        });
                                  },
                                ),
                                const SizedBox(
                                  width: 8,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    flex: 8,
                  ),
                ],
              ),
            ),
            elevation: 8,
            margin: const EdgeInsets.all(10),
          ),
          // Divider(color: Colors.purple)
        ],
      ),
    );
  }
}
