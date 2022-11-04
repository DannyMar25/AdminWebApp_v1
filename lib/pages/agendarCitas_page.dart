import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/citas_model.dart';
import 'package:admin_web_v1/models/horarios_model.dart';
import 'package:admin_web_v1/pages/login_page.dart';
import 'package:admin_web_v1/preferencias_usuario/preferencias_usuario.dart';
import 'package:admin_web_v1/providers/citas_provider.dart';
import 'package:admin_web_v1/providers/horarios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgendarCitasPage extends StatefulWidget {
  const AgendarCitasPage({Key? key}) : super(key: key);

  //RegistroClienteCitas({Key? key}) : super(key: key);

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
  TextEditingController nombre = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController correo = TextEditingController();
  String _fecha = '';
  String _fechaCompleta = '';
  final TextEditingController _inputFieldDateController =
      TextEditingController();
  String campoVacio = 'Por favor, llena este campo';
  final prefs = PreferenciasUsuario();

  //bool _guardando = false;
  //final formKey = GlobalKey<FormState>();
  HorariosModel horarios = HorariosModel();
  final horariosProvider = HorariosProvider();
  final citasProvider = CitasProvider();
  CollectionReference dbRefH =
      FirebaseFirestore.instance.collection('horarios');

  AnimalModel animal = AnimalModel();

  bool seleccionado = false;

  late String horaSeleccionada;
  late String idHorario;
  @override
  Widget build(BuildContext context) {
    final email = prefs.email;
    final Object? animData = ModalRoute.of(context)!.settings.arguments;
    if (animData != null) {
      animal = animData as AnimalModel;
      //print(animal.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de citas'),
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
        child: Center(
          child: Container(
            width: 850,
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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false);
      // Navigator.pushNamed(context, 'login');
    }
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
        controller: _inputFieldDateController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          //counter: Text('Letras ${_nombre.length}'),
          //hintText: 'Ingrese fecha de agendamiento de cita',
          labelText: 'Fecha de la cita',
          //helperText: 'Solo es el nombre',
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
            return 'Por favor selecciona una fecha';
          } else {
            return null;
          }
        },
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _selectDate(context);
        });
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 8)),
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

        // _fecha = picked.toString();
        _fecha = picked.weekday.toString();
        if (_fecha == '1') {
          _fecha = 'Lunes';
        }
        if (_fecha == '2') {
          _fecha = 'Martes';
        }
        if (_fecha == '3') {
          _fecha = 'Miércoles';
        }
        if (_fecha == '4') {
          _fecha = 'Jueves';
        }
        if (_fecha == '5') {
          _fecha = 'Viernes';
        }
        if (_fecha == '6') {
          _fecha = 'Sábado';
        }
        if (_fecha == '7') {
          _fecha = 'Domingo';
        }
        //_fecha = DateFormat('EEEE').format(picked);
        _inputFieldDateController.text = '$_fecha $_fechaCompleta';
      });
    }
  }

  Widget _verListado() {
    return FutureBuilder(
        future: horariosProvider.cargarHorariosDia1(_fecha),
        builder: (BuildContext context,
            AsyncSnapshot<List<HorariosModel>> snapshot) {
          if (snapshot.hasData) {
            final horarios = snapshot.data;
            return SizedBox(
                height: 300,
                width: 650,
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
            idHorario = horario.id;
            horaSeleccionada = horario.hora;

            //print(horario.hora);
          },
          initialValue: '${horario.hora}  -   ${horario.disponible}',
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              //labelText: 'Hora',
              suffixIcon: const Icon(Icons.add),
              icon: const Icon(Icons.calendar_today)),
        ),
        const Divider(
          color: Colors.white,
        )
      ],
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      //initialValue: animal.nombre,
      controller: nombre,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Nombre',
      ),
      onSaved: (value) => nombre = value as TextEditingController,
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
      controller: telefono,
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)
      ],
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Teléfono (Celular: 0998765432)',
      ),
      onSaved: (value) => telefono = value as TextEditingController,
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
      controller: correo,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Correo',
      ),
      onSaved: (value) => correo = value as TextEditingController,
      validator: (value) => validarEmail(value),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.green[700];
          }),
        ),
        label: const Text('Revisar'),
        icon: const Icon(Icons.save),
        autofocus: true,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Información'),
                  content: Text(
                      'Nombre: ${nombre.text}\nTeléfono: ${telefono.text}\nCorreo: ${correo.text}\nFecha de la cita:$_fechaCompleta\nHora:$horaSeleccionada'),
                  actions: [
                    TextButton(
                        child: const Text('Guardar'),
                        //onPressed: () => Navigator.of(context).pop(),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            const SnackBar(
                              content:
                                  Text('Información ingresada correctamente.'),
                            );
                            _submit();
                          } else {
                            mostrarAlerta(context,
                                'Asegúrate de que todos los campos estén llenos.');
                          }
                        }),
                    TextButton(
                        child: const Text('Corregir información'),
                        //onPressed: () => Navigator.of(context).pop(),
                        onPressed: () => Navigator.of(context).pop()),
                  ],
                );
              });
        });
  }

  void _submit() async {
    //Guardar datos en base
    citas.nombreClient = nombre.text;
    citas.telfClient = telefono.text;
    citas.correoClient = correo.text;
    citas.fechaCita = _fechaCompleta;
    horariosProvider.editarDisponible(idHorario);
    citas.idHorario = idHorario;
    citas.estado = 'Pendiente';
    if (animal.id == '') {
      citas.idAnimal = 'WCkke2saDQ5AfeJkU6ck';
    } else {
      citas.idAnimal = animal.id!;
    }

    if (citas.id == "") {
      final estadoCita = await citasProvider.verificar(correo.text);
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
  }
}
