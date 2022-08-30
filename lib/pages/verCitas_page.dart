import 'package:admin_web_v1/models/citas_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/citas_provider.dart';
import 'package:admin_web_v1/providers/horarios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerCitasPage extends StatefulWidget {
  const VerCitasPage({Key? key}) : super(key: key);

  @override
  _VerCitasPageState createState() => _VerCitasPageState();
}

class _VerCitasPageState extends State<VerCitasPage> {
  final TextEditingController _inputFieldDateController =
      TextEditingController();
  List<CitasModel> citasA = [];
  List<Future<CitasModel>> listaC = [];
  final formKey = GlobalKey<FormState>();
  final citasProvider = CitasProvider();
  final horariosProvider = HorariosProvider();
  final animalesProvider = AnimalesProvider();
  final userProvider = UsuarioProvider();
  String _fecha = '';
  //TextEditingController _inputFieldDateController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    //showCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas pendientes'),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _crearFecha(context),
                const Divider(),
                _verListado(),
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

  showCitas() async {
    citasA.clear();
    listaC =
        await citasProvider.cargarCitasFecha(_inputFieldDateController.text);
    for (var yy in listaC) {
      CitasModel cit = await yy;
      setState(() {
        citasA.add(cit);
      });
    }
  }

  Widget _verListado() {
    return Column(
      children: [
        SizedBox(
          height: 800,
          child: ListView.builder(
            itemCount: citasA.length,
            itemBuilder: (context, i) => _crearItem(context, citasA[i]),
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, CitasModel cita) {
    String fecha = cita.horario!.dia;
    // DateTime fecha1 = DateTime.parse(fecha);
    // String fecha2 = fecha1.year.toString() +
    //     "-" +
    //     fecha1.month.toString() +
    //     "-" +
    //     fecha1.day.toString();
    String hora = cita.horario!.hora;
    return Card(
      color: Colors.lightGreen[200],
      shadowColor: Colors.green,
      child: Column(key: UniqueKey(),
          // background: Container(
          //   color: Colors.red,
          // ),
          children: [
            ListTile(
              title: Column(
                children: [
                  Text("Fecha:${cita.fechaCita}"),
                  Text("Nombre del cliente: ${cita.nombreClient}"),
                  // Text("Posible a doptante para: " '${cita.animal!.nombre}'),
                  Text("Día de la cita: $fecha"),
                  Text("Hora de la cita: $hora"),
                ],
              ),
              //subtitle: Text('${horario}'),
              onTap: () =>
                  Navigator.pushNamed(context, 'verCitasR', arguments: cita),
            )
          ]),
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
        controller: _inputFieldDateController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Fecha de la cita',
          //helperText: 'Solo es el nombre',
          suffixIcon:
              const Icon(Icons.perm_contact_calendar, color: Colors.green),
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.green,
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            _selectDate(context);
          });
        });
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      locale: const Locale('es', 'ES'),
    );

    if (picked != null) {
      setState(() {
        _fecha = picked.year.toString() +
            '-' +
            picked.month.toString() +
            '-' +
            picked.day.toString();
        //_fechaCompleta = picked.toString();

        //_fecha = DateFormat('EEEE').format(picked);
        _inputFieldDateController.text = _fecha;
        showCitas();
      });
    }
  }
}
