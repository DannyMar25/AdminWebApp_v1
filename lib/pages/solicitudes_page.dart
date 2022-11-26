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
        title: const Text('Solicitudes pendientes'),
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
        child: Center(
          child: Container(
            width: 850,
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
    DateTime fechaIngresoT = DateTime.parse(formulario.fechaIngreso);
    String fechaIn =
        '${fechaIngresoT.year}-${fechaIngresoT.month}-${fechaIngresoT.day}';
    return ListTile(
      title: Column(
        children: [
          //Divider(color: Colors.purple),
          SizedBox(
            width: 500.0,
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              margin: const EdgeInsets.all(10),
              child: Container(
                height: 110,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0.1),
                        child: Expanded(
                          flex: 5,
                          child: Image.asset(
                            "assets/pet.jpg",
                            height: 90,
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
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              flex: 20,
                              child: ListTile(
                                title:
                                    Text("Cliente: ${formulario.nombreClient}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text("Fecha de solicitud:"
                                        '$fechaIn'
                                        '\n'
                                        "Posible adoptante para: "
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
                                    width: 8, //8
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Divider(color: Colors.purple)
        ],
      ),
    );
  }
}
