import 'package:admin_web_v1/models/horarios_model.dart';
import 'package:admin_web_v1/providers/horarios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class HorariosPage extends StatefulWidget {
  const HorariosPage({Key? key}) : super(key: key);

  @override
  _HorariosPageState createState() => _HorariosPageState();
}

class _HorariosPageState extends State<HorariosPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final horariosProvider = HorariosProvider();
  final userProvider = UsuarioProvider();
  HorariosModel horarios = HorariosModel();
  bool _disponible = false;
  //lista dias
  final List<String> _items = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo'
  ].toList();
  final List<String> _items1 = [
    '08:00 - 08:30',
    '08:30 - 09:00',
    '09:00 - 09:30',
    '09:30 - 10:00',
    '10:00 - 10:30',
    '10:30 - 11:00',
    '11:00 - 11:30',
    '11:30 - 12:00',
    '12:00 - 12:30',
    '12:30 - 13:00',
    '14:00 - 14:30',
    '14:30 - 15:00',
    '15:00 - 15:30',
    '15:30 - 16:00',
    '16:00 - 16:30',
    '16:30 - 17:00',
  ].toList();
  String? _selection;
  String? _selection1;
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  //bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    final Object? horarioData = ModalRoute.of(context)!.settings.arguments;
    if (horarioData != null) {
      horarios = horarioData as HorariosModel;
      //print(horarios.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Horario de visita"),
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
      body: Center(
        child: Container(
          width: 850,
          padding: const EdgeInsets.all(15.0),
          child: Form(
            child: Column(
              children: [
                _crearDia(),
                const Divider(),
                _crearHoraDia(),
                const Divider(),
                _crearDisponible(),
                const Divider(),
                // _buildChild(),
                // Divider(),
                _crearBoton(),
                // Divider(),
              ],
            ),
          ),
        ),
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

  Widget _crearDia() {
    final dropdownMenuOptions = _items.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Dia:         ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        DropdownButton<String>(
          hint: Text(horarios.dia.toString()),
          value: _selection,
          items: dropdownMenuOptions,
          onChanged: null,
          // (s) {
          //   setState(() {
          //     _selection = s;
          //     horarios.dia = s!;
          //   });
          // }
        ),
      ],
    );
  }

  Widget _crearHoraDia() {
    final dropdownMenuOptions = _items1.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Hora:         ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        DropdownButton<String>(
          hint: Text(horarios.hora.toString()),
          value: _selection1,
          items: dropdownMenuOptions,
          onChanged: null,
        ),
      ],
    );
  }

  Widget _crearDisponible() {
    if (horarios.disponible == 'No disponible') {
      _disponible = false;
    }
    if (horarios.disponible == 'Disponible') {
      _disponible = true;
    }
    return SwitchListTile(
      value: _disponible,
      title: const Text('Horario disponible:'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: Colors.grey)),
      activeColor: Colors.green,
      onChanged: (bool value) => setState(() {
        _disponible = value;
        if (value == false) {
          horarios.disponible = "No disponible";
        } else {
          horarios.disponible = "Disponible";
        }
      }),
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
    if (horarios.id == "") {
      horariosProvider.crearHorario(horarios);
      mostrarAlertaOk(context, 'Registro guardado con éxito.', 'horariosAdd');
    } else {
      horariosProvider.editarHorarios(horarios);
      mostrarAlertaOk(
          context, 'Registro actualizado con éxito.', 'horariosAdd');
    }
    //mostrarSnackbar('Registro guardado');
    //Navigator.pushNamed(context, 'horariosAdd');
  }
}
