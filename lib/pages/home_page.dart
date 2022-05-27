import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

//import 'package:formvalidation/src/bloc/provider.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key? key}) : super(key: key);
  final userProvider = UsuarioProvider();
  final animalesProvider = new AnimalesProvider();
  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mascotas Registradas'),
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
          // Builder(builder: (BuildContext context) {
          //   return TextButton(
          //     style: ButtonStyle(
          //       foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //     ),
          //     onPressed: () async {
          //       userProvider.signOut();
          //       Navigator.pushNamed(context, 'login');
          //     },
          //     child: Text('Sign Out'),
          //   );
          // }),
        ],
      ),
      drawer: const MenuWidget(),
      body:
          // GridView.count(
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 15.0,
          //     mainAxisSpacing: 15.0,
          //     children: [_crearListado()]),

          _crearListado(),
      floatingActionButton: _crearBoton(context),
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

  Widget _crearListado() {
    return FutureBuilder(
        future: animalesProvider.cargarAnimal1(),
        builder:
            (BuildContext context, AsyncSnapshot<List<AnimalModel>> snapshot) {
          if (snapshot.hasData) {
            final animales = snapshot.data;
            return ListView.builder(
              itemCount: animales!.length,
              itemBuilder: (context, i) => _crearItem(context, animales[i]),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, AnimalModel animal) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion) {
        mostrarAlertaBorrar(context, 'hola');
        animalesProvider.borrarAnimal(animal.id!);
      },
      child: Card(
        child: Column(
          //estaba con Column
          children: [
            (animal.fotoUrl == "")
                ? const Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                    image: NetworkImage(animal.fotoUrl),
                    placeholder: const AssetImage('assets/jar-loading.gif'),
                    height: 300.0,
                    width: 300.0,
                    //width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${animal.nombre} - ${animal.edad}'),
              subtitle:
                  Text('Color: ${animal.color} - Tamaño: ${animal.tamanio}'),
              onTap: () =>
                  Navigator.pushNamed(context, 'animal', arguments: animal),
            ),
          ],
        ),
      ),
      // child: ListTile(
      //   title: Text('${animal.nombre} - ${animal.edad} meses'),
      //   subtitle: Text('${animal.color} - ${animal.id}'),
      //   onTap: () => Navigator.pushNamed(context, 'animal', arguments: animal),
      // ),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      backgroundColor: Colors.green,
      onPressed: () => Navigator.pushNamed(context, 'animal'),
    );
  }
}
