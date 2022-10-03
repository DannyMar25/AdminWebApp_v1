import 'package:admin_web_v1/models/formulario_principal_model.dart';
import 'package:admin_web_v1/models/formulario_relacionAnimal_model.dart';
import 'package:admin_web_v1/providers/formularios_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class RelacionAnimalPage extends StatefulWidget {
  const RelacionAnimalPage({Key? key}) : super(key: key);

  @override
  State<RelacionAnimalPage> createState() => _RelacionAnimalPageState();
}

class _RelacionAnimalPageState extends State<RelacionAnimalPage> {
  FormulariosModel formularios = FormulariosModel();
  //DatosPersonalesModel datosA = new DatosPersonalesModel();
  RelacionAnimalesModel relaciones = RelacionAnimalesModel();
  final formKey = GlobalKey<FormState>();
  final formulariosProvider = FormulariosProvider();
  //final horariosProvider = new HorariosProvider();
  // final animalesProvider = new AnimalesProvider();
  final userProvider = UsuarioProvider();
  // var idForm;
  // var idD;

  @override
  void initState() {
    super.initState();
    //showCitas();
  }

  @override
  Widget build(BuildContext context) {
    // final Object? formulariosData = ModalRoute.of(context)!.settings.arguments;
    // if (formulariosData != null) {
    //   relaciones = formulariosData as RelacionAnimalesModel;
    //   print(relaciones.id);
    // }
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    //if (dat == arg['datosper']) {
    //print(formularios.idDatosPersonales);
    relaciones = arg['relacionAn'] as RelacionAnimalesModel;
    //print(relaciones.id);
    formularios = arg['formulario'] as FormulariosModel;
    //print(formularios.id);
    return Scaffold(
      backgroundColor: const Color.fromARGB(223, 248, 248, 245),
      appBar: AppBar(
        title: const Text('Relación con los animales'),
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
                      child: Text("Cerrar Sesión"),
                    )
                  ]),
        ],
      ),
      drawer: const MenuWidget(),
      body: Stack(
        children: [
          //Background(),
          SingleChildScrollView(
            child: Flexible(
              fit: FlexFit.loose,
              child: Center(
                child: Container(
                  width: 850,
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'Liste sus dos últimas mascotas',
                            style: TextStyle(
                              fontSize: 22,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.blueGrey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const Divider(),
                        Align(
                          alignment: Alignment.topCenter,
                          child: DataTable(
                            sortColumnIndex: 2,
                            columnSpacing: 25,
                            sortAscending: false,
                            columns: const [
                              DataColumn(label: Text("Tipo")),
                              DataColumn(label: Text("Nombre")),
                              DataColumn(label: Text("Sexo")),
                              DataColumn(label: Text("Esterilizado")),
                            ],
                            rows: [
                              DataRow(selected: true, cells: [
                                DataCell(_mostrarTipo1()),
                                DataCell(_mostrarNombre1()),
                                DataCell(_mostrarSexo1()),
                                DataCell(_mostrarEsteriliza1())
                              ]),
                              DataRow(cells: [
                                DataCell(_mostrarTipo2()),
                                DataCell(_mostrarNombre2()),
                                DataCell(_mostrarSexo2()),
                                DataCell(_mostrarEsteriliza2())
                              ]),
                            ],
                          ),
                        ),
                        const Divider(),
                        const Divider(color: Colors.transparent),

                        const Text(
                          '¿Dónde está ahora? Si falleció, perdió o está en otro lugar, indique la causa.',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarUbicMascota(),
                        const Divider(color: Colors.transparent),

                        const Text(
                          '¿Por qué desea adoptar una mascota?',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarDeseaAdop(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          'Si por algún motivo tuviera que cambiar de domicilio, ¿Qué pasaría con su mascota?',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarCambioDomi(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          'Con relación a la anterior pregunta ¿Qué pasaría si los dueños de la nueva casa no aceptacen mascotas?',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarRelNuevaCasa(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          'Si Ud. debe salir de viaje más de un día, la mascota:',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarViajeMasc(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          '¿Cuánto tiempo en el día pasará sola la mascota?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarTiempoSola(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          '¿Dónde pasará durante el día y la noche?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarDiaNoche(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          '¿Dónde dormirá la mascota?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarDondeDormir(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          '¿Dónde hará sus necesidades?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarDondeNecesidad(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          '¿Qué comerá habitualmente la mascota?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarComidaMas(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          '¿Cuántos años cree que vive un perro promedio?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarPromedioVida(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          'Si su mascota se enferma, usted:',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarMascotaEnferma(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          '¿Quién será el responsable y se hará cargo de cubrir los gastos de la mascota?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarResponsableMas(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          'Estime cuánto dinero podría gastar en su mascota mensualmente',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarDineroGasto(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          '¿Cuenta con los recursos para cubrir los gastos veterinarios del animal de compañía?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarRecursosVet(),
                        const Divider(color: Colors.transparent),
                        const Divider(),
                        const Text(
                          '¿Está de acuerdo en que se haga una visita periódica a su domicilio para ver como se encuentra el adoptado?',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                        const Divider(),
                        _mostrarVisitaDomicilio(),
                        _mostrarJustificacion1(),
                        const Divider(),
                        const Text(
                          '¿Está de acuerdo en que la  mascota sea esterilizada?',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                        const Divider(),
                        _mostrarAcuerdoEst(),
                        _mostrarJustificacion2(),
                        const Divider(),
                        const Text(
                          '¿Conoce usted los beneficios de la esterilización?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarBeneficios(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          '¿Según usted que es tenencia responsable?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarTenencia(),
                        const Divider(color: Colors.transparent),
                        //pregunta de ordenanza
                        const Text(
                          '¿Está Ud. informado y conciente sobre la ordenanza municipal sobre la tenencia responsable de mascotas?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarOrdenMuni(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          '¿La adopción fue compartida con su familia?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarAdopcionFam(),
                        const Divider(color: Colors.transparent),
                        const Text(
                          'Su familia está:',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        _mostrarFamilia(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _botonAtras(),
                            _botonSiguiente(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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

  Widget _mostrarTipo1() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.tipoMs1,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarTipo2() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.tipoMs2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarNombre1() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.nombreMs1,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarNombre2() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.nombreMs2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarSexo1() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.sexoMs1,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarSexo2() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.sexoMs2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarEsteriliza1() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.estMs1,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarEsteriliza2() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.estMs2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarUbicMascota() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.ubicMascota,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "Algun familiar espera un bebe?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarDeseaAdop() {
    return TextFormField(
      maxLines: 2,
      readOnly: true,
      initialValue: relaciones.deseoAdop,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "Algun familiar espera un bebe?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarCambioDomi() {
    return TextFormField(
      maxLines: 1,
      readOnly: true,
      initialValue: relaciones.cambioDomi,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "Algun familiar espera un bebe?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarRelNuevaCasa() {
    return TextFormField(
      maxLines: 1,
      readOnly: true,
      initialValue: relaciones.relNuevaCasa,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "Si usted debe salir de viaje mas de un dia, la mascota:",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarViajeMasc() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.viajeMascota,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "Si usted debe salir de viaje mas de un dia, la mascota:",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarTiempoSola() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.tiempoSolaMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Cuánto tiempo en el dia pasará sola la mascota?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarDiaNoche() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.diaNocheMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Dónde pasará durante el día y la noche?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarDondeDormir() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.duermeMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Dónde dormirá la mascota?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarDondeNecesidad() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.necesidadMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Dónde hará sus necesidades?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarComidaMas() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.comidaMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Qué comerá habitualmente la mascota?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarPromedioVida() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.promedVida,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Cuantos años cree que vive un perro promedio?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarMascotaEnferma() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.enfermedadMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "Si su mascota se enferma usted:",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarResponsableMas() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.responGastos,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Dónde hará sus necesidades?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarDineroGasto() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.dineroMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarRecursosVet() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.recursoVet,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Dónde hará sus necesidades?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarVisitaDomicilio() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.visitaPer,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Dónde hará sus necesidades?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarJustificacion1() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.justificacion1,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: "¿Por qué?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarAcuerdoEst() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.acuerdoEst,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Dónde hará sus necesidades?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarJustificacion2() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.justificacion2,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: "¿Por qué?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarBeneficios() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.benefEst,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Conoce usted los beneficios de la esterilización?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarTenencia() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.tenenciaResp,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Según usted que es tenecia responsable?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarOrdenMuni() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.ordenMuni,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿Conoce usted los beneficios de la esterilización?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarAdopcionFam() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.adCompart,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "¿La adopción fue compartida con su familia?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarFamilia() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.famAcuerdo,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        //labelText: "Su familia esta:",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _botonSiguiente() {
    return Ink(
        padding: const EdgeInsets.only(left: 50.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_right_sharp,
          ),
          iconSize: 100,
          color: Colors.green[400],
          onPressed: () async {
            Navigator.pushNamed(context, 'observacionSolicitud',
                arguments: formularios);
          },
        ));
  }

  Widget _botonAtras() {
    return Ink(
        padding: const EdgeInsets.only(left: 50.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          padding: const EdgeInsets.only(right: 20),
          //tooltip: 'Siguiente',
          icon: const Icon(Icons.arrow_left_sharp),
          iconSize: 100,
          color: Colors.green[400],
          onPressed: () async {
            Navigator.pop(context);
          },
        ));
  }
}
