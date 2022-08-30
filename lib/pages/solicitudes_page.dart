import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/formularios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class SolicitudesPage extends StatefulWidget {
  const SolicitudesPage({Key? key}) : super(key: key);

  @override
  State<SolicitudesPage> createState() => _SolicitudesPageState();
}

class _SolicitudesPageState extends State<SolicitudesPage> {
  List<FormulariosModel> formularioA = [];
  List<Future<FormulariosModel>> formularioC = [];
  DatosPersonalesModel datosC = DatosPersonalesModel();
  AnimalModel animal = AnimalModel();
  final formKey = GlobalKey<FormState>();
  final formulariosProvider = FormulariosProvider();
  //final horariosProvider = new HorariosProvider();
  final animalesProvider = AnimalesProvider();
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
        title: const Text('Solicitudes'),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _verListado(),
                // _crearBoton(),
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
        Navigator.pushNamed(context, 'soporte');
        break;
      case 1:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
    }
  }

  showCitas() async {
    formularioC = await formulariosProvider.cargarFormularios();
    for (var yy in formularioC) {
      FormulariosModel form = await yy;
      setState(() {
        formularioA.add(form);
      });
    }
  }

  Widget _verListado() {
    return Column(
      children: [
        SizedBox(
          height: 800,
          child: ListView.builder(
            itemCount: formularioA.length,
            itemBuilder: (context, i) => _crearItem(context, formularioA[i]),
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, FormulariosModel formulario) {
    //String fecha = cita.horario!.dia;
    //String hora = cita.horario!.hora;
    return ListTile(
      title: Column(
        children: [
          //Divider(color: Colors.purple),
          Card(
            elevation: 8,
            margin: const EdgeInsets.all(10),
            child: Container(
              height: 170,
              color: Colors.white,
              child: Row(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0.1),
                      child: Expanded(
                        flex: 5,
                        child: Image.asset(
                          "assets/pet.jpg",
                          height: 130,
                        ),
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
                            flex: 20,
                            child: ListTile(
                              title:
                                  Text("Cliente: ${formulario.nombreClient}"),
                              subtitle: Column(
                                children: [
                                  Text("Fecha de solicitud:"
                                      '${formulario.fechaIngreso}'),

                                  // Text("Identificacion: " +
                                  //     '${formulario.identificacion}'),
                                  Text("Posible adoptante para: "
                                      '${formulario.animal!.nombre}'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: const Text("VER INFO"),
                                  onPressed: () => Navigator.pushNamed(
                                      context, 'verSolicitudesMain',
                                      arguments: formulario),
                                  //
                                ),
                                const SizedBox(
                                  width: 5, //8
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
    );
  }
}
