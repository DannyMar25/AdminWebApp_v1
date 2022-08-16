import 'package:admin_web_v1/models/horarios_model.dart';
import 'package:admin_web_v1/providers/horarios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class HorariosAgregados extends StatefulWidget {
  const HorariosAgregados({Key? key}) : super(key: key);

  @override
  _HorariosAgregadosState createState() => _HorariosAgregadosState();
}

class _HorariosAgregadosState extends State<HorariosAgregados> {
  final horariosProvider = HorariosProvider();
  final userProvider = UsuarioProvider();
  final List<String> _items = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo'
  ].toList();
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
        title: const Text('Horarios Registrados'),
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
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            child: Column(
              children: [
                _crearDia(),
                const Divider(),
                _verListado(),
                //const Divider(),
              ],
            ),
          ),
        ),
      ),
      drawer: const MenuWidget(),
    );
  }

  Widget _crearDia() {
    final dropdownMenuOptions = _items.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Seleccione el dia:         ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        DropdownButton<String>(
            //hint: Text(horarios.dia.toString()),
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

  Widget _verListado() {
    return FutureBuilder(
        future: horariosProvider.cargarHorariosDia(_selection.toString()),
        builder: (BuildContext context,
            AsyncSnapshot<List<HorariosModel>> snapshot) {
          if (snapshot.hasData) {
            final horarios = snapshot.data;
            return SizedBox(
                height: 600,
                child: ListView.builder(
                  itemCount: horarios!.length,
                  itemBuilder: (context, i) => _crearItem(context, horarios[i]),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, HorariosModel horario) {
    return _buildChild(horario, context);
  }

  Widget _buildChild(HorariosModel horario, BuildContext context) {
    if (horario.disponible == "Disponible") {
      return Card(
        color: Colors.lightGreen[200],
        shadowColor: Colors.green,
        child: Column(key: UniqueKey(), children: [
          ListTile(
            title: Text('${horario.dia} - ${horario.hora}'),
            subtitle: Text(
              horario.disponible,
              style: const TextStyle(color: Colors.black),
            ),
            onTap: () =>
                Navigator.pushNamed(context, 'citasAdd', arguments: horario),
          )
        ]),
      );
    } else {
      return Card(
        color: Colors.orangeAccent[200],
        shadowColor: Colors.green,
        child: Column(key: UniqueKey(), children: [
          ListTile(
            title: Text('${horario.dia} - ${horario.hora}'),
            subtitle: Text(
              horario.disponible,
              style: const TextStyle(color: Colors.black),
            ),
            onTap: () =>
                Navigator.pushNamed(context, 'citasAdd', arguments: horario),
          )
        ]),
      );
    }
  }
}
