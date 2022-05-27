import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/models/registro_vacunas_model.dart';
import 'package:admin_web_v1/providers/formularios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:flutter/material.dart';

class VerRegistroVacunasPage extends StatefulWidget {
  const VerRegistroVacunasPage({Key? key}) : super(key: key);

  @override
  State<VerRegistroVacunasPage> createState() => _VerRegistroVacunasPageState();
}

class _VerRegistroVacunasPageState extends State<VerRegistroVacunasPage> {
  final formKey = GlobalKey<FormState>();
  FormulariosProvider formulariosProvider = new FormulariosProvider();
  AnimalModel animal = new AnimalModel();
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosA = new DatosPersonalesModel();

  List<RegistroVacunasModel> vacunas = [];
  List<Future<RegistroVacunasModel>> listaV = [];
  final userProvider = new UsuarioProvider();

  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    datosA = arg['datosper'] as DatosPersonalesModel;
    formularios = arg['formulario'] as FormulariosModel;
    animal = arg['animal'] as AnimalModel;
    return Scaffold(
        backgroundColor: const Color.fromARGB(223, 211, 212, 207),
        appBar: AppBar(
          title: const Text('Registros'),
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
        body: Stack(children: [
          //Background(),
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
                            'Registro de vacunas',
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
        ]));
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
        future: formulariosProvider.cargarVacunas(formularios.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<RegistroVacunasModel>> snapshot) {
          if (snapshot.hasData) {
            final vacunas = snapshot.data;
            return Column(
              children: [
                SizedBox(
                  height: 700,
                  child: ListView.builder(
                    itemCount: vacunas!.length,
                    itemBuilder: (context, i) =>
                        _crearItem(context, vacunas[i]),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, RegistroVacunasModel vacuna) {
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
              columns: const [
                DataColumn(label: Text("Fecha")),
                DataColumn(label: Text("Peso(Kg)")),
                DataColumn(label: Text("Proxima vacuna")),
              ],
              rows: [
                DataRow(selected: true, cells: [
                  DataCell(SizedBox(
                    child: Text(vacuna.fechaConsulta),
                    width: 110,
                  )),
                  DataCell(SizedBox(
                    child: Text('${vacuna.pesoActual}'),
                    width: 50,
                  )),
                  DataCell(SizedBox(
                    child: Text(vacuna.fechaProximaVacuna),
                    width: 105,
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
              columns: const [
                DataColumn(label: Text("Vacuna Laboratorio")),
                DataColumn(label: Text("Veterinario ")),
              ],
              rows: [
                DataRow(selected: true, cells: [
                  DataCell(SizedBox(
                    child: Text(vacuna.tipoVacuna),
                    width: 170,
                  )),
                  DataCell(SizedBox(
                    child: Text(vacuna.veterinarioResp),
                    width: 170,
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
              Navigator.pop(context);
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
              Navigator.pop(context);
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
