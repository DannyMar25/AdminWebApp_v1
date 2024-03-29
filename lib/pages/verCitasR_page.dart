import 'dart:html';

import 'package:admin_web_v1/models/citas_model.dart';
import 'package:admin_web_v1/providers/citas_provider.dart';
import 'package:admin_web_v1/providers/horarios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerCitasRegistradas extends StatefulWidget {
  const VerCitasRegistradas({Key? key}) : super(key: key);

  //const VerCitasAtendidas({Key? key}) : super(key: key);

  @override
  _VerCitasRegistradasState createState() => _VerCitasRegistradasState();
}

class _VerCitasRegistradasState extends State<VerCitasRegistradas> {
  CitasModel citas = CitasModel();

  final citasProvider = CitasProvider();
  final horariosProvider = HorariosProvider();
  final userProvider = UsuarioProvider();
  File? foto;
  final formKey = GlobalKey<FormState>();
  bool _checkbox = false;

  @override
  Widget build(BuildContext context) {
    final Object? citasData = ModalRoute.of(context)!.settings.arguments;
    if (citasData != null) {
      citas = citasData as CitasModel;
      //print(citas.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos de la cita"),
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
                  _crearNombreClient(),
                  _crearTelfClient(),
                  const SizedBox(height: 5),
                  const Text(
                    "Posible adoptante para:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  _mostrarFoto(),
                  // Divider(),
                  _mostrarNombreAn(),
                  const SizedBox(height: 10),

                  _crearEstadoCita(),
                  const Text("Cita Atendida"),
                  const SizedBox(
                    height: 10,
                  ),
                  _crearBoton(),

                  // _crearDisponible(),
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

  Widget _crearNombreClient() {
    return TextFormField(
      readOnly: true,
      initialValue: citas.nombreClient,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Nombre',
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.person,
          color: Colors.green,
        ),
      ),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  Widget _crearTelfClient() {
    return TextFormField(
      readOnly: true,
      initialValue: citas.telfClient,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          labelText: 'Teléfono',
          icon: Icon(
            Icons.call,
            color: Colors.green,
          )),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  Widget _mostrarNombreAn() {
    return TextFormField(
      readOnly: true,
      initialValue: citas.animal!.nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          labelText: 'Nombre',
          icon: Icon(
            Icons.pets,
            color: Colors.green,
          )),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  Widget _mostrarFoto() {
    if (citas.animal!.fotoUrl != '') {
      return FadeInImage(
        image: NetworkImage(citas.animal!.fotoUrl),
        placeholder: const AssetImage('assets/jar-loading.gif'),
        height: 200,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        // return Image.file(
        //   foto!,
        //   fit: BoxFit.cover,
        //   height: 300.0,
        // );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  Widget _crearEstadoCita() {
    return Checkbox(
      value: _checkbox,
      onChanged: (value) {
        setState(() {
          _checkbox = !_checkbox;
          //if (_checkbox == true) {
          // citasProvider.editarEstadoCita(citas);
          // }
        });
      },
    );
    //Text('I am true now');
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
          if (_checkbox) {
            citasProvider.editarEstadoCita(citas);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Información'),
                    content: const Text('La cita ha sido atendida.'),
                    actions: [
                      TextButton(
                          child: const Text('Ok'),
                          //onPressed: () => Navigator.of(context).pop()),
                          onPressed: () {
                            horariosProvider
                                .editarDisponibleCita(citas.horario!);
                            Navigator.pushNamed(context, 'bienvenida');
                          }),
                    ],
                  );
                });
            // horariosProvider.editarDisponibleCita(citas.horario!);
            // Navigator.pushNamed(context, 'bienvenida');
          }
        }
        // onPressed: () {
        //   print(animal.id);
        // },
        );
  }
}
