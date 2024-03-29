import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = FirebaseAuth.instance;
  UsuarioProvider usuarioProvider = UsuarioProvider();

  String? _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
        ),
        //backgroundColor: Colors.lightGreenAccent[200],
        body: Stack(
          children: [
            _crearFondo(context),
            _loginForm(context),
          ],
        ));
  }

  Widget _loginForm(BuildContext context) {
    //final bloc = Provider.of(context);
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
                  'Restablece tu contraseña',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                const Text(
                  'Ingresa tu correo:',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    //labelText: 'Email',
                    icon: Icon(
                      Icons.mail,
                      color: Colors.green,
                    ),
                    errorStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese su correo electrónico';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (s) {
                    setState(() {
                      _email = s;
                    });
                  },
                ),
                const SizedBox(
                  height: 30.0,
                ),

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: const Text(
                    'Enviar',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    if (_email == '' || _email == null) {
                      return mostrarAlerta(
                          context, 'Por favor, ingrese su correo electrónico.');
                    } else {}
                    final estadoUsuario =
                        await usuarioProvider.verificar(_email!);
                    if (estadoUsuario.isEmpty) {
                      mostrarAlerta(context,
                          'El correo ingresado no es correcto. Contáctate con soporte.');
                    } else {
                      try {
                        _auth.sendPasswordResetEmail(email: _email!);
                        mostrarAlertaOk(
                            context,
                            'Se ha enviado a tu correo: $_email un enlace para restablecer la contraseña.',
                            'login');
                      } on FirebaseAuthException catch (e) {
                        //print(exception.code);
                        print(e.message);
                        mostrarAlertaAuth(context, 'adasdasd', 'soporte');
                      }
                    }
                  },
                ),
                // _crearPassword(bloc),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
          _crearBotonPass(context)
        ],
      ),
    );
  }

  Widget _crearBotonPass(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          'login',
        );
      },
      child: const Text(
        'Iniciar sesión',
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
