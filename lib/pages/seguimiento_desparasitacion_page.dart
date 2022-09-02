import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/models/registro_desparacitaciones_model.dart';
import 'package:admin_web_v1/providers/formularios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:flutter/material.dart';

class VerRegistroDespPage extends StatefulWidget {
  const VerRegistroDespPage({Key? key}) : super(key: key);

  @override
  State<VerRegistroDespPage> createState() => _VerRegistroDespPageState();
}

class _VerRegistroDespPageState extends State<VerRegistroDespPage> {
  final formKey = GlobalKey<FormState>();
  FormulariosProvider formulariosProvider = FormulariosProvider();
  AnimalModel animal = AnimalModel();
  FormulariosModel formularios = FormulariosModel();
  DatosPersonalesModel datosA = DatosPersonalesModel();

  List<RegistroDesparasitacionModel> desparasitaciones = [];
  List<Future<RegistroDesparasitacionModel>> listaD = [];
  final userProvider = UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    datosA = arg['datosper'] as DatosPersonalesModel;
    formularios = arg['formulario'] as FormulariosModel;
    animal = arg['animal'] as AnimalModel;
    return Scaffold(
        backgroundColor: const Color.fromARGB(223, 211, 212, 207),
        appBar: AppBar(
          title: const Text('Registros de desparasitación'),
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
        drawer: _menuWidget(),
        body: Stack(
          children: [
            //Background(),
            SingleChildScrollView(
                child: Container(
                    //color: Colors.lightGreenAccent,
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Registro de desparasitación',
                              style: TextStyle(
                                fontSize: 28,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = Colors.blueGrey,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            _crearListado()
                          ],
                        ))))
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

  Widget _crearListado() {
    return FutureBuilder(
        future: formulariosProvider.cargarRegDesp(formularios.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<RegistroDesparasitacionModel>> snapshot) {
          if (snapshot.hasData) {
            final desp = snapshot.data;
            return Column(
              children: [
                SizedBox(
                  height: 650,
                  child: ListView.builder(
                    itemCount: desp!.length,
                    itemBuilder: (context, i) => _crearItem(context, desp[i]),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(
      BuildContext context, RegistroDesparasitacionModel desparasitacion) {
    return ListTile(
        title: Column(
          children: [
            const Divider(color: Colors.transparent),
            DataTable(
              columnSpacing: 25,
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => const Color.fromARGB(255, 120, 110, 148),
              ),
              dataRowColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromARGB(255, 146, 155, 185)),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                border: Border.all(width: 1, color: Colors.white),
              ),
              sortColumnIndex: 1,
              sortAscending: false,
              columns: const [
                DataColumn(label: Text("Fecha consulta")),
                DataColumn(label: Text("Producto")),
              ],
              rows: [
                DataRow(selected: true, cells: [
                  DataCell(Container(
                    width: 137,
                    child: Text(desparasitacion.fecha),
                  )),
                  DataCell(Container(
                    width: 137,
                    child: Text(desparasitacion.nombreProducto),
                  )),
                ]),
              ],
            ),
            DataTable(
              //columnSpacing: 50,
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => const Color.fromARGB(255, 120, 111, 143),
              ),
              dataRowColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromARGB(255, 146, 155, 185)),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                border: Border.all(width: 1, color: Colors.white),
              ),
              //sortColumnIndex: 1,
              //sortAscending: false,
              columns: const [
                //DataColumn(label: Text("Peso(Kg)"), numeric: true),
                DataColumn(label: Text("Peso(Kg)")),
                DataColumn(label: Text("Proxima desparacitación")),
              ],
              rows: [
                DataRow(selected: true, cells: [
                  DataCell(Container(
                    width: 85,
                    child: Text('${desparasitacion.pesoActual}'),
                  )),
                  DataCell(Container(
                    width: 90,
                    child: Text('${desparasitacion.fechaProxDesparasitacion}'),
                  )),
                ]),
              ],
            ),
            const Divider(color: Colors.transparent)
          ],
        ),
        onTap: () async {});
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
            onTap: () => Navigator.pushNamed(context, 'seguimientoInfo',
                arguments: {
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
            onTap: () => Navigator.pushNamed(context, 'verRegistroVacunas',
                arguments: {
                  'datosper': datosA,
                  'formulario': formularios,
                  'animal': animal
                }),
          ),
          ListTile(
            leading: const Icon(Icons.check, color: Colors.green),
            title: const Text('Ver Registro Desparasitación'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushNamed(context, 'verRegistroDesp', arguments: {
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
              Navigator.pushNamed(context, 'verEvidenciaP1', arguments: {
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
              Navigator.pushNamed(context, 'verEvidenciaP2', arguments: {
                'datosper': datosA,
                'formulario': formularios,
                'animal': animal
              });
            },
          ),
        ],
      ),
    );
  }
}
