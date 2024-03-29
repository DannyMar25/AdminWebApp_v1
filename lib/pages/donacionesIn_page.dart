import 'package:admin_web_v1/models/donaciones_model.dart';
import 'package:admin_web_v1/providers/donaciones_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IngresoDonacionesInPage extends StatefulWidget {
  const IngresoDonacionesInPage({Key? key}) : super(key: key);

  @override
  _IngresoDonacionesInPageState createState() =>
      _IngresoDonacionesInPageState();
}

class _IngresoDonacionesInPageState extends State<IngresoDonacionesInPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final donacionesProvider = DonacionesProvider();
  final userProvider = UsuarioProvider();
  DonacionesModel donaciones = DonacionesModel();
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higiénicos', 'Otros'].toList();
  String? _selection;
  bool isChecked = false;
  bool isChecked1 = false;
  String disponibilidad = '';
  String campoVacio = 'Por favor, llena este campo';
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Object? donacData = ModalRoute.of(context)!.settings.arguments;
    if (donacData != null) {
      donaciones = donacData as DonacionesModel;
      //print(donaciones.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar donación recibida '),
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
            child: Center(
              child: Container(
                width: 850,
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          'Datos de donación recibida',
                          style: TextStyle(
                            fontSize: 30,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.blueGrey[300]!,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const Divider(
                          height: 50,
                          color: Colors.transparent,
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                        _crearTipoDonacion(),
                        const Divider(color: Colors.transparent),
                        _crearUnidades(),
                        const Divider(color: Colors.transparent),
                        _buildChild(),
                        const Divider(color: Colors.transparent),
                        _crearDescripcion(),
                        const Divider(color: Colors.transparent),
                        _crearBoton(),
                        // _crearCantidad(),
                      ],
                    )),
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

  Widget _crearTipoDonacion() {
    final dropdownMenuOptions = _items.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Tipo de donación:  ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 200.0,
          child: DropdownButtonFormField<String>(
              hint: Text(donaciones.tipo.toString()),
              value: _selection,
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection = s;
                  donaciones.tipo = s!;
                });
              }),
        ),
      ],
    );
  }

  Widget _buildChild() {
    if (_selection == 'Alimento') {
      return _crearPeso();
    }
    return const Text('');
  }

  Widget _crearPeso() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Ingrese Peso (Kg.):',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      validator: (value) {
        if (isNumeric(value!)) {
          return null;
        } else {
          return 'Solo números';
        }
      },
      onChanged: (s) {
        setState(() {
          donaciones.peso = double.parse(s);
        });
      },
    );
    //}
  }

  Widget _crearDescripcion() {
    return TextFormField(
      initialValue: donaciones.descripcion,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          labelText: 'Descripción:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese una descripción';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
      onChanged: (s) {
        setState(() {
          donaciones.descripcion = s;
        });
      },
    );
  }

  Widget _crearUnidades() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
          labelText: 'Ingrese la cantidad (Unidades):',
          labelStyle: TextStyle(fontSize: 20, color: Colors.black)),
      onChanged: (s) {
        setState(() {
          donaciones.cantidad = int.parse(s);
        });
      },
      validator: (value) {
        if (isNumeric(value!)) {
          return null;
        } else {
          return 'Solo números';
        }
      },
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.green;
        }),
      ),
      label: const Text('Guardar'),
      icon: const Icon(Icons.save),
      autofocus: true,
      //onPressed: (_guardando) ? null : _submit,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // Si el formulario es válido, queremos mostrar un Snackbar
          const SnackBar(
            content: Text('Información ingresada correctamente'),
          );
          _submit();
        } else {
          mostrarAlerta(
              context, 'Asegurate de que todos los campos esten llenos.');
        }
      },
    );
  }

  void _submit() async {
    if (donaciones.id == "") {
      donaciones.estadoDonacion = 'Entrante';
      donaciones.disponibilidad = "Disponible";
      donaciones.fechaIngreso =
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
      donacionesProvider.crearDonacion(donaciones);
      mostrarAlertaOk(
          context, 'Registro guardado con éxito.', 'verDonacionesInAdd');
    } else {
      donaciones.estadoDonacion = 'Entrante';
      donacionesProvider.editarDisponibilidad(donaciones, disponibilidad);
      donacionesProvider.editarDonacion(donaciones);
      mostrarAlertaOk(
          context, 'Registro actualizado con éxito.', 'verDonacionesInAdd');
    }
    //mostrarSnackbar('Registro guardado');
    // Navigator.pushNamed(context, 'verDonacionesInAdd');
  }
}
