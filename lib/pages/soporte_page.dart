import 'package:admin_web_v1/models/soportes_model.dart';
import 'package:admin_web_v1/preferencias_usuario/preferencias_usuario.dart';
import 'package:admin_web_v1/providers/soportes_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SoportePage extends StatefulWidget {
  const SoportePage({Key? key}) : super(key: key);

  @override
  State<SoportePage> createState() => _SoportePageState();
}

class _SoportePageState extends State<SoportePage> {
  final formKey = GlobalKey<FormState>();
  final userProvider = UsuarioProvider();
  SoportesProvider soportesProvider = SoportesProvider();
  SoportesModel soporte = SoportesModel();
  final prefs = PreferenciasUsuario();
  String campoVacio = 'Por favor, llena este campo';

  @override
  Widget build(BuildContext context) {
    final email = prefs.email;
    return Scaffold(
      backgroundColor: const Color.fromARGB(223, 221, 248, 153),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Soporte"),
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: const Icon(Icons.manage_accounts),
              itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Soporte"),
                    ),
                    email != ''
                        ? const PopupMenuItem<int>(
                            value: 1,
                            child: Text("Cerrar Sesión"),
                          )
                        : const PopupMenuItem<int>(
                            value: 1,
                            child: Text("Iniciar Sesión"),
                          ),
                  ]),
        ],
      ),
      drawer: email != '' ? const MenuWidget() : const SizedBox(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 850,
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Contactarse con soporte",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 40.0)),
                  _crearNombre(),
                  _crearCorreo(),
                  _crearAsunto(),
                  _crearMensaje(),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  _crearBoton(),
                  const Padding(padding: EdgeInsets.only(bottom: 210.0))
                  // buildAbout(),
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

  Widget _crearNombre() {
    return TextFormField(
      //initialValue: datoPersona.nombreCom,
      readOnly: false,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      decoration: const InputDecoration(
          icon: Icon(
            Icons.person,
            //color: Colors.green,
          ),
          labelText: 'Nombre:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese el nombre';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
      onChanged: (s) {
        setState(() {
          soporte.nombre = s;
        });
      },
    );
  }

  Widget _crearCorreo() {
    return TextFormField(
      //initialValue: datoPersona.nombreCom,
      readOnly: false,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          icon: Icon(Icons.mail),
          labelText: 'Correo:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      validator: (value) => validarEmail(value),
      onChanged: (s) {
        setState(() {
          soporte.correo = s;
        });
      },
    );
  }

  Widget _crearAsunto() {
    return TextFormField(
      //initialValue: datoPersona.nombreCom,
      readOnly: false,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      decoration: const InputDecoration(
          icon: Icon(Icons.edit),
          labelText: 'Asunto:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese el asunto';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
      onChanged: (s) {
        setState(() {
          soporte.asunto = s;
        });
      },
    );
  }

  Widget _crearMensaje() {
    return TextFormField(
      //initialValue: datoPersona.nombreCom,
      readOnly: false,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          icon: Icon(Icons.edit_note),
          labelText: 'Mensaje:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese un mensaje';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
      onChanged: (s) {
        setState(() {
          soporte.mensaje = s;
        });
      },
    );
  }

  Widget _crearBoton() {
    final email = prefs.email;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton.icon(
          style: ButtonStyle(
            //padding: new EdgeInsets.only(top: 5),
            backgroundColor:
                MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              return Colors.green[500];
            }),
          ),
          label: const Text(
            'Enviar',
            style: TextStyle(fontSize: 16),
          ),
          icon: const Icon(Icons.save),
          autofocus: true,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              // Si el formulario es válido, queremos mostrar un Snackbar
              const SnackBar(
                content: Text('Información ingresada correctamente.'),
              );
              soportesProvider.crearSoportes(soporte);
              email != ''
                  ? mostrarAlertaOk(
                      context, 'Tu mensaje ha sido enviado.', 'home')
                  : mostrarAlertaOk(
                      context, 'Tu mensaje ha sido enviado.', 'login');

              //Navigator.pushReplacementNamed(context, 'home');
            } else {
              mostrarAlerta(
                  context, 'Asegúrate de que todos los campos estén llenos.');
            }
          }),
    ]);
  }
}
