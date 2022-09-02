import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/evidencia_model.dart';
import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/models/registro_desparacitaciones_model.dart';
import 'package:admin_web_v1/providers/formularios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:flutter/material.dart';

class VerEvidenciaFotosPage extends StatefulWidget {
  const VerEvidenciaFotosPage({Key? key}) : super(key: key);

  @override
  State<VerEvidenciaFotosPage> createState() => _VerEvidenciaFotosPageState();
}

class _VerEvidenciaFotosPageState extends State<VerEvidenciaFotosPage> {
  final formKey = GlobalKey<FormState>();
  FormulariosProvider formulariosProvider = FormulariosProvider();
  AnimalModel animal = AnimalModel();
  FormulariosModel formularios = FormulariosModel();
  DatosPersonalesModel datosA = DatosPersonalesModel();
  EvidenciasModel evidenciaF = EvidenciasModel();

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
        backgroundColor: const Color.fromARGB(255, 239, 243, 243),
        appBar: AppBar(
          title: const Text('Evidencias'),
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
                              'Fotos enviadas como evidencia',
                              style: TextStyle(
                                fontSize: 28,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 3
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
        future: formulariosProvider.cargarEvidenciaF(formularios.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<EvidenciasModel>> snapshot) {
          if (snapshot.hasData) {
            final evidF = snapshot.data;
            return Column(
              children: [
                SizedBox(
                  height: 660,
                  child: ListView.builder(
                    itemCount: evidF!.length,
                    itemBuilder: (context, i) => _crearItem(context, evidF[i]),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, EvidenciasModel evidencia) {
    return Card(
      shadowColor: Colors.green,
      child: ListTile(
          title: Column(children: [
            (evidencia.fotoUrl == "")
                ? const Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                    image: NetworkImage(evidencia.fotoUrl),
                    placeholder: const AssetImage('assets/jar-loading.gif'),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text(evidencia.fecha),
            ),
          ]),
          onTap: () async {
            Navigator.pushNamed(context, 'verFotoEvidencia',
                arguments: evidencia);
          }),
      //margin: EdgeInsets.all(20.0)
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
