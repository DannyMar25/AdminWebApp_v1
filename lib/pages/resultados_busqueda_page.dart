import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/preferencias_usuario/preferencias_usuario.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

//import 'package:formvalidation/src/bloc/provider.dart';

class ResultadosBusquedaPage extends StatefulWidget {
  const ResultadosBusquedaPage({Key? key}) : super(key: key);

  //const HomePage({Key? key}) : super(key: key);
  @override
  _ResultadosBusquedaPageState createState() => _ResultadosBusquedaPageState();
}

class _ResultadosBusquedaPageState extends State<ResultadosBusquedaPage> {
  final animalesProvider = AnimalesProvider();
  AnimalModel animal = AnimalModel();
  final userProvider = UsuarioProvider();
  final prefs = PreferenciasUsuario();

  final formKey = GlobalKey<FormState>();
  String? especie;
  String? sexo;
  String? etapaVida;
  String? tamanio;
  String? estado;
  List<AnimalModel> citasA = [];
  List<Future<AnimalModel>> listaC = [];
  bool busqueda = false;
  //final _textController = TextEditingController();
  String? nombre;
  String? nombreBusqueda;
  @override
  // void initState() {
  //   super.initState();
  //   showCitas();
  // }

  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);
    //showCitas();
    final email = prefs.email;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    //if (dat == arg['datosper']) {
    especie = arg['especie'];
    //print(formularios.idDatosPersonales);
    sexo = arg['sexo'];
    etapaVida = arg['etapaVida'];
    tamanio = arg['tamanio'];
    estado = arg['estado'];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Resultados de búsqueda'),
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
        drawer: const MenuWidget(),
        body: Column(
          children: [
            const Padding(padding: EdgeInsets.only(bottom: 10.0)),
            _botonBusqueda(),
            const Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Expanded(child: _crearListadoBusqueda()),
            //child: buildChild(),

            //_crearListado(),
          ],
        )

        //floatingActionButton: _crearBoton(context),
        );
  }

  Widget buildChild() {
    if (tamanio == null) {
      return _crearListadoBusqueda4();
    } else {
      return _crearListadoBusqueda();
    }
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

  Widget _crearListadoBusqueda() {
    return FutureBuilder(
        future: animalesProvider.cargarBusqueda(
          especie,
          sexo,
          etapaVida,
          tamanio,
          estado,
        ),
        builder:
            (BuildContext context, AsyncSnapshot<List<AnimalModel>> snapshot) {
          if (snapshot.hasData) {
            final animales = snapshot.data;
            if (animales!.length == 0) {
              return Column(children: [
                AlertDialog(
                  title: Row(
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 45,
                      ),
                      Text('Resultado de búsqueda'),
                    ],
                  ),
                  content: const Text(
                      'No se ha encotrado ninguna mascota con las caracteristicas que buscabas.'),
                  actions: [
                    TextButton(
                        child: const Text('Ok'),
                        //onPressed: () => Navigator.of(context).pop(),
                        onPressed: () {
                          Navigator.pushNamed(context, 'home');
                        })
                  ],
                ),
              ]);
            }
            return GridView.count(
              childAspectRatio: 6 / 7,
              shrinkWrap: true,
              crossAxisCount: 5,
              children: List.generate(animales.length, (index) {
                return _crearItem1(context, animales[index]);
              }),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearListadoBusqueda4() {
    return FutureBuilder(
        future: animalesProvider.cargarBusqueda4(
          especie!,
          sexo!,
          etapaVida!,
          estado!,
        ),
        builder:
            (BuildContext context, AsyncSnapshot<List<AnimalModel>> snapshot) {
          if (snapshot.hasData) {
            final animales = snapshot.data;
            if (animales!.length == 0) {
              return Column(children: [
                AlertDialog(
                  title: Row(
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 45,
                      ),
                      Text('Resultado de búsqueda'),
                    ],
                  ),
                  content: const Text(
                      'No se ha encotrado ninguna mascota con las caracteristicas que buscabas.'),
                  actions: [
                    TextButton(
                        child: const Text('Ok'),
                        //onPressed: () => Navigator.of(context).pop(),
                        onPressed: () {
                          Navigator.pushNamed(context, 'home');
                        })
                  ],
                )
              ]);
            }
            return GridView.count(
              childAspectRatio: 6 / 7,
              shrinkWrap: true,
              crossAxisCount: 5,
              children: List.generate(animales.length, (index) {
                return _crearItem1(context, animales[index]);
              }),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem1(BuildContext context, AnimalModel animal) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Color.fromARGB(248, 244, 246, 243),
      elevation: 4.0,
      //margin: const EdgeInsets.only(bottom: 90.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, 'animal', arguments: animal),
        child: Column(
          children: [
            (animal.fotoUrl == "")
                ? const Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                    image: NetworkImage(animal.fotoUrl),
                    placeholder: const AssetImage('assets/cat_1.gif'),
                    height: MediaQuery.of(context).size.height * 0.33,

                    //height: 350.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

            //Padding(padding: EdgeInsets.only(bottom: 5.0)),
            ListTile(
              title: Text(animal.nombre,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text('${animal.etapaVida} - ${animal.sexo}'),
              // onTap: () =>
              //     Navigator.pushNamed(context, 'animal', arguments: animal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonBusqueda() {
    return TextButton(
      onPressed: () {
        //cardB.currentState?.collapse();
        Navigator.pushNamed(context, 'home');
      },
      child: Column(
        children: const <Widget>[
          Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
          ),
          Text(
            'Volver a la Galería',
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }
}
