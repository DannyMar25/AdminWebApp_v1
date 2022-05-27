import 'package:admin_web_v1/models/soportes_model.dart';
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
  final userProvider = new UsuarioProvider();
  SoportesProvider soportesProvider = new SoportesProvider();
  SoportesModel soporte = new SoportesModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const PopupMenuItem<int>(
                      child: Text("Cerrar Sesion"),
                      value: 2,
                    )
                  ]),
        ],
      ),
      drawer: const MenuWidget(),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fondoanimales.jpg"),
              fit: BoxFit.cover,
            ),
          ),
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
        Navigator.pushNamed(context, 'soporte');
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
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
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
      readOnly: false,
      maxLines: 10,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
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
          label: const Text('Enviar'),
          icon: const Icon(Icons.save),
          autofocus: true,
          onPressed: () {
            soportesProvider.crearSoportes(soporte);

            Navigator.pushReplacementNamed(context, 'home');
          }),
    ]);
  }
}
