import 'package:admin_web_v1/models/donaciones_model.dart';
import 'package:admin_web_v1/providers/donaciones_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:admin_web_v1/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerDonacionesIn1Page extends StatefulWidget {
  const VerDonacionesIn1Page({Key? key}) : super(key: key);

  @override
  _VerDonacionesIn1PageState createState() => _VerDonacionesIn1PageState();
}

class _VerDonacionesIn1PageState extends State<VerDonacionesIn1Page> {
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
        title: const Text('Registro de donaciones'),
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
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        'Donaciones',
                        style: TextStyle(
                          fontSize: 33,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.blueGrey[300]!,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(),

                      const Divider(),
                      _crearTipoDonacion(),
                      const Divider(),
                      _crearUnidades(),
                      const Divider(),
                      _buildChild(),
                      const Divider(),
                      _crearDescripcion(),
                      const Divider(),
                      _mostrarDisponibilidad(),
                      const Divider(),
                      Text(
                        'Cambiar disponibilidad de la donación',
                        style: TextStyle(
                          fontSize: 18,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1.5
                            ..color = Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Text('Disponible'),
                                _crearCheckBox1()
                              ],
                            ),
                            Row(
                              children: [
                                const Text('No Disponible'),
                                _crearCheckBox2()
                              ],
                            ),
                          ]),
                      const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _crearBoton(),
                          const Padding(padding: EdgeInsets.only(right: 10)),
                          _crearBotonEliminar()
                        ],
                      )
                      //_crearBoton(),
                      // _crearCantidad(),
                    ],
                  )),
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
        const Expanded(
          child: Text(
            'Seleccione el tipo de donación:  ',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        Expanded(
          child: DropdownButton<String>(
            hint: Text(donaciones.tipo.toString()),
            value: _selection,
            items: dropdownMenuOptions,
            onChanged: (s) {
              setState(() {
                _selection = s;

                donaciones.tipo = s!;
                //animal.tamanio = s!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChild() {
    if (_selection == 'Alimento') {
      return _crearPeso();
    } //else {
    //   if (_selection == 'Otros') {
    //     return _crearDonacion();
    //   }
    // }
    return const Text('');
  }

  Widget _crearPeso() {
    //if (_selection == 'Alimento') {
    return TextFormField(
      initialValue: donaciones.peso.toString(),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Ingrese Peso (Kg.):',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
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
      onChanged: (s) {
        setState(() {
          donaciones.descripcion = s;
        });
      },
    );
  }

  Widget _mostrarDisponibilidad() {
    return TextFormField(
      readOnly: true,
      initialValue: donaciones.disponibilidad,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Dsiponibilidad de la donación:',
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.info,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _crearCheckBox1() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        if (isChecked1 == true) {
          return null;
        } else {
          setState(() {
            isChecked = value!;
            //domicilio.planMudanza = "Si";
            donaciones.disponibilidad = "Disponible";
          });
        }
      },
    );
  }

  Widget _crearCheckBox2() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked1,
      onChanged: (bool? value) {
        if (isChecked == true) {
          return null;
        } else {
          setState(() {
            isChecked1 = value!;
            //domicilio.planMudanza = "No";
            donaciones.disponibilidad = "No Disponible";
            //donaciones.cantidad = 0;
          });
        }
      },
    );
  }

  // Widget _crearDonacion() {
  //   return TextFormField(
  //     // initialValue: ,
  //     readOnly: false,
  //     textCapitalization: TextCapitalization.sentences,
  //     decoration: InputDecoration(
  //         labelText: 'Ingrese el tipo de donación:',
  //         labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
  //   );
  // }

  Widget _crearUnidades() {
    return TextFormField(
      initialValue: donaciones.cantidad.toString(),
      //readOnly: false,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
          labelText: 'Ingrese la cantidad:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        setState(() {
          donaciones.cantidad = int.parse(s);
        });
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
        _submit();
      },
    );
  }

  void _submit() async {
    // donaciones.estadoDonacion = 'Entrante';
    //onacionesProvider.editarDisponibilidad(donaciones, disponibilidad);
    donacionesProvider.editarDonacion(donaciones);
    mostrarAlertaOk(
        context, 'Registro actualizado con éxito', 'verDonacionesInAdd');
    //mostrarSnackbar('Registro guardado');
    //Navigator.pushNamed(context, 'verDonacionesInAdd');
  }

  Widget _crearBotonEliminar() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.green;
        }),
      ),
      label: const Text('Eliminar'),
      icon: const Icon(Icons.delete),
      autofocus: true,
      onPressed: () {
        donacionesProvider.borrarDonacion(donaciones.id);
        mostrarAlertaOk(
            context, 'Registro eliminado con éxito', 'verDonacionesInAdd');
      },
    );
  }
}
