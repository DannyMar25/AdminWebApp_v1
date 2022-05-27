import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/models/registro_desparacitaciones_model.dart';
import 'package:admin_web_v1/providers/formularios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/background.dart';
import 'package:flutter/material.dart';

class VerRegistroDespPage extends StatefulWidget {
  const VerRegistroDespPage({Key? key}) : super(key: key);

  @override
  State<VerRegistroDespPage> createState() => _VerRegistroDespPageState();
}

class _VerRegistroDespPageState extends State<VerRegistroDespPage> {
  final formKey = GlobalKey<FormState>();
  FormulariosProvider formulariosProvider = new FormulariosProvider();
  AnimalModel animal = new AnimalModel();
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosA = new DatosPersonalesModel();

  List<RegistroDesparasitacionModel> desparasitaciones = [];
  List<Future<RegistroDesparasitacionModel>> listaD = [];
  final userProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    datosA = arg['datosper'] as DatosPersonalesModel;
    formularios = arg['formulario'] as FormulariosModel;
    animal = arg['animal'] as AnimalModel;
    return Scaffold(
        backgroundColor: const Color.fromARGB(223, 211, 212, 207),
        appBar: AppBar(
          title: const Text('Registros de desparasitacion'),
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
          children: [
            // Background(),
            SingleChildScrollView(
                child: Container(
                    //color: Colors.lightGreenAccent,
                    padding: new EdgeInsets.only(top: 10.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Registro de desparasitacion',
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
        break;
      case 1:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 2:
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
                  height: 700,
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
                  DataCell(SizedBox(
                    child: Text(desparasitacion.fecha),
                    width: 137,
                  )),
                  //DataCell(_crearPesoActual()),
                  DataCell(SizedBox(
                    child: Text(desparasitacion.nombreProducto),
                    width: 137,
                  )),
                ]),
              ],
            ),
            DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => const Color.fromARGB(255, 120, 111, 143),
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
                DataColumn(label: Text("Peso(Kg)")),
                DataColumn(label: Text("Proxima desparacitacion")),
              ],
              rows: [
                DataRow(selected: true, cells: [
                  DataCell(SizedBox(
                    child: Text('${desparasitacion.pesoActual}'),
                    width: 100,
                  )),
                  DataCell(SizedBox(
                    child: Text(desparasitacion.fechaProxDesparasitacion),
                    width: 100,
                  )),
                ]),
              ],
            ),
            const Divider(color: Colors.transparent)
          ],
        ),
        //subtitle: Text('${horario}'),
        onTap: () async {
          // datosA = await formulariosProvider.cargarDPId(
          //     formulario.id, formulario.idDatosPersonales);
          // animal = await animalesProvider.cargarAnimalId(formulario.idAnimal);

          // Navigator.pushNamed(context, 'seguimientoMain', arguments: {
          //   'datosper': datosA,
          //   'formulario': formulario,
          //   'animal': animal
          // });
        });
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
            title: const Text('Ir a  Seguimiento Principal'),
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
        ],
      ),
    );
  }
}
