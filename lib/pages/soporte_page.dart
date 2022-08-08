import 'package:admin_web_v1/models/soportes_model.dart';
import 'package:admin_web_v1/preferencias_usuario/preferencias_usuario.dart';
import 'package:admin_web_v1/providers/soportes_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

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
                      child: Text("Informacion"),
                      value: 0,
                    ),
                    const PopupMenuItem<int>(
                      child: Text("Ayuda"),
                      value: 1,
                    ),
                    email != ''
                        ? const PopupMenuItem<int>(
                            child: Text("Cerrar Sesion"),
                            value: 2,
                          )
                        : const PopupMenuItem<int>(
                            child: Text("Iniciar Sesion"),
                            value: 2,
                          ),
                  ]),
        ],
      ),
      drawer: const MenuWidget(),
      body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/fondoanimales.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
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
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
    }
  }

  Widget _crearNombre() {
    return TextFormField(
      //initialValue: datoPersona.nombreCom,
      readOnly: false,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          icon: Icon(
            Icons.person,
            //color: Colors.green,
          ),
          labelText: 'Nombre:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
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
      decoration: const InputDecoration(
          icon: Icon(Icons.edit),
          labelText: 'Asunto:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
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
      keyboardType: TextInputType.multiline,
      readOnly: false,
      maxLines: 10,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          icon: Icon(Icons.edit_note),
          labelText: 'Mensaje:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        setState(() {
          soporte.mensaje = s;
        });
      },
    );
  }

  Widget _crearBoton() {
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
            soportesProvider.crearSoportes(soporte);

            Navigator.pushReplacementNamed(context, 'home');
          }),
    ]);
  }
}
