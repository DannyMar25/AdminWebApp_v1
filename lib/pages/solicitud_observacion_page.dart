import 'dart:html';

import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_domicilio_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/models/formulario_relacionAnimal_model.dart';
import 'package:admin_web_v1/models/formulario_situacionFam_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/formularios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class ObservacionFinalPage extends StatefulWidget {
  const ObservacionFinalPage({Key? key}) : super(key: key);

  @override
  State<ObservacionFinalPage> createState() => _ObservacionFinalPageState();
}

class _ObservacionFinalPageState extends State<ObservacionFinalPage> {
  FormulariosProvider formulariosProvider = FormulariosProvider();
  FormulariosModel formularios = FormulariosModel();
  DatosPersonalesModel datosC = DatosPersonalesModel();
  SitFamiliarModel situacionF = SitFamiliarModel();
  DomicilioModel domicilio = DomicilioModel();
  RelacionAnimalesModel relacionA = RelacionAnimalesModel();
  final userProvider = UsuarioProvider();
  final animalProvider = AnimalesProvider();
  File? foto;
  final formKey = GlobalKey<FormState>();
  bool isChecked = false;
  bool isChecked1 = false;
  String estado = '';
  String estadoAn = '';
  String fechaRespuesta = '';
  String observacion = '';
  //bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    final Object? formulariosData = ModalRoute.of(context)!.settings.arguments;
    if (formulariosData != null) {
      formularios = formulariosData as FormulariosModel;
      //print(formularios.id);
    }
    return Scaffold(
      //backgroundColor: const Color.fromARGB(223, 248, 248, 245),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Respuesta y observaciones"),
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
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _mostrarEstado(),
                    const Divider(),
                    Text(
                      'Cambiar estado de la solicitud revisada.',
                      style: TextStyle(
                        fontSize: 18,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(
                        children: [const Text('Aprobado'), _crearCheckBox1()],
                      ),
                      Row(
                        children: [const Text('Negado'), _crearCheckBox2()],
                      ),
                    ]),
                    const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                    _crearObservacion(),
                    const Padding(padding: EdgeInsets.only(bottom: 30.0)),
                    _crearFechaResp(),
                    const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                    _crearBoton(),
                    const Padding(padding: EdgeInsets.only(bottom: 515.0)),
                  ]),
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

  Widget _crearObservacion() {
    return TextFormField(
        maxLines: 4,
        readOnly: false,
        //initialValue: formularios.observacion,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          labelText: 'Observaciones:',
          //labelStyle: ,
          //border: BorderRadius(BorderRadius.circular(2.0)),
          icon: Icon(
            Icons.edit_outlined,
            color: Colors.green,
          ),
        ),
        validator: (value) {
          if (value!.length < 3 && value.length > 0) {
            return 'Ingrese observación';
          } else if (value.isEmpty) {
            return 'Llena este campo por favor';
          } else {
            return null;
          }
        },
        onChanged: (s) {
          setState(() {
            //formularios.observacion = s;
            observacion = s;
          });
        });
  }

  Widget _crearFechaResp() {
    return TextFormField(
        maxLines: 1,
        readOnly: true,
        //initialValue: DateTime.now().toString(),
        initialValue:
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          labelText: 'Fecha de respuesta:',
          //labelStyle: ,
          //border: BorderRadius(BorderRadius.circular(2.0)),
          icon: Icon(
            Icons.date_range_outlined,
            color: Colors.green,
          ),
        ),
        onChanged: (s) {
          setState(() {
            fechaRespuesta = s;
          });
        });
  }

  Widget _mostrarEstado() {
    return TextFormField(
      readOnly: true,
      initialValue: formularios.estado,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Estado de la solicitud:',
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.info,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _crearCheckBox1() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blueGrey;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        if (isChecked1 == true) {
          return null;
        } else {
          setState(() {
            isChecked = value!;
            //domicilio.planMudanza = "Si";
            estado = "Aprobado";
            estadoAn = "Adoptado";
            animalProvider.editarEstado(formularios.animal!, estadoAn);
          });
        }
      },
    );
  }

  Widget _crearCheckBox2() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blueGrey;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked1,
      onChanged: (bool? value) {
        if (isChecked == true) {
          return null;
        } else {
          setState(() {
            isChecked1 = value!;
            estado = "Negado";
            estadoAn = "En Adopción";
            animalProvider.editarEstado(formularios.animal!, estadoAn);
          });
        }
      },
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
        if (formKey.currentState!.validate()) {
          if (isChecked == false && isChecked1 == false) {
            mostrarAlerta(context,
                'Debe seleccionar una de las opciones de Aprobado o Negado.');
          } else {
            const SnackBar(
              content: Text('Información ingresada correctamente.'),
            );

            _submit();
            mostrarAlertaOk(
                context, 'Información actualizada con éxito.', 'solicitudes');
          }
          const SnackBar(
            content: Text('Información ingresada correctamente.'),
          );
        } else {
          mostrarAlerta(
              context, 'Asegúrate de que todos los campos estén llenos.');
        }
      },
    );
  }

  void _submit() async {
    var fechaResp =
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    formulariosProvider.editarEstado(formularios, estado);
    formulariosProvider.editarObservacion(formularios, observacion);
    formulariosProvider.editarFechaRespuesta(formularios, fechaResp);
    //Navigator.pushNamed(context, 'solicitudes');
  }
}
