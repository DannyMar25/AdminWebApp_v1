import 'package:admin_web_v1/models/donaciones_model.dart';
import 'package:admin_web_v1/providers/donaciones_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerDonacionesInAddPage extends StatefulWidget {
  const VerDonacionesInAddPage({Key? key}) : super(key: key);

  @override
  _VerDonacionesInAddPageState createState() => _VerDonacionesInAddPageState();
}

class _VerDonacionesInAddPageState extends State<VerDonacionesInAddPage> {
  List<DonacionesModel> donacionA = [];
  List<Future<DonacionesModel>> listaD = [];
  final donacionesProvider = new DonacionesProvider();
  final userProvider = new UsuarioProvider();
  DonacionesModel donaciones = new DonacionesModel();
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higienicos', 'Otros'].toList();
  String? _selection;
  int total1 = 0;
  int totalA = 0;
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donaciones registradas'),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            child: Column(
              children: [
                _crearTipoDonacion(),
                const Divider(),
                _verListado(),
                const Divider(),
                // _mostrarTotal()
              ],
            ),
          ),
        ),
      ),
      drawer: const MenuWidget(),
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

  Widget _crearTipoDonacion() {
    final dropdownMenuOptions = _items
        .map((String item) =>
            //new DropdownMenuItem<String>(value: item, child: new Text(item)))
            new DropdownMenuItem<String>(value: item, child: new Text(item)))
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Seleccione el tipo de donacion:  ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        DropdownButton<String>(
            hint: Text(donaciones.tipo.toString()),
            value: _selection,
            items: dropdownMenuOptions,
            onChanged: (s) {
              setState(() {
                _selection = s;
                showCitas();
                // horarios.dia = s!;
              });
            }),
      ],
    );
  }

  // Widget _verListado() {
  //   return FutureBuilder(
  //       future: donacionesProvider.verDonaciones1(_selection.toString()),
  //       builder: (BuildContext context,
  //           AsyncSnapshot<List<DonacionesModel>> snapshot) {
  //         if (snapshot.hasData) {
  //           final donaciones = snapshot.data;
  //           return Column(
  //             children: [
  //               SizedBox(
  //                   height: 300,
  //                   child: ListView.builder(
  //                       itemCount: donaciones!.length,
  //                       itemBuilder: (context, i) =>
  //                           _crearItem(context, donaciones[i]))),
  //               _mostrarTotal(context),
  //             ],
  //           );
  //         } else {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //       });
  // }

  // Widget _crearItem(BuildContext context, DonacionesModel donacion) {
  //   //_mostrarTotal(context);
  //   return Column(key: UniqueKey(),
  //       // background: Container(
  //       //   color: Colors.red,
  //       // ),
  //       children: [
  //         ListTile(
  //             title: Text('${donacion.tipo} - ${donacion.cantidad}'),
  //             subtitle: Text('${donacion.descripcion}'),
  //             onTap: () {
  //               Navigator.pushNamed(context, 'donacionesInAdd',
  //                   arguments: donacion);
  //             }),
  //         // _mostrarTotal(context),
  //       ]);
  //   //return _mostrarTotal(context);
  // }

  showCitas() async {
    donacionA.clear();
    total1 = 0;
    listaD =
        await donacionesProvider.cargarDonacionesIn11(_selection.toString());
    for (var yy in listaD) {
      DonacionesModel don = await yy;

      setState(() {
        donacionA.add(don);
        total1 += don.cantidad;
      });
    }
    print(total1.toString());
  }

  Widget _verListado() {
    return Column(
      children: [
        SizedBox(
            height: 600,
            child: ListView.builder(
                itemCount: donacionA.length,
                itemBuilder: (context, i) =>
                    _crearItem(context, donacionA[i]))),
        //_mostrarTotal(),
      ],
    );
  }

  Widget _crearItem(BuildContext context, DonacionesModel donacion) {
    //_mostrarTotal(context);
    if (donacion.tipo == 'Alimento') {
      return Card(
        color: Colors.lightGreen[200],
        shadowColor: Colors.green,
        child: Column(key: UniqueKey(),
            // background: Container(
            //   color: Colors.red,
            // ),
            children: [
              ListTile(
                  title: Text(
                    '${donacion.tipo}  ${'- Cantidad:'} ${donacion.cantidad}',
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Column(
                    children: [
                      Text(
                          '${donacion.descripcion} ${'- Peso:'}  ${donacion.peso} ${'Kg'}'),
                      Text('${'Fecha de ingreso: '} ${donacion.fechaIngreso}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'verDonacionesIn1',
                        arguments: donacion);
                  }),
            ]),
      );
    } else {
      return Card(
        color: Colors.lightGreen[200],
        shadowColor: Colors.green,
        child: Column(key: UniqueKey(),
            // background: Container(
            //   color: Colors.red,
            // ),
            children: [
              ListTile(
                  title: Text(
                    '${donacion.tipo}  ${'- Cantidad:'} ${donacion.cantidad}',
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Column(
                    children: [
                      Text(donacion.descripcion),
                      Text('${'Fecha de ingreso: '} ${donacion.fechaIngreso}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'verDonacionesIn1',
                        arguments: donacion);
                  }),
            ]),
      );
    }

    //return _mostrarTotal(context);
  }

  // Widget _mostrarTotal(BuildContext context) {
  //   //int total = donacionesProvider.sumarDonaciones1();
  //   return TextFormField(
  //     // initialValue: donacionesProvider.sumarDonaciones1().toString(),
  //     readOnly: true,
  //     textCapitalization: TextCapitalization.sentences,
  //     decoration: InputDecoration(
  //         labelText: 'Total:',
  //         labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
  //   );
  // }
  Widget _mostrarTotal() {
    return TextFormField(
      initialValue: totalA.toString(),
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          labelText: 'Total:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
    );
  }
}