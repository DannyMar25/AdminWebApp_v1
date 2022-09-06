import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

//import 'package:formvalidation/src/bloc/provider.dart';

class GaleriaMascotasPage extends StatefulWidget {
  const GaleriaMascotasPage({Key? key}) : super(key: key);

  @override
  State<GaleriaMascotasPage> createState() => _GaleriaMascotasPageState();
}

class _GaleriaMascotasPageState extends State<GaleriaMascotasPage> {
  //const HomePage({Key? key}) : super(key: key);
  final userProvider = UsuarioProvider();

  final animalesProvider = AnimalesProvider();

  bool busqueda = false;

  final _textController = TextEditingController();

  String? nombre;

  String? nombreBusqueda;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    //backgroundColor: Colors.green,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);
    return RefreshIndicator(
      displacement: 250,
      backgroundColor: Colors.green,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 1500));
        setState(() {
          _buildChildBusqueda(context);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mascotas registradas'),
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
        body: Column(
          children: [
            const Padding(padding: EdgeInsets.only(bottom: 10.0)),
            _busqueda(),
            const Padding(padding: EdgeInsets.only(bottom: 10.0)),
            _botonBusqueda(context),
            const Padding(padding: EdgeInsets.only(bottom: 10.0)),
            //Expanded(child: _crearListado())
            Expanded(child: _buildChildBusqueda(context))
            //_crearListado(),
          ],
        ),
        floatingActionButton: _crearBoton(context),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Mascotas registradas'),
    //     backgroundColor: Colors.green,
    //     actions: [
    //       PopupMenuButton<int>(
    //           onSelected: (item) => onSelected(context, item),
    //           icon: const Icon(Icons.manage_accounts),
    //           itemBuilder: (context) => [
    //                 const PopupMenuItem<int>(
    //                   value: 0,
    //                   child: Text("Soporte"),
    //                 ),
    //                 const PopupMenuItem<int>(
    //                   value: 1,
    //                   child: Text("Cerrar Sesión"),
    //                 )
    //               ]),
    //     ],
    //   ),
    //   drawer: const MenuWidget(),
    //   body: Column(
    //     children: [
    //       const Padding(padding: EdgeInsets.only(bottom: 10.0)),
    //       _busqueda(),
    //       const Padding(padding: EdgeInsets.only(bottom: 10.0)),
    //       _botonBusqueda(context),
    //       const Padding(padding: EdgeInsets.only(bottom: 10.0)),
    //       //Expanded(child: _crearListado())
    //       Expanded(child: _buildChildBusqueda(context))
    //       //_crearListado(),
    //     ],
    //   ),
    //   floatingActionButton: _crearBoton(context),
    // );
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

  Widget _busqueda() {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (s) {
        setState(() {
          nombre = s;
          nombreBusqueda = nombre![0].toUpperCase() + s.substring(1);
          busqueda = true;
          //print(nombreBusqueda);
        });
      },
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: _onClearTapped,
          child: const Icon(Icons.clear),
        ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10))),
        hintText: 'Ingresa el nombre de la mascota',
      ),
    );
  }

  void _onClearTapped() {
    setState(() {
      _textController.text = '';
      busqueda = false;
    });
  }

  Widget _crearListadoBusqueda() {
    return FutureBuilder(
        future: animalesProvider.cargarAnimalBusqueda(nombreBusqueda!),
        builder:
            (BuildContext context, AsyncSnapshot<List<AnimalModel>> snapshot) {
          if (snapshot.hasData) {
            final animales = snapshot.data;
            return GridView.count(
              childAspectRatio: 50 / 100,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(animales!.length, (index) {
                return _crearItem(context, animales[index]);
              }),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildChildBusqueda(BuildContext context) {
    if (busqueda == false) {
      return _crearListado();
    } else {
      return _crearListadoBusqueda();
    }
  }

  Widget _crearListado() {
    return FutureBuilder(
        future: animalesProvider.cargarAnimal1(),
        builder:
            (BuildContext context, AsyncSnapshot<List<AnimalModel>> snapshot) {
          if (snapshot.hasData) {
            final animales = snapshot.data;
            return GridView.count(
              childAspectRatio: 60 / 100,
              shrinkWrap: true,
              crossAxisCount: 5,
              children: List.generate(animales!.length, (index) {
                return _crearItem(context, animales[index]);
              }),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, AnimalModel animal) {
    return Card(
        margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 90.0),
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, 'animal', arguments: animal),
          child: Column(
            //estaba con Column
            children: [
              (animal.fotoUrl == "")
                  ? const Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(animal.fotoUrl),
                      placeholder: const AssetImage('assets/cat_1.gif'),
                      height: 250.0, //350
                      //width: 250.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              _buildChild(animal, context)
            ],
          ),
        ));
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: () => Navigator.pushNamed(context, 'animal'),
      child: const Icon(Icons.add),
    );
  }

  Widget _botonBusqueda(BuildContext context) {
    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        //cardB.currentState?.collapse();
        Navigator.pushNamed(context, 'busqueda');
      },
      child: Column(
        children: const <Widget>[
          Icon(
            Icons.search,
            color: Colors.green,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
          ),
          Text(
            'Busqueda personalizada',
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildChild(AnimalModel animal, BuildContext context) {
    if (animal.estado == 'En Adopción') {
      return ListTile(
        title: Text(
          '${animal.nombre} - ${animal.etapaVida}',
          textAlign: TextAlign.center,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Color: ${animal.color}',
              textAlign: TextAlign.start,
            ),
            Text(
              'Tamaño: ${animal.tamanio}',
            ),
            SizedBox(
              width: 200,
              height: 35,
              child: Card(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    animal.estado,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
            )
          ],
        ),
        onTap: () => Navigator.pushNamed(context, 'animal', arguments: animal),
      );
    } else if (animal.estado == 'Adoptado') {
      return ListTile(
        title: Text(
          '${animal.nombre} - ${animal.etapaVida}',
          textAlign: TextAlign.center,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Color: ${animal.color}',
              textAlign: TextAlign.start,
            ),
            Text(
              'Tamaño: ${animal.tamanio}',
            ),
            SizedBox(
              width: 200,
              height: 35,
              child: Card(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    animal.estado,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
            )
          ],
        ),
        onTap: () => Navigator.pushNamed(context, 'animal', arguments: animal),
      );
    } else {
      return ListTile(
        title: Text(
          '${animal.nombre} - ${animal.etapaVida}',
          textAlign: TextAlign.center,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Color: ${animal.color}',
              textAlign: TextAlign.start,
            ),
            Text(
              'Tamaño: ${animal.tamanio}',
            ),
            SizedBox(
              width: 200,
              height: 35,
              child: Card(
                color: Colors.orange,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    animal.estado,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
            )
          ],
        ),
        onTap: () => Navigator.pushNamed(context, 'animal', arguments: animal),
      );
    }
  }
}
