import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/formularios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SeguimientoPrincipalPage extends StatefulWidget {
  const SeguimientoPrincipalPage({Key? key}) : super(key: key);

  @override
  State<SeguimientoPrincipalPage> createState() =>
      _SeguimientoPrincipalPageState();
}

class _SeguimientoPrincipalPageState extends State<SeguimientoPrincipalPage> {
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
        title: const Text('LISTA DE ADOPCIONES'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: const Icon(Icons.manage_accounts),
              itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Informacion"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Ayuda"),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("Cerrar Sesion"),
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
          //     fit: BoxFit.cover,
          //   ),
          // ),
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SEGUIMIENTO DE ADOPCIONES",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
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
              elevation: 8,
              margin: const EdgeInsets.all(10),
              child: Container(
                height: 100,
                color: Colors.white,
                child: Row(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Expanded(
                          flex: 2,
                          child: Image.asset("assets/pet.jpg"),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ListTile(
                                title: Text(formulario.animal!.nombre),
                                subtitle: Text(
                                    "Adoptante: " + formulario.nombreClient),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    child: const Text("REALIZAR SEGUIMIENTO"),
                                    onPressed: () async {
                                      datosC =
                                          await formulariosProvider.cargarDPId(
                                              formulario.id,
                                              formulario.idDatosPersonales);
                                      animal = await animalesProvider
                                          .cargarAnimalId(formulario.idAnimal);

                                      Navigator.pushReplacementNamed(
                                          context, 'seguimientoInfo',
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
                    ),
                  ],
                ),
              ),
            ),
            // Divider(color: Colors.purple)
          ],
        ),
        //subtitle: Text('${horario}'),
        onTap: () async {
          datosC = await formulariosProvider.cargarDPId(
              formulario.id, formulario.idDatosPersonales);
          animal = await animalesProvider.cargarAnimalId(formulario.idAnimal);

          // Navigator.pushNamed(context, 'seguimientoMain', arguments: {
          //   'datosper': datosC,
          //   'formulario': formulario,
          //   'animal': animal
          // });
        });
  }
}
