import 'dart:html';

import 'package:admin_web_v1/models/formulario_datosPersonales_model.dart';
import 'package:admin_web_v1/models/formulario_domicilio_model.dart';
import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/models/formulario_relacionAnimal_model.dart';
import 'package:admin_web_v1/models/formulario_situacionFam_model.dart';
import 'package:admin_web_v1/providers/formularios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class SolicitudesMainPage extends StatefulWidget {
  const SolicitudesMainPage({Key? key}) : super(key: key);

  @override
  State<SolicitudesMainPage> createState() => _SolicitudesMainPageState();
}

class _SolicitudesMainPageState extends State<SolicitudesMainPage> {
  FormulariosProvider formulariosProvider = FormulariosProvider();
  FormulariosModel formularios = FormulariosModel();
  DatosPersonalesModel datosC = DatosPersonalesModel();
  SitFamiliarModel situacionF = SitFamiliarModel();
  DomicilioModel domicilio = DomicilioModel();
  RelacionAnimalesModel relacionA = RelacionAnimalesModel();
  final userProvider = UsuarioProvider();
  File? foto;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Object? formulariosData = ModalRoute.of(context)!.settings.arguments;
    if (formulariosData != null) {
      formularios = formulariosData as FormulariosModel;
      print(formularios.id);
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 234, 235, 233),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Datos de la solicitud"),
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
                      child: Text("Cerrar Sesion"),
                    )
                  ]),
        ],
      ),
      drawer: const MenuWidget(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 850,
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Posible adoptante para:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 12.0)),
                  //Divider(),
                  _mostrarFoto(),
                  // Divider(),
                  _mostrarNombreAn(),
                  const Divider(
                    color: Colors.transparent,
                  ),

                  _mostrarFecha(),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  // _crearEstadoCita(),
                  //Text("Cita Atendida"),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                child: _botonDatosPer(),
                              ),
                              const Text('Datos personales'),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                child: _botonSituacionFam(),
                              ),
                              const Text('Situacion familiar')
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                child: _botonDomicilio(),
                              ),
                              const Text('Domicilio')
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                child: _botonRelacionAnim(),
                              ),
                              const Text('Relacion con animales')
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  //_botonPDF(),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 12.0)),

                  _crearBotonPDF(),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 12.0)),
                  _crearBotonObservaciones()
                  //_crearBoton(),

                  // _crearDisponible(),
                ],
              ),
            ),
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
        Navigator.pushNamed(context, 'login');
    }
  }

  showCitas1() async {
    datosC = await formulariosProvider.cargarDPId(
        formularios.id, formularios.idDatosPersonales);
    //setState(() {
    return datosC;
  }

  Widget _mostrarFecha() {
    return TextFormField(
      readOnly: true,
      initialValue: formularios.fechaIngreso,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Fecha de solicitud:',
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.date_range_outlined,
          color: Colors.purple,
        ),
      ),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  Widget _crearNombreClient() {
    return TextFormField(
      readOnly: true,
      initialValue: formularios.nombreClient,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Nombre',
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.person,
          color: Colors.purple,
        ),
      ),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  Widget _mostrarNombreAn() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        readOnly: true,
        initialValue: formularios.animal!.nombre,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          border: InputBorder.none,
          //labelText: 'Nombre Mascota:',
          //icon: Icon(
          //  Icons.pets,
          //  color: Colors.purple,
          // )
        ),
        //onSaved: (value) => animal.nombre = value!,
        //},
      ),
    );
  }

  Widget _mostrarFoto() {
    if (formularios.animal!.fotoUrl != '') {
      return FadeInImage(
        image: NetworkImage(formularios.animal!.fotoUrl),
        placeholder: const AssetImage('assets/jar-loading.gif'),
        height: 270.0, //300
        width: 270.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset('assets/no-image.png');
    }
  }

  Widget _botonDatosPer() {
    //var idForm = formularios.id;
    //var idD = formularios.idDatosPersonales;
    //FormulariosModel form1 = formularios;
    return Ink(
        decoration: BoxDecoration(
            //backgroundBlendMode: ,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.purple[600],
            boxShadow: const [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: const Icon(
            Icons.person,
          ),
          iconSize: 80,
          color: Colors.purple[300],
          onPressed: () async {
            // Navigator.pushNamed(context, 'datosPersonales',
            //     arguments: [idForm, idD]);

            datosC = await formulariosProvider.cargarDPId(
                formularios.id, formularios.idDatosPersonales);
            situacionF = await formulariosProvider.cargarSFId(
                formularios.id, formularios.idSituacionFam);
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);

            Navigator.pushNamed(context, 'datosPersonales', arguments: {
              'datosper': datosC,
              'sitfam': situacionF,
              'domicilio': domicilio,
              'formulario': formularios,
              'relacionAn': relacionA
            });
          },
        ));
  }

  Widget _botonSituacionFam() {
    return Ink(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Color.fromARGB(255, 92, 216, 97),
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: const Icon(
            Icons.people,
          ),
          iconSize: 80,
          color: Colors.orange[300],
          onPressed: () async {
            situacionF = await formulariosProvider.cargarSFId(
                formularios.id, formularios.idSituacionFam);
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);

            Navigator.pushNamed(context, 'situacionFam', arguments: {
              'datosper': datosC,
              'situacionF': situacionF,
              'domicilio': domicilio,
              'relacionAn': relacionA,
              'formulario': formularios
            });
          },
        ));
  }

  Widget _botonDomicilio() {
    return Ink(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.blueGrey[200],
            boxShadow: const [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: const Icon(
            Icons.house,
          ),
          iconSize: 80,
          color: Colors.blueGrey[700],
          onPressed: () async {
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);

            Navigator.pushNamed(context, 'domicilio', arguments: {
              'domicilio': domicilio,
              'relacionAn': relacionA,
              'formulario': formularios
            });
          },
        ));
  }

  Widget _botonRelacionAnim() {
    return Ink(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.lightBlue[300],
            boxShadow: const [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: const Icon(
            Icons.pets,
          ),
          iconSize: 80,
          color: Colors.blueAccent,
          onPressed: () async {
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);

            Navigator.pushNamed(context, 'relacionAnim', arguments: {
              'relacionAn': relacionA,
              'formulario': formularios
            });
          },
        ));
  }

  Widget botonPDF() {
    return Ink(
        decoration: BoxDecoration(
            //backgroundBlendMode: ,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.purple[600],
            boxShadow: const [
              BoxShadow(
                  color: Colors.purple,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: const Icon(
            Icons.picture_as_pdf,
          ),
          iconSize: 100,
          color: Colors.purple[300],
          onPressed: () async {
            // Navigator.pushNamed(context, 'datosPersonales',
            //     arguments: [idForm, idD]);
            datosC = await formulariosProvider.cargarDPId(
                formularios.id, formularios.idDatosPersonales);
            situacionF = await formulariosProvider.cargarSFId(
                formularios.id, formularios.idSituacionFam);
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);
            Navigator.pushNamed(context, 'crearPDF', arguments: {
              'datosper': datosC,
              'sitfam': situacionF,
              'domicilio': domicilio,
              'formulario': formularios,
              'relacionAn': relacionA
            });
          },
        ));
  }

  Widget _crearBotonPDF() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.green;
          }),
        ),
        label: const Text(
          'Generar PDF',
          style: TextStyle(fontSize: 17),
        ),
        icon: const Icon(
          Icons.picture_as_pdf,
          size: 40,
        ),
        autofocus: true,
        onPressed: () async {
          datosC = await formulariosProvider.cargarDPId(
              formularios.id, formularios.idDatosPersonales);
          situacionF = await formulariosProvider.cargarSFId(
              formularios.id, formularios.idSituacionFam);
          domicilio = await formulariosProvider.cargarDomId(
              formularios.id, formularios.idDomicilio);
          relacionA = await formulariosProvider.cargarRAId(
              formularios.id, formularios.idRelacionAn);
          Navigator.pushNamed(context, 'crearPDF', arguments: {
            'datosper': datosC,
            'sitfam': situacionF,
            'domicilio': domicilio,
            'formulario': formularios,
            'relacionAn': relacionA
          });
        });
  }

  Widget _crearBotonObservaciones() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.green;
          }),
        ),
        label: const Text(
          'Respuesta y observaciones',
          style: TextStyle(fontSize: 17),
        ),
        icon: const Icon(
          Icons.question_answer,
          size: 40,
        ),
        autofocus: true,
        onPressed: () async {
          // datosC = await formulariosProvider.cargarDPId(
          //     formularios.id, formularios.idDatosPersonales);
          // situacionF = await formulariosProvider.cargarSFId(
          //     formularios.id, formularios.idSituacionFam);
          // domicilio = await formulariosProvider.cargarDomId(
          //     formularios.id, formularios.idDomicilio);
          // relacionA = await formulariosProvider.cargarRAId(
          //     formularios.id, formularios.idRelacionAn);
          Navigator.pushNamed(context, 'observacionSolicitud',
              arguments: formularios
              //'datosper': datosC,
              // 'sitfam': situacionF,
              //'domicilio': domicilio,
              //'formulario': formularios,
              //'relacionAn': relacionA
              );
        });
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.deepPurple;
          }),
        ),
        label: const Text('Guardar'),
        icon: const Icon(Icons.save),
        autofocus: true,
        onPressed: () {
          Navigator.pushNamed(context, 'bienvenida');
        }
        // onPressed: () {
        //   print(animal.id);
        // },
        );
  }

  void botonDatosPersonales(BuildContext context) {
    Navigator.pushNamed(context, 'datosPersonales', arguments: {
      'datosper': datosC,
      'sitfam': situacionF,
      'domicilio': domicilio,
      'formulario': formularios,
      'relacionAn': relacionA
    });
  }
}
