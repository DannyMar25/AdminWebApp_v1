import 'package:accordion/controllers.dart';
import 'package:admin_web_v1/pages/login_page.dart';
import 'package:admin_web_v1/preferencias_usuario/preferencias_usuario.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';

class BienvenidaPage extends StatelessWidget {
  final userProvider = UsuarioProvider();
  final prefs = PreferenciasUsuario();
  final _headerStyle = const TextStyle(
      color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyle = const TextStyle(
      color: Color.fromARGB(255, 17, 17, 17),
      fontSize: 14,
      fontWeight: FontWeight.normal);
  final _loremIpsum =
      '''PoliPet es una app dedicada a difundir la adopción de mascotas, nuestro principal objetivo es mejorar la calidad de vida de animalitos que no tienen un hogar''';
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    //side: const BorderSide(color: Colors.green),
    //backgroundColor: Colors.green,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  void setGPS(int getData, String id) {
    //ProductoModel producto;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseReference prodRef = ref.child("gps");
    DatabaseReference urlRef = prodRef.child("Test");
    urlRef.update({"GetDataGPS": getData, "id": id});
  }

  @override
  Widget build(BuildContext context) {
    double heighScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Inicio'),
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
                      child: Text("Cerrar sesión"),
                    ),
                    // PopupMenuItem<int>(
                    //   child: Text("Cambiar"),
                    //   value: 2,
                    // ),
                  ]),
        ],
      ),
      drawer: const MenuWidget(),
      body: Center(
        child: Container(
          width: 850,
          //height: 500,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 15.0, bottom: 10.0)),
              Center(
                child: Text(
                  'B I E N V E N I D O',
                  style: TextStyle(
                    fontSize: 33,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4
                      ..color = Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: heighScreen - heighScreen * 0.2, //560, //530
                    child: Accordion(
                      maxOpenSections: 1,
                      headerBackgroundColorOpened: Colors.black54,
                      //scaleWhenAnimating: true,
                      openAndCloseAnimation: true,
                      headerPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                      sectionClosingHapticFeedback: SectionHapticFeedback.light,
                      children: [
                        AccordionSection(
                          isOpen: true,
                          leftIcon: const Icon(Icons.pets, color: Colors.white),
                          headerBackgroundColor: Colors.green,
                          headerBackgroundColorOpened:
                              Color.fromARGB(255, 49, 141, 52),
                          header: Text('¿Qué es PoliPet?', style: _headerStyle),
                          contentBorderColor: Color.fromARGB(255, 90, 185, 81),
                          content: Text(_loremIpsum, style: _contentStyle),
                          contentHorizontalPadding: 20,
                          contentBorderWidth: 1,
                          // onOpenSection: () => print('onOpenSection ...'),
                          // onCloseSection: () => print('onCloseSection ...'),
                        ),
                        AccordionSection(
                          isOpen: false,
                          leftIcon: const Icon(Icons.photo_library,
                              color: Colors.white),
                          header:
                              Text('Registro de animales', style: _headerStyle),
                          contentBorderColor: Color.fromARGB(255, 153, 22, 131),
                          headerBackgroundColor:
                              const Color.fromARGB(251, 236, 122, 193),
                          headerBackgroundColorOpened: Colors.purple,
                          content: Column(
                            children: [
                              const Text(
                                  'Mira los registros de todas las mascotas o crea uno nuevo.'),
                              const SizedBox(height: 10),
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  //cardB.currentState?.collapse();
                                  Navigator.pushNamed(context, 'animal');
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.post_add,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text(
                                      'Agregar nuevo',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  //cardB.currentState?.collapse();
                                  Navigator.pushNamed(context, 'home');
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.photo_library_outlined,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text(
                                      'Galería',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        AccordionSection(
                          isOpen: false,
                          leftIcon: const Icon(Icons.calendar_month_outlined,
                              color: Colors.white),
                          header: Text('Citas', style: _headerStyle),
                          headerBackgroundColor: Colors.blue,
                          contentBorderColor: Color.fromARGB(255, 37, 165, 204),
                          content: Column(
                            children: [
                              const Text(
                                  "Revisa los horarios disponibles para agendamiento de citas.\nRegistra una nueva cita, revisa citas pendientes o atendidas."),
                              const SizedBox(height: 10),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 10.0)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: flatButtonStyle,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, 'horariosAdd');
                                    },
                                    child: Column(
                                      children: const <Widget>[
                                        Icon(
                                          Icons.app_registration_outlined,
                                          color: Colors.green,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                        ),
                                        Text(
                                          'Ver horarios registrados',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    style: flatButtonStyle,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, 'agendarCita');
                                    },
                                    child: Column(
                                      children: const <Widget>[
                                        Icon(
                                          Icons.list_alt,
                                          color: Colors.green,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                        ),
                                        Text(
                                          'Agendar cita',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: flatButtonStyle,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, 'verCitasAg');
                                    },
                                    child: Column(
                                      children: const <Widget>[
                                        Icon(
                                          Icons.check_outlined,
                                          color: Colors.green,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                        ),
                                        Text(
                                          'Ver citas pendientes',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    style: flatButtonStyle,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, 'verCitasAt');
                                    },
                                    child: Column(
                                      children: const <Widget>[
                                        Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                        ),
                                        Text(
                                          'Ver citas atendidas',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        AccordionSection(
                          isOpen: false,
                          leftIcon:
                              const Icon(Icons.assignment, color: Colors.white),
                          header: Text('Solicitudes de adopción',
                              style: _headerStyle),
                          headerBackgroundColor:
                              const Color.fromARGB(255, 170, 124, 248),
                          contentBorderColor: Color.fromARGB(255, 160, 81, 143),
                          content: Column(
                            children: [
                              const Text(
                                'Revisa las solicitudes de adopción que han sido enviadas, mira las solicitudes aprobadas y negadas.',
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  Navigator.pushNamed(context, 'solicitudes');
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.inventory,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text(
                                      'Ver solicitudes pendientes',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, 'solicitudesAprobadas');
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text(
                                      'Ver solicitudes aprobadas',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, 'solicitudesRechazadas');
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.clear,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text(
                                      'Ver solicitudes rechazadas',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        AccordionSection(
                          isOpen: false,
                          leftIcon: const Icon(Icons.manage_search_sharp,
                              color: Colors.white),
                          contentBorderColor: Color.fromARGB(255, 224, 191, 40),
                          header: Text('Seguimiento', style: _headerStyle),
                          content: Column(
                            children: [
                              const Text(
                                "Puedes realizar el seguimiento de las mascotas que han sido adoptadas.",
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, 'seguimientoPrincipal');
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.manage_search_sharp,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text(
                                      'Realizar seguimiento',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          headerBackgroundColor:
                              const Color.fromARGB(255, 240, 160, 39),
                        ),
                        AccordionSection(
                          isOpen: false,
                          leftIcon:
                              const Icon(Icons.favorite, color: Colors.white),
                          header: Text('Donaciones', style: _headerStyle),
                          contentBorderColor: Color.fromARGB(255, 79, 156, 150),
                          content: Column(
                            children: [
                              const Text(
                                "Registra las donaciones que han llegado o han salido de la fundación",
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, 'donacionesInAdd');
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.add_circle_outline_outlined,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text(
                                      'Agregar donación recibida',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, 'donacionesOutAdd');
                                },
                                child: Column(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.add_circle_outline_outlined,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text(
                                      'Agregar donación saliente',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          headerBackgroundColor:
                              const Color.fromARGB(255, 59, 243, 228),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // SizedBox(
              //   child: Image(
              //     image: AssetImage('assets/dog_an2.gif'),
              //   ),
              //   width: 200,
              // )
            ],
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
      //Navigator.pushNamed(context, 'login');
      //   break;
      // case 2:
      //   //userProvider.signOut();
      //   Navigator.pushNamed(context, 'perfilUser');
    }
  }
}
