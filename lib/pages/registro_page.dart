import 'package:admin_web_v1/blocs/login_bloc.dart';
import 'package:admin_web_v1/blocs/provider.dart';
import 'package:admin_web_v1/models/usuarios_model.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/constants.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:flutter/material.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({Key? key}) : super(key: key);

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  //const RegistroPage({Key? key}) : super(key: key);
  final usuarioProvider = UsuarioProvider();

  final usuario = UsuariosModel();

  //TextEditingController _nombreUs = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: MenuWidget(),
      body: Stack(
        children: [
          //Drawer(child: MenuWidget()),
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 230.0,
            ),
          ),
          Container(
            width: 390.0,
            margin: const EdgeInsets.symmetric(vertical: 30.0),
            padding: const EdgeInsets.symmetric(vertical: 80.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                const Text(
                  'Crear cuenta',
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                _crearNombreUs(bloc),
                const SizedBox(
                  height: 60.0,
                ),
                _crearEmail(bloc),
                const SizedBox(
                  height: 30.0,
                ),
                _crearPassword(bloc),
                const SizedBox(
                  height: 30.0,
                ),
                create_password_confirm(bloc),
                const SizedBox(
                  height: 30.0,
                ),
                _crearBoton(bloc),
              ],
            ),
          ),
          //Text('Olvido la contrasena?'),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, 'home'),
            child: const Text(
              'Cancelar registro.',
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: const Icon(Icons.alternate_email, color: Colors.green),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              //counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearNombreUs(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              icon: const Icon(Icons.alternate_email, color: Colors.green),
              hintText: 'dany',
              labelText: 'Nombre de usuario:',
              //counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changeName,
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            //keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: const Icon(Icons.lock_outline, color: Colors.green),
              //hintText: 'ejemplo@correo.com',
              labelText: 'Contrasena',
              //counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  //Crear nuevo text para confirmar la contasena
  Widget create_password_confirm(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordConfirmStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: const Icon(Icons.lock, color: Colors.green),
              labelText: 'Confirmar contraseña',
              //counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: (value) => bloc.changePasswordConfirm(value),
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    //formValidStream
    //snapshot.hasData
    //true ? algo asi si true: algo asi si false
    return StreamBuilder(
      stream: bloc.formValidStream1,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: const Text('Registrar'),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0.0,
              primary: Colors.green,
              textStyle: const TextStyle(color: Colors.white)),
          onPressed: snapshot.hasData ? () => _register(bloc, context) : null,
        );
      },
    );
  }

  _register(LoginBloc bloc, BuildContext context) async {
    final info = await usuarioProvider.nuevoUsuario(
        bloc.email, bloc.password, bloc.name);
    if (info['ok']) {
      //print(bloc.name);
      usuario.id = info['uid'];
      usuario.nombre = bloc.name;
      usuario.email = bloc.email;
      usuario.rol = Roles.administrador;
      usuarioProvider.crearUsuario(usuario);
      Navigator.pushReplacementNamed(context, 'login');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }

    //Navigator.pushReplacementNamed(context, 'home');
  }

  Widget _crearFondo(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: 400.0,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Color.fromARGB(255, 22, 182, 62),
          Color.fromARGB(255, 25, 184, 64),
        ]),
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
    return Stack(
      children: [
        fondoMorado,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, left: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),
        Container(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              Image.asset('assets/pet-care.png', height: 190),
              //Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              const SizedBox(height: 10.0, width: double.infinity),
              const Text(
                'Bienvenid@',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
