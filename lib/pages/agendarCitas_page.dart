import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/citas_model.dart';
import 'package:admin_web_v1/models/horarios_model.dart';
import 'package:admin_web_v1/providers/citas_provider.dart';
import 'package:admin_web_v1/providers/horarios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgendarCitasPage extends StatefulWidget {
  const AgendarCitasPage({Key? key}) : super(key: key);

  @override
  _AgendarCitasPageState createState() => _AgendarCitasPageState();
}

class _AgendarCitasPageState extends State<AgendarCitasPage> {
  late double latitude, longitude;
  late DocumentSnapshot datosUbic;
  //List<Marker> myMarker = [];
  final firestoreInstance = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userProvider = UsuarioProvider();
  CitasModel citas = CitasModel();
  String nombre = '';
  String telefono = '';
  String correo = '';
  String _fecha = '';
  String _fechaCompleta = '';
  final TextEditingController _inputFieldDateController =
      TextEditingController();

  HorariosModel horarios = HorariosModel();
  final horariosProvider = HorariosProvider();
  final citasProvider = CitasProvider();
  CollectionReference dbRefH =
      FirebaseFirestore.instance.collection('horarios');

  AnimalModel animal = AnimalModel();

  String campoVacio = 'Por favor, llena este campo';
  @override
  Widget build(BuildContext context) {
    final Object? animData = ModalRoute.of(context)!.settings.arguments;
    if (animData != null) {
      animal = animData as AnimalModel;
      // ignore: avoid_print
      print(animal.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar citas'),
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
                _crearNombre(),
                _crearTelefono(),
                _crearCorreo(),
                const Divider(),
                _crearFecha(context),
                const Divider(),
                const Divider(),
                _verListado(),
                _crearBoton(),
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

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
        controller: _inputFieldDateController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Fecha de la cita',
          suffixIcon: const Icon(
            Icons.perm_contact_calendar,
            color: Colors.green,
          ),
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.green,
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            String fecha = 'Por favor selecciona una fecha';
            return fecha;
          } else {
            return null;
          }
        },
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
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.green, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.green, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaCompleta = '${picked.year}-${picked.month}-${picked.day}';
        //_fechaCompleta = picked.toString();
        _fecha = picked.weekday.toString();
        if (_fecha == '1') {
          _fecha = 'Lunes';
        }
        if (_fecha == '2') {
          _fecha = 'Martes';
        }
        if (_fecha == '3') {
          _fecha = 'Miercoles';
        }
        if (_fecha == '4') {
          _fecha = 'Jueves';
        }
        if (_fecha == '5') {
          _fecha = 'Viernes';
        }
        if (_fecha == '6') {
          _fecha = 'Sabado';
        }
        if (_fecha == '7') {
          _fecha = 'Domingo';
        }
        //_fecha = DateFormat('EEEE').format(picked);
        _inputFieldDateController.text = _fecha;
      });
    }
  }

  Widget _verListado() {
    return FutureBuilder(
        future:
            horariosProvider.cargarHorariosDia1(_inputFieldDateController.text),
        builder: (BuildContext context,
            AsyncSnapshot<List<HorariosModel>> snapshot) {
          if (snapshot.hasData) {
            final horarios = snapshot.data;
            return SizedBox(
                height: 300,
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
    return Column(
      children: [
        TextFormField(
          readOnly: true,
          onTap: () {
            citas.idHorario = horario.id;
            horariosProvider.editarDisponible(horario);
          },
          initialValue: horario.hora + '  -   ' + horario.disponible,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Hora',
              suffixIcon: const Icon(Icons.add),
              icon: const Icon(Icons.calendar_today)),
        ),
        const Divider(color: Colors.white),
      ],
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      //initialValue: animal.nombre,
      //controller: nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Nombre',
      ),
      onChanged: (s) {
        setState(() {
          nombre = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese su nombre';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearTelefono() {
    return TextFormField(
      //initialValue: animal.nombre,
      keyboardType: TextInputType.phone,
      //controller: telefono,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Teléfono',
      ),
      //onSaved: (value) => telefono = value as TextEditingController,
      onChanged: (s) {
        setState(() {
          telefono = s;
        });
      },
      validator: (value) {
        if (value!.length < 10 || value.length > 10 && value.length > 0) {
          return 'Ingrese un número de teléfono válido';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearCorreo() {
    return TextFormField(
      //initialValue: animal.nombre,
      keyboardType: TextInputType.emailAddress,
      //controller: correo,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Correo',
      ),
      onChanged: (s) {
        setState(() {
          correo = s;
        });
      },
      validator: (value) => validarEmail(value),
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
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // Si el formulario es válido, queremos mostrar un Snackbar
            const SnackBar(
              content: Text('Información ingresada correctamente'),
            );
            _submit();
          } else {
            mostrarAlerta(
                context, 'Asegurate de que todos los campos esten llenos.');
          }
        });
  }

  void _submit() async {
    //Guardar datos en base
    citas.nombreClient = nombre;
    citas.telfClient = telefono;
    citas.correoClient = correo;
    citas.fechaCita = _fechaCompleta;
    citas.estado = 'Pendiente';
    if (animal.id == '') {
      citas.idAnimal = 'WCkke2saDQ5AfeJkU6ck';
    } else {
      citas.idAnimal = animal.id!;
    }

    //citas.idHorario = horarios.id;

    if (citas.id == "") {
      final estadoCita = await citasProvider.verificar(correo);
      if (estadoCita.isEmpty) {
        //print('Puede');
        citasProvider.crearCita(citas);
        mostrarAlertaOk1(context, 'La cita ha sido registrada con éxito.',
            'home', 'Información correcta');
      } else {
        //print('no puede');
        mostrarAlerta(context, 'Al momento ya cuenta con una cita registrada.');
      }
    }

    //Navigator.pushNamed(context, 'bienvenida');
  }
}
