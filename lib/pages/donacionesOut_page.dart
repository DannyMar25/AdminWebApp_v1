import 'package:admin_web_v1/models/donaciones_model.dart';
import 'package:admin_web_v1/providers/donaciones_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class IngresoDonacionesOutPage extends StatefulWidget {
  IngresoDonacionesOutPage({Key? key}) : super(key: key);

  @override
  _IngresoDonacionesOutPageState createState() =>
      _IngresoDonacionesOutPageState();
}

class _IngresoDonacionesOutPageState extends State<IngresoDonacionesOutPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final donacionesProvider = new DonacionesProvider();
  final userProvider = new UsuarioProvider();
  DonacionesModel donaciones = new DonacionesModel();
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
    final Object? donacData = ModalRoute.of(context)!.settings.arguments;
    if (donacData != null) {
      donaciones = donacData as DonacionesModel;
      print(donaciones.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de donaciones salientes'),
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
                        'Donaciones Out',
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
                      _crearTipoDonacion(),
                      const Divider(),
                      _verListado(),
                      const Divider(),
                      //_crearDescripcion(),
                      // Divider(),
                      //_crearBoton(),
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

              //donaciones.tipo = s!;
              //animal.tamanio = s!;
            });
          },
        ),
      ],
    );
  }

  Widget _crearDescripcion() {
    return TextFormField(
      initialValue: donaciones.descripcion,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          labelText: 'Descripcion:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        setState(() {
          donaciones.descripcion = s;
        });
      },
      // onSaved: (value) => donaciones.descripcion = value!,
      // validator: (value) {
      //   if (value!.length < 3) {
      //     return 'Ingrese la descripcion';
      //   } else {
      //     return null;
      //   }
      // },
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.deepPurple;
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
    if (donaciones.id == "") {
      donacionesProvider.crearDonacion(donaciones);
    } else {
      donacionesProvider.editarDonacion(donaciones);
    }
    //mostrarSnackbar('Registro guardado');
    //Navigator.pushNamed(context, 'verDonacionesOutAdd');
  }

  Widget _verListado() {
    return FutureBuilder(
        future: donacionesProvider.cargarDonaciones(_selection.toString()),
        builder: (BuildContext context,
            AsyncSnapshot<List<DonacionesModel>> snapshot) {
          if (snapshot.hasData) {
            final donaciones = snapshot.data;
            return SizedBox(
                height: 600,
                child: ListView.builder(
                  itemCount: donaciones!.length,
                  itemBuilder: (context, i) =>
                      _crearItem(context, donaciones[i]),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, DonacionesModel donacion) {
    if (donacion.tipo == 'Alimento') {
      return Card(
        color: Colors.lightGreen[200],
        shadowColor: Colors.green,
        child: ListTile(
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
          onTap: () => Navigator.pushNamed(context, 'DonacionesOutAdd1',
              arguments: donacion),
        ),
      );
    } else {
      return Card(
        color: Colors.lightGreen[200],
        shadowColor: Colors.green,
        child: ListTile(
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
          onTap: () => Navigator.pushNamed(context, 'DonacionesOutAdd1',
              arguments: donacion),
        ),
      );
    }
  }
}