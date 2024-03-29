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
        title: const Text('Citas atendidas'),
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 850,
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Text(
                    "Seleccione el día que desea ver la cita.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(color: Colors.transparent),
                  const Divider(color: Colors.transparent),
                  _crearFecha(context),
                  const Divider(color: Colors.transparent),
                  _verListado(),
                  // _crearBoton(),
                ],
              ),
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
                  // ignore: prefer_interpolation_to_compose_strings
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
    return SizedBox(
      width: 800.0,
      child: TextFormField(
          controller: _inputFieldDateController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
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
          }),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // ignore: prefer_const_constructors
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 47, 126, 50), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: const Color.fromARGB(255, 54, 137, 57), // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary:
                    const Color.fromARGB(255, 58, 138, 61), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
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
