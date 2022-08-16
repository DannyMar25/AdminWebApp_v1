import 'package:admin_web_v1/models/donaciones_model.dart';
import 'package:admin_web_v1/providers/donaciones_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerDonacionesOutAddPage extends StatefulWidget {
  const VerDonacionesOutAddPage({Key? key}) : super(key: key);

  @override
  _VerDonacionesOutAddPageState createState() =>
      _VerDonacionesOutAddPageState();
}

class _VerDonacionesOutAddPageState extends State<VerDonacionesOutAddPage> {
  final donacionesProvider = DonacionesProvider();
  final userProvider = UsuarioProvider();
  DonacionesModel donaciones = DonacionesModel();
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higienicos', 'Otros'].toList();
  String? _selection;
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donaciones salientes registradas'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: const Icon(Icons.manage_accounts),
              itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Informacion"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Ayuda"),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("Cerrar Sesion"),
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
                //_mostrarTotal()
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
    final dropdownMenuOptions = _items.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
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
                // horarios.dia = s!;
              });
            }),
      ],
    );
  }

  Widget _verListado() {
    return FutureBuilder(
        future: donacionesProvider.verDonacionesOut(_selection.toString()),
        builder: (BuildContext context,
            AsyncSnapshot<List<DonacionesModel>> snapshot) {
          if (snapshot.hasData) {
            final donaciones = snapshot.data;
            return Column(
              children: [
                SizedBox(
                    height: 600,
                    child: ListView.builder(
                        itemCount: donaciones!.length,
                        itemBuilder: (context, i) =>
                            _crearItem(context, donaciones[i]))),
                // _mostrarTotal(context),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
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
                    Navigator.pushReplacementNamed(
                        context, 'verDonacionesOutAdd1',
                        arguments: donacion);
                  }),
              // _mostrarTotal(context),
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
                    Navigator.pushReplacementNamed(
                        context, 'verDonacionesOutAdd1',
                        arguments: donacion);
                  }),
              // _mostrarTotal(context),
            ]),
      );
    }

    //return _mostrarTotal(context);
  }

  Widget _mostrarTotal(BuildContext context) {
    return TextFormField(
      //initialValue: donacionesProvider.sumarDonaciones1().toString(),
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          labelText: 'Total:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
    );
  }
}
