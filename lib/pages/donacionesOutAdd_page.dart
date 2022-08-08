import 'package:admin_web_v1/models/donaciones_model.dart';
import 'package:admin_web_v1/providers/donaciones_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
//import 'package:aministrador_app_v1/src/utils/utils.dart' as utils;
import 'package:number_inc_dec/number_inc_dec.dart';

class IngresoDonacionesOutAddPage extends StatefulWidget {
  const IngresoDonacionesOutAddPage({Key? key}) : super(key: key);

  @override
  _IngresoDonacionesOutAddPageState createState() =>
      _IngresoDonacionesOutAddPageState();
}

class _IngresoDonacionesOutAddPageState
    extends State<IngresoDonacionesOutAddPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final donacionesProvider = DonacionesProvider();
  final userProvider = UsuarioProvider();
  DonacionesModel donaciones = DonacionesModel();
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higienicos', 'Otros'].toList();
  String? _selection;
  TextEditingController cantidadOut = TextEditingController();
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Object? donacData = ModalRoute.of(context)!.settings.arguments;
    if (donacData != null) {
      donaciones = donacData as DonacionesModel;
      // ignore: avoid_print
      print(donaciones.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anadir donacion saliente'),
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
      body: Stack(
        children: [
          //Background(),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        'Donaciones',
                        style: TextStyle(
                          fontSize: 33,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.blueGrey[300]!,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(),

                      const Divider(),
                      _crearTipoDonacion(),
                      const Divider(),
                      _crearUnidades(),
                      const Divider(),
                      _crearCantidadDonar(),
                      //_buildChild(),
                      const Divider(),
                      _crearDescripcion(),
                      const Divider(),
                      _crearBoton(),
                      // _crearCantidad(),
                    ],
                  )),
            ),
          ),
        ],
      ),
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
    return TextFormField(
      initialValue: donaciones.tipo,
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          labelText: 'Tipo de Donacion:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        s = donaciones.tipo;
        setState(() {
          donaciones.tipo = s;
        });
      },
    );
  }

  // Widget _buildChild() {
  //   if (_selection == 'Alimento') {
  //     return _crearPeso();
  //   } //else {
  //   //   if (_selection == 'Otros') {
  //   //     return _crearDonacion();
  //   //   }
  //   // }
  //   return Text('');
  // }

  // Widget _crearPeso() {
  //   //if (_selection == 'Alimento') {
  //   return TextFormField(
  //     initialValue: donaciones.peso.toString(),
  //     readOnly: true,
  //     textCapitalization: TextCapitalization.sentences,
  //     keyboardType: TextInputType.numberWithOptions(decimal: true),
  //     decoration: InputDecoration(
  //       labelText: 'Peso (Kg.):',
  //       labelStyle: TextStyle(fontSize: 16, color: Colors.black),
  //     ),
  //     onChanged: (s) {
  //       setState(() {
  //         donaciones.peso = double.parse(s);
  //       });
  //     },
  //   );
  //   //}
  // }

  Widget _crearDescripcion() {
    return TextFormField(
      initialValue: donaciones.descripcion,
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          labelText: 'Descripcion:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        setState(() {
          donaciones.descripcion = s;
        });
      },
    );
  }

  Widget _crearUnidades() {
    return TextFormField(
      initialValue: donaciones.cantidad.toString(),
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
          labelText: 'Cantidad:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        setState(() {
          //donaciones.cantidad = int.parse(s);
        });
      },
    );
  }

  Widget _crearCantidadDonar() {
    return NumberInputPrefabbed.squaredButtons(
      controller: cantidadOut,
      min: 1,
      max: donaciones.cantidad,
      //onChanged: ,
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.green;
        }),
      ),
      label: const Text('Guardar'),
      icon: const Icon(Icons.save),
      autofocus: true,
      //onPressed: (_guardando) ? null : _submit,
      onPressed: () {
        _submit();
      },
    );
  }

  void _submit() async {
    print(int.tryParse(cantidadOut.text));
    int? cantidadAdd = int.tryParse(cantidadOut.text);
    //   if (donaciones.id == "") {
    //     donaciones.estadoDonacion = 'Saliente';
    //     donacionesProvider.crearDonacion(donaciones);
    //   } else {
    //     donaciones.estadoDonacion = 'Saliente';
    //     donacionesProvider.editarDonacion(donaciones);
    //   }
    //   //mostrarSnackbar('Registro guardado');
    //   Navigator.pushNamed(context, 'verDonacionesInAdd');
    // }

    if (donaciones.cantidad == 1) {
      donaciones.estadoDonacion = 'Saliente';
      donaciones.cantidad = cantidadAdd!;
      donacionesProvider.crearDonacion(donaciones);
      donacionesProvider.borrarDonacion(donaciones.id);
      Navigator.pushNamed(context, 'verDonacionesOutAdd');
    }
    if (donaciones.cantidad == int.tryParse(cantidadOut.text)) {
      donaciones.estadoDonacion = 'Saliente';
      donaciones.cantidad = int.tryParse(cantidadOut.text)!;
      donacionesProvider.crearDonacion(donaciones);
      donacionesProvider.borrarDonacion(donaciones.id);
      Navigator.pushNamed(context, 'verDonacionesOutAdd');
    } else {
      int cantidadAdd1 = donaciones.cantidad - int.tryParse(cantidadOut.text)!;
      donaciones.estadoDonacion = 'Saliente';
      donaciones.cantidad = int.tryParse(cantidadOut.text)!;
      donacionesProvider.editarCantidad(donaciones, cantidadAdd1);
      donacionesProvider.crearDonacion(donaciones);
      Navigator.pushNamed(context, 'verDonacionesOutAdd');

      //donacionesProvider.eliminar(donaciones.id);
    }
  }
}
