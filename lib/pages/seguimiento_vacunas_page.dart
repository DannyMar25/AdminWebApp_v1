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
  FormulariosProvider formulariosProvider = FormulariosProvider();
  AnimalModel animal = AnimalModel();
  FormulariosModel formularios = FormulariosModel();
  DatosPersonalesModel datosA = DatosPersonalesModel();
  final userProvider = UsuarioProvider();

  List<RegistroVacunasModel> vacunas = [];
  List<Future<RegistroVacunasModel>> listaV = [];

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
        backgroundColor: const Color.fromARGB(255, 236, 234, 219),
        appBar: AppBar(
          title: const Text('Lista de vacunas'),
          backgroundColor: Colors.green,
          actions: [
            PopupMenuButton<int>(
                onSelected: (item) => onSelected(context, item),
                icon: const Icon(Icons.account_circle),
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
        body: Stack(children: [
          //Background(),
          SingleChildScrollView(
              child: Center(
            child: Container(
                width: 850,
                //color: Colors.lightGreenAccent,
                padding: const EdgeInsets.only(top: 10.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Registros',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 243, 165, 9),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        _crearListado()
                      ],
                    ))),
          ))
        ]));
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
        future: formulariosProvider.cargarVacunas(formularios.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<RegistroVacunasModel>> snapshot) {
          if (snapshot.hasData) {
            final vacunas = snapshot.data;
            return Column(
              children: [
                SizedBox(
                  height: 650,
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
            SizedBox(
              height: 245.0,
              width: 650.0,
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white)),
                color: const Color.fromARGB(255, 243, 243, 230),
                elevation: 8,
                shadowColor: const Color.fromARGB(255, 19, 154, 156),
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(1.0)),
                    ColoredBox(
                      color: const Color.fromARGB(255, 51, 178, 213),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          //Padding(padding: EdgeInsets.only(top: 15)),
                          SizedBox(
                              height: 50.0,
                              width: 125.0,
                              child: Center(
                                child: Text(
                                  'Fecha de consulta',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                              height: 50.0,
                              width: 70.0,
                              child: Center(
                                child: Text(
                                  'Peso (Kg.)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                              height: 50.0,
                              width: 125.0,
                              child: Center(
                                child: Text(
                                  'Próxima vacuna',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            height: 50.0,
                            width: 125.0,
                            child: Center(
                                child: Text(
                              vacuna.fechaConsulta,
                              textAlign: TextAlign.center,
                            ))),
                        SizedBox(
                            height: 50.0,
                            width: 70.0,
                            child: Center(
                              child: Text(
                                vacuna.pesoActual.toString(),
                                textAlign: TextAlign.center,
                              ),
                            )),
                        SizedBox(
                            height: 50.0,
                            width: 125.0,
                            child: Center(
                                child: Text(
                              vacuna.fechaProximaVacuna,
                              textAlign: TextAlign.center,
                            )))
                      ],
                    ),
                    ColoredBox(
                      color: const Color.fromARGB(255, 51, 178, 213),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          SizedBox(
                              height: 50.0,
                              width: 160.0,
                              child: Center(
                                child: Text(
                                  'Vacuna laboratorio',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                              height: 50.0,
                              width: 160.0,
                              child: Center(
                                child: Text(
                                  'Veterinario responsable',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            height: 50.0,
                            width: 160.0,
                            child: Center(
                                child: Text(
                              vacuna.tipoVacuna,
                              textAlign: TextAlign.center,
                            ))),
                        SizedBox(
                            height: 50.0,
                            width: 160.0,
                            child: Center(
                              child: Text(
                                vacuna.veterinarioResp,
                                textAlign: TextAlign.center,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        //subtitle: Text('${horario}'),
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
              Icons.home,
              color: Colors.green,
            ),
            title: const Text('Inicio'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushNamed(context, 'bienvenida');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.list,
              color: Colors.green,
            ),
            title: const Text('Lista de adopciones'),
            onTap: () => Navigator.pushNamed(context, 'seguimientoPrincipal'),
          ),
          ListTile(
            leading: const Icon(
              Icons.manage_search_rounded,
              color: Colors.green,
            ),
            title: const Text('Seguimiento de mascota'),
            onTap: () => Navigator.pushNamed(context, 'seguimientoInfo',
                arguments: {
                  'datosper': datosA,
                  'formulario': formularios,
                  'animal': animal
                }),
          ),
          ListTile(
            leading: const Icon(
              Icons.vaccines,
              color: Colors.green,
            ),
            title: const Text('Vacunas'),
            onTap: () => Navigator.pushNamed(context, 'verRegistroVacunas',
                arguments: {
                  'datosper': datosA,
                  'formulario': formularios,
                  'animal': animal
                }),
          ),
          ListTile(
            leading: const Icon(Icons.medication_liquid_outlined,
                color: Colors.green),
            title: const Text('Desparasitaciones'),
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
            leading: const Icon(Icons.photo_sharp, color: Colors.green),
            title: const Text('Fotos'),
            onTap: () {
              Navigator.pushNamed(context, 'verEvidenciaP1', arguments: {
                'datosper': datosA,
                'formulario': formularios,
                'animal': animal
              });
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.picture_as_pdf_outlined, color: Colors.green),
            title: const Text('Documentos'),
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

  // Widget _menuWidget() {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         DrawerHeader(
  //           child: Container(
  //             decoration: const BoxDecoration(
  //               image: DecorationImage(
  //                 image: AssetImage('assets/pet-care.png'),
  //                 fit: BoxFit.fitHeight,
  //               ),
  //             ),
  //           ),
  //         ),
  //         ListTile(
  //           leading: const Icon(
  //             Icons.pages,
  //             color: Colors.green,
  //           ),
  //           title: const Text('Ir a Seguimiento Principal'),
  //           onTap: () => Navigator.pushNamed(context, 'seguimientoInfo',
  //               arguments: {
  //                 'datosper': datosA,
  //                 'formulario': formularios,
  //                 'animal': animal
  //               }),
  //         ),
  //         ListTile(
  //           leading: const Icon(
  //             Icons.check,
  //             color: Colors.green,
  //           ),
  //           title: const Text('Ver Registros Vacunas'),
  //           onTap: () => Navigator.pushNamed(context, 'verRegistroVacunas',
  //               arguments: {
  //                 'datosper': datosA,
  //                 'formulario': formularios,
  //                 'animal': animal
  //               }),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.check, color: Colors.green),
  //           title: const Text('Ver Registro Desparasitación'),
  //           onTap: () {
  //             //Navigator.pop(context);
  //             Navigator.pushNamed(context, 'verRegistroDesp', arguments: {
  //               'datosper': datosA,
  //               'formulario': formularios,
  //               'animal': animal
  //             });
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.check, color: Colors.green),
  //           title: const Text('Ver Fotos'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             Navigator.pushNamed(context, 'verEvidenciaP1', arguments: {
  //               'datosper': datosA,
  //               'formulario': formularios,
  //               'animal': animal
  //             });
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.check, color: Colors.green),
  //           title: const Text('Ver Archivos'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             Navigator.pushNamed(context, 'verEvidenciaP2', arguments: {
  //               'datosper': datosA,
  //               'formulario': formularios,
  //               'animal': animal
  //             });
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
