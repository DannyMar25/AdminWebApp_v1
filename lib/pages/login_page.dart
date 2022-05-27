import 'package:admin_web_v1/blocs/login_bloc.dart';
import 'package:admin_web_v1/blocs/provider.dart';
import 'package:admin_web_v1/pages/forgotPassword_page.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  //const LoginPage({Key? key}) : super(key: key);
  final usuarioProvider = new UsuarioProvider();
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
                  'Ingreso',
                  style: TextStyle(fontSize: 20.0),
                ),
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
                _crearBoton(bloc),
              ],
            ),
          ),

          _crearBotonPass(context),
          // TextButton(
          //   onPressed: () => Navigator.pushNamed(context, 'registro'),
          //   child: Text('Crear una nueva cuenta'),
          // ),
          // SizedBox(
          //   height: 100.0,
          // )
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
              labelText: 'Correo electronico',
              counterText: snapshot.data,
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
            obscureText: true,
            //keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: const Icon(Icons.lock_outline, color: Colors.green),
              //hintText: 'ejemplo@correo.com',
              labelText: 'Contrasena',
              counterText: snapshot.data,
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
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: const Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 0.0,
          color: Colors.green,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    //print('=================');
    //print('Email:${bloc.email}');
    //print('Password: ${bloc.password}');
    //print('=================');
    Map info = await usuarioProvider.login(bloc.email, bloc.password);
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      //mostrarAlerta(context, info['mensaje']);
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
        'Olvido la contraseña?',
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
          Color.fromARGB(196, 15, 206, 72),
          Color.fromARGB(196, 12, 247, 51),
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
              // Text(
              //   'Bienvenid@',
              //   style: TextStyle(color: Colors.white, fontSize: 25.0),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
