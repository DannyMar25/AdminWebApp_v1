import 'package:admin_web_v1/blocs/login_bloc.dart';
import 'package:admin_web_v1/blocs/provider.dart';
import 'package:admin_web_v1/models/usuarios_model.dart';
import 'package:admin_web_v1/pages/forgotPassword_page.dart';
import 'package:admin_web_v1/preferencias_usuario/preferencias_usuario.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //const LoginPage({Key? key}) : super(key: key);
  final usuarioProvider = UsuarioProvider();
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
              height: 250.0,
              //height: 230.0,
            ),
          ),
          Container(
            width: 390.0,
            //height: 275.00,
            height: 310.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              textBaseline: TextBaseline.ideographic,
              children: [
                const Text(
                  'Inicio de sesión',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                _crearEmail(bloc),
                const SizedBox(
                  height: 10.0,
                ),
                _crearPassword(bloc),
                const SizedBox(
                  height: 15.0,
                ),
                _crearBoton(bloc),
              ],
            ),
          ),
          //Text('Olvido la contrasena?'),
          _crearBotonPass(context),
          //Padding(padding: EdgeInsets.only(bottom: .0)),
          _crearBotonSoporte(context)
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

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            //obscureText: true,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              icon: const Icon(Icons.lock_outline, color: Colors.green),
              labelText: 'Contraseña',
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.green,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changePassword,
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
      stream: bloc.formValidStreamL,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0.0,
              primary: Colors.green,
              textStyle: const TextStyle(color: Colors.white)),
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: const Text('Ingresar'),
          ),
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    final prefs = PreferenciasUsuario();
    final usuario = UsuariosModel();

    // prefs.initPrefs();
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    Map info = await usuarioProvider.login(bloc.email, bloc.password);
    if (info['ok']) {
      final user = await usuarioProvider.obtenerUsuario(info['uid']);
      prefs.setEmail(bloc.email);
      prefs.setRol(user['rol']);
      prefs.setNombre(user['nombre']);
      if (user['rol'] == 'Administrador' ||
          user['rol'] == 'SuperAdministrador') {
        //Navigator.pushNamed(context, 'intro');
        Navigator.pushNamed(context, 'bienvenida');
      } else {
        mostrarAlertaOk1(
            context,
            'Solo usuarios autorizados pueden acceder a la aplicación.',
            'login',
            'Advertencia');
      }
      //Navigator.pushNamed(context, 'bienvenida');
    } else {
      mostrarAlerta(context, 'El correo o contraseña son incorrectos.');
    }

    //Navigator.pushReplacementNamed(context, 'home');
  }

  Widget _crearBotonPass(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          ForgotPassword.id,
        );
      },
      child: const Text(
        '¿Olvidó la contraseña?',
        style: TextStyle(color: Colors.green, fontSize: 20),
      ),
    );
  }

  Widget _crearBotonSoporte(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, 'soporte');
      },
      child: const Text(
        'Contactarse con soporte.',
        style: TextStyle(color: Colors.green, fontSize: 20),
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: 400.0,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Color.fromARGB(255, 22, 175, 60),
          Color.fromARGB(255, 30, 184, 63),
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
              //Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              Image.asset('assets/pet-care.png', height: 190),

              const SizedBox(height: 10.0, width: double.infinity),
            ],
          ),
        ),
      ],
    );
  }
}
