import 'package:admin_web_v1/models/donaciones_model.dart';
import 'package:admin_web_v1/providers/donaciones_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class IngresoDonacionesOutPage extends StatefulWidget {
  const IngresoDonacionesOutPage({Key? key}) : super(key: key);

  @override
  _IngresoDonacionesOutPageState createState() =>
      _IngresoDonacionesOutPageState();
}

class _IngresoDonacionesOutPageState extends State<IngresoDonacionesOutPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final donacionesProvider = DonacionesProvider();
  final userProvider = UsuarioProvider();
  DonacionesModel donaciones = DonacionesModel();
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higiénicos', 'Otros'].toList();
  String? _selection = "Alimento";
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
      //print(donaciones.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recursos disponibles para donación'),
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
            child: Center(
              child: Container(
                width: 850,
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          'Registros',
                          style: TextStyle(
                            fontSize: 30,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.blueGrey[300]!,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        _crearTipoDonacion(),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        _verListado(),
                        const Divider(
                          color: Colors.transparent,
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _crearTipoDonacion() {
    final dropdownMenuOptions = _items.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Seleccione el tipo de donación:  ',
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
            '${'Cantidad:'} ${donacion.cantidad} ${'- Peso:'}  ${donacion.peso} ${'Kg'}',
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
    } else {
      return Card(
        color: Colors.lightGreen[200],
        shadowColor: Colors.green,
        child: ListTile(
          title: Text(
            '${'Cantidad:'} ${donacion.cantidad}',
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
