import 'package:admin_web_v1/models/citas_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/citas_provider.dart';
import 'package:admin_web_v1/providers/horarios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerCitasAtendidasPage extends StatefulWidget {
  const VerCitasAtendidasPage({Key? key}) : super(key: key);

  @override
  _VerCitasAtendidasPageState createState() => _VerCitasAtendidasPageState();
}

class _VerCitasAtendidasPageState extends State<VerCitasAtendidasPage> {
  List<CitasModel> citasA = [];
  List<Future<CitasModel>> listaC = [];
  final formKey = GlobalKey<FormState>();
  final citasProvider = CitasProvider();
  final horariosProvider = HorariosProvider();
  final animalesProvider = AnimalesProvider();
  final userProvider = UsuarioProvider();
  String _fecha = '';
  final TextEditingController _inputFieldDateController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    showCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas Atendidas'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: const Icon(Icons.manage_accounts),
              itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Información"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Ayuda"),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
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
                // _crearBoton(),
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
        break;
      case 1:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 2:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
    }
  }

  showCitas() async {
    //se anadio un clear()
    citasA.clear();
    listaC = await citasProvider
        .cargarCitasAtendidas(_inputFieldDateController.text);
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
                  Text("Nombre del cliente: ${cita.nombreClient}"),
                  // Text("Posible a doptante para: " '${cita.animal!.nombre}'),
                  Text("Fecha de la cita: " + fecha + ' - ' + cita.fechaCita),
                  Text("Hora de la cita: $hora"),
                ],
              ),
              //subtitle: Text('${horario}'),
              //onTap: () => Navigator.pushNamed(context, 'verCitasR', arguments: cita),
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
        _fecha = '${picked.year}-${picked.month}-${picked.day}';
        //_fechaCompleta = picked.toString();

        //_fecha = DateFormat('EEEE').format(picked);
        _inputFieldDateController.text = _fecha;
        showCitas();
      });
    }
  }
}
