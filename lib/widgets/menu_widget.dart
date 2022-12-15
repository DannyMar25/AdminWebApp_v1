import 'package:admin_web_v1/pages/forgotPassword_page.dart';
import 'package:admin_web_v1/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final prefs = PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    final rol = prefs.rol;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pet-care.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.green,
            ),
            title: const Text('Inicio'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushNamed(context, 'bienvenida');
            },
          ),
          ExpansionTile(
            title: const Text('Registro de animales'),
            leading: const Icon(
              Icons.pets,
              color: Colors.green,
            ),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.post_add,
                  color: Colors.green,
                ),
                title: const Text('Agregar nuevo '),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, 'animal');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: Colors.green,
                ),
                title: const Text('Galería'),
                onTap: () => Navigator.pushNamed(context, 'home'),
              ),
            ],
          ),

          const Divider(),
          //Creacion de un submenu dentro
          ExpansionTile(
            //textColor: Colors.green,
            title: const Text('Citas'),
            leading: const Icon(
              Icons.calendar_month,
              color: Colors.green,
            ),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.access_time_sharp,
                  color: Colors.green,
                ),
                title: const Text('Ver horarios registrados'),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, 'horariosAdd');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.edit_calendar,
                  color: Colors.green,
                ),
                title: const Text('Agendar cita'),
                onTap: () {
                  Navigator.pushNamed(context, 'agendarCita');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.list_alt,
                  color: Colors.green,
                ),
                title: const Text('Ver citas pendientes'),
                onTap: () {
                  Navigator.pushNamed(context, 'verCitasAg');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: const Text('Ver citas atendidas'),
                onTap: () {
                  Navigator.pushNamed(context, 'verCitasAt');
                },
              ),
            ],
          ),
          //aqui termina el nuevo codigo
          const Divider(),
          ExpansionTile(
            title: const Text('Solicitudes de adopción'),
            leading: const Icon(
              Icons.assignment,
              color: Colors.green,
            ),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.inventory,
                  color: Colors.green,
                ),
                title: const Text('Solicitudes Pendientes'),
                onTap: () {
                  // Navigator.pushReplacementNamed(context, 'enviarMail');
                  Navigator.pushNamed(context, 'solicitudes');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: const Text('Solicitudes Aprobadas'),
                onTap: () {
                  Navigator.pushNamed(context, 'solicitudesAprobadas');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.clear,
                  color: Colors.green,
                ),
                title: const Text('Solicitudes Rechazadas'),
                onTap: () {
                  Navigator.pushNamed(context, 'solicitudesRechazadas');
                },
              ),
            ],
          ),
          const Divider(),
          // ExpansionTile(
          //   title: Text('Seguimiento'),
          //   children: [
          ListTile(
            leading: const Icon(
              Icons.manage_search_sharp,
              color: Colors.green,
            ),
            title: const Text('Seguimiento'),
            onTap: () {
              Navigator.pushNamed(context, 'seguimientoPrincipal');
            },
          ),
          const Divider(),
          ExpansionTile(
            title: const Text('Donaciones'),
            leading: const Icon(
              Icons.favorite,
              color: Colors.green,
            ),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.green,
                ),
                title: const Text('Agregar donación recibida'),
                onTap: () {
                  Navigator.pushNamed(context, 'donacionesInAdd');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.list_alt_rounded,
                  color: Colors.green,
                ),
                title: const Text('Donaciones recibidas'),
                onTap: () {
                  Navigator.pushNamed(context, 'verDonacionesInAdd');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add_circle_outline_sharp,
                  color: Colors.green,
                ),
                title: const Text('Agregar donación saliente'),
                onTap: () {
                  Navigator.pushNamed(context, 'donacionesOutAdd');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.list_alt_rounded,
                  color: Colors.green,
                ),
                title: const Text('Donaciones salientes'),
                onTap: () {
                  Navigator.pushNamed(context, 'verDonacionesOutAdd');
                },
              ),
            ],
          ),
          const Divider(),
          rol == 'SuperAdministrador'
              ? ListTile(
                  leading: const Icon(
                    Icons.person_add_alt_outlined,
                    color: Colors.green,
                  ),
                  title: const Text('Registrar administrador'),
                  onTap: () {
                    //Navigator.pop(context);
                    Navigator.pushNamed(context, 'registro');
                  },
                )
              : const SizedBox(),
          //rol == 'Administrador'
          ListTile(
            leading: const Icon(
              Icons.app_registration,
              color: Colors.green,
            ),
            title: const Text('Restablecer contraseña'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushNamed(context, 'cambiarContrasena');
            },
          ),
          //: const SizedBox(),

          const Padding(padding: EdgeInsets.only(top: 30.0)),
          const Text(
            '2022 Versión: 0.0.1',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
