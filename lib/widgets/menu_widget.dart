import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Icons.pages,
              color: Colors.green,
            ),
            title: const Text('Ver mascotas registradas'),
            onTap: () => Navigator.pushReplacementNamed(context, 'home'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.app_registration,
              color: Colors.green,
            ),
            title: const Text('Registrar nueva mascota'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'animal');
            },
          ),

          const Divider(),
          //Creacion de un submenu dentro
          ExpansionTile(
            title: const Text('Citas'),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                title: const Text('Agregar horarios de visitas'),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, 'citasAdd'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.app_registration,
                  color: Colors.green,
                ),
                title: const Text('Horarios registrados'),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, 'horariosAdd');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.list_alt,
                  color: Colors.green,
                ),
                title: const Text('Agendar citas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'agendarCita');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.list_alt,
                  color: Colors.green,
                ),
                title: const Text('Ver citas pendientes'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'verCitasAg');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: const Text('Ver citas atendidas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'verCitasAt');
                },
              ),
            ],
            leading: const Icon(
              Icons.meeting_room,
              color: Colors.green,
            ),
          ),
          //aqui termina el nuevo codigo
          const Divider(),
          ExpansionTile(
            title: const Text('Solicitudes de adopcion'),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.inventory,
                  color: Colors.green,
                ),
                title: const Text('Solicitudes Pendientes'),
                onTap: () {
                  // Navigator.pushReplacementNamed(context, 'enviarMail');
                  Navigator.pushReplacementNamed(context, 'solicitudes');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: const Text('Solicitudes Aprobadas'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, 'solicitudesAprobadas');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.clear,
                  color: Colors.green,
                ),
                title: const Text('Solicitudes Rechazadas'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, 'solicitudesRechazadas');
                },
              ),
            ],
            leading: const Icon(
              Icons.assignment,
              color: Colors.green,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.assignment,
              color: Colors.green,
            ),
            title: const Text('Seguimiento'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'seguimientoPrincipal');
            },
          ),

          const Divider(),
          ExpansionTile(
            title: const Text('Donaciones'),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                title: const Text('Registrar donaciones recibidas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'donacionesInAdd');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: const Text('Ver donaciones recibidas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'verDonacionesInAdd');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                title: const Text('Registrar donaciones salientes'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'donacionesOutAdd');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: const Text('Ver donaciones salientes'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, 'verDonacionesOutAdd');
                },
              ),
            ],
            leading: const Icon(
              Icons.assignment,
              color: Colors.green,
            ),
          ),
          const Divider(),

          // ListTile(
          //   leading: Icon(
          //     Icons.room,
          //     color: Colors.green,
          //   ),
          //   title: Text('Ver ubicacion'),
          //   onTap: () {
          //     //Navigator.pop(context);
          //     Navigator.pushReplacementNamed(context, 'ubicacion');
          //   },
          // ),
          // Divider(),
          ListTile(
            leading: const Icon(
              Icons.app_registration,
              color: Colors.green,
            ),
            title: const Text('Registrar administrador'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'registro');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.app_registration,
              color: Colors.green,
            ),
            title: const Text('Inicio'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'home');
            },
          ),
        ],
      ),
    );
  }
}
