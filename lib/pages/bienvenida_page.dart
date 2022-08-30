import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:admin_web_v1/preferencias_usuario/preferencias_usuario.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:firebase_database/firebase_database.dart';
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
    //backgroundColor: Colors.green,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagina principal'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: const Icon(Icons.manage_accounts),
              itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Soporte"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Cerrar sesión"),
                    ),
                  ]),
        ],
      ),
      drawer: const MenuWidget(),
      body: Container(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 15.0, bottom: 10.0)),
            Center(
              child: Text(
                'BIENVENIDO',
                style: TextStyle(
                  fontSize: 33,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = const Color.fromARGB(204, 160, 236, 61),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                //Padding(padding: EdgeInsets.only(bottom: 5.0)),
                // SizedBox(
                //   child: Image(image: AssetImage('assets/dog_an6.gif')),
                //   height: 130,
                // ),
                SizedBox(
                  height: 650,
                  child: Accordion(
                    maxOpenSections: 1,
                    headerBackgroundColorOpened: Colors.black54,
                    //scaleWhenAnimating: true,
                    openAndCloseAnimation: true,
                    headerPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                    sectionClosingHapticFeedback: SectionHapticFeedback.light,
                    children: [
                      AccordionSection(
                        isOpen: true,
                        leftIcon: const Icon(Icons.pets, color: Colors.white),
                        headerBackgroundColor: Colors.green,
                        headerBackgroundColorOpened: Colors.green,
                        header: Text('¿Qué es PoliPet?', style: _headerStyle),
                        content: Text(_loremIpsum, style: _contentStyle),
                        contentHorizontalPadding: 20,
                        contentBorderWidth: 1,
                      ),
                      AccordionSection(
                        isOpen: false,
                        leftIcon: const Icon(Icons.photo_library,
                            color: Colors.white),
                        header:
                            Text('Mascotas registradas', style: _headerStyle),
                        contentBorderColor: const Color(0xffffffff),
                        headerBackgroundColor:
                            const Color.fromARGB(251, 236, 122, 193),
                        headerBackgroundColorOpened: Colors.purple,
                        content: Column(
                          children: [
                            const Text(
                                'Mira los registros de todas las mascotas o crea uno nuevo.'),
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
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                //cardB.currentState?.collapse();
                                Navigator.pushNamed(context, 'animal');
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
                                    'Registrar nueva mascota',
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
                        leftIcon:
                            const Icon(Icons.fact_check, color: Colors.white),
                        header: Text('Citas', style: _headerStyle),
                        headerBackgroundColor: Colors.blue,
                        content: Column(
                          children: [
                            const Text(
                                "Revisa los horarios disponibles para agendamiento de citas.\nRegistra una nueva cita, revisa citas pendientes o atendidas."),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10.0)),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'horariosAdd');
                              },
                              child: Column(
                                children: const <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Text(
                                    'Ver horarios registrados',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'agendarCita');
                              },
                              child: Column(
                                children: const <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Text(
                                    'Registrar nueva cita',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'verCitasR');
                              },
                              child: Column(
                                children: const <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Text(
                                    'Ver citas pendientes',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'verCitasAt');
                              },
                              child: Column(
                                children: const <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Text(
                                    'Ver citas atendidas',
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
                        leftIcon:
                            const Icon(Icons.list_alt, color: Colors.white),
                        header: Text('Solicitudes de adopción',
                            style: _headerStyle),
                        headerBackgroundColor:
                            const Color.fromARGB(255, 170, 124, 248),
                        content: Column(
                          children: [
                            const Text(
                              'Revisa las solicitudes de adopción que han sido enviadas, mira las solicitudes aprobadas y negadas.',
                              textAlign: TextAlign.justify,
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'solicitudes');
                              },
                              child: Column(
                                children: const <Widget>[
                                  Icon(
                                    Icons.photo_album,
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
                                    Icons.photo_album,
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
                                    Icons.photo_album,
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
                        leftIcon: const Icon(Icons.pets, color: Colors.white),
                        header: Text('Seguimiento de mascotas',
                            style: _headerStyle),
                        content: Column(
                          children: [
                            const Text(
                              "Puedes realizar el seguimiento de las mascotas que han sido adoptadas.",
                              textAlign: TextAlign.justify,
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, 'seguimientoPrincipal');
                              },
                              child: Column(
                                children: const <Widget>[
                                  Icon(
                                    Icons.verified,
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
                        leftIcon: const Icon(Icons.pets, color: Colors.white),
                        header: Text('Donaciones', style: _headerStyle),
                        content: Column(
                          children: [
                            const Text(
                              "Registra las donaciones que han llegado o han salido de la fundación",
                              textAlign: TextAlign.justify,
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'donacionesInAdd');
                              },
                              child: Column(
                                children: const <Widget>[
                                  Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Text(
                                    'Registrar donacion recibida',
                                    style: TextStyle(color: Colors.green),
                                  ),
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
                                    Icons.verified,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Text(
                                    'Registrar donacion saliente',
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
}
