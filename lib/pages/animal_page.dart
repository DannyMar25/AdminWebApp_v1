import 'dart:html';
import 'dart:typed_data';

import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart' as utils;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
//import 'package:firebase_core/firebase_core.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({Key? key}) : super(key: key);

  @override
  _AnimalPageState createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animalProvider = AnimalesProvider();
  final userProvider = UsuarioProvider();

  AnimalModel animal = AnimalModel();
  FirebaseStorage storage = FirebaseStorage.instance;
  // bool _guardando = false;
  File? foto;
  late XFile image;
  Uint8List webImage = Uint8List(8);
  String? fotoUrl;
  //variables usadas para desplegar opciones de tamaño
  final List<String> _items = ['Pequeño', 'Mediano', 'Grande'].toList();
  String? _selection;
  final List<String> _items1 = ['Macho', 'Hembra'].toList();
  String? _selection1;
  final List<String> _items2 =
      ['Cachorro', 'Joven', 'Adulto', 'Anciano', 'Geriátrico'].toList();
  String? _selection2;
  final List<String> _items3 = ['Canina', 'Felina'].toList();
  String? _selection3;
  final List<String> _items4 = ['Si', 'No'].toList();
  String? _selection4;
  int? edadN;
  bool isDisable = false;
  bool editFoto = false;
  String campoVacio = 'Por favor, llena este campo';
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Object? animData = ModalRoute.of(context)!.settings.arguments;
    if (animData != null) {
      animal = animData as AnimalModel;
      //print(animal.id);
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Animal'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          // IconButton(
          //   icon: const Icon(Icons.camera_alt),
          //   onPressed: _tomarFoto,
          // ),
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: const Icon(Icons.account_circle),
              itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Ayuda"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Cerrar Sesión"),
                    )
                  ]),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // width: 850,
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          _mostrarFoto(),
                          _crearEspecie(),
                          _crearNombre(),
                          _crearSexo(),
                          Row(children: [_crearEdad(), infoEtapa()]),
                          // _crearEdad(),
                          _crearTemperamento(),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    const Padding(padding: EdgeInsets.only(right: 30.0)),
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          _crearPeso(),
                          _crearTamanio(),
                          _crearColor(),
                          _crearRaza(),
                          _crearEsterilizado(),
                          _crearCaracteristicas(),
                          // _crearDisponible(),
                          //_crearBoton(),
                          const Divider(
                            color: Colors.transparent,
                          ),
                          _buildChild()
                        ],
                      ),
                    )
                  ],
                ),
              ],
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

  Widget _crearEspecie() {
    final dropdownMenuOptions = _items3.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Especie: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButtonFormField<String>(
              hint: Text(animal.especie.toString()),
              //value: _selection3,
              value: seleccionEspecie(),
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection3 = s;
                  animal.especie = s!;
                });
              }),
        ),
      ],
    );
  }

  seleccionEspecie() {
    if (animal.id == '') {
      return _selection3;
    } else {
      return animal.especie.toString();
    }
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: animal.nombre,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Nombre',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      //onSaved: (value) => animal.nombre = value!,
      onChanged: (s) {
        setState(() {
          animal.nombre = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese el nombre de la mascota';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearSexo() {
    final dropdownMenuOptions = _items1.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Seleccione el sexo: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButtonFormField<String>(
              hint: Text(animal.sexo.toString()),
              //value: _selection1,
              value: seleccionSexo(),
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection1 = s;
                  animal.sexo = s!;
                });
              }),
        ),
      ],
    );
  }

  seleccionSexo() {
    if (animal.id == '') {
      return _selection1;
    } else {
      return animal.sexo.toString();
    }
  }

  Widget _crearEdad() {
    final dropdownMenuOptions = _items2.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    return Row(
      children: [
        const Text(
          'Etapa de vida: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButtonFormField<String>(
              hint: Text(animal.etapaVida.toString()),
              //value: _selection2,
              value: seleccionEtapa(),
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection2 = s;
                  animal.etapaVida = s!;
                });
              }),
        ),
      ],
    );
  }

  seleccionEtapa() {
    if (animal.id == '') {
      return _selection2;
    } else {
      return animal.etapaVida.toString();
    }
  }

  Widget infoEtapa() {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Text(
              'Cachorro: 0 a 6 meses\nJoven: 7 meses a 2 años\nAdulto: 2 a 6 años\nAnciano: 7 a 11 años\nGeriátrico: mayor a 12 años',
              // style: TextStyle(
              //   fontWeight: FontWeight.w900,
              //   fontSize: 12.0,
              // ),
            ),
            title: Text('Etapas de vida'),
          ),
        );
      },
      child: Column(
        children: const <Widget>[
          Icon(
            Icons.info_rounded,
            color: Colors.green,
            size: 20.0,
          ),
        ],
      ),
    );
  }

  Widget _crearTemperamento() {
    return TextFormField(
      initialValue: animal.temperamento,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Temperamento',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      //onSaved: (value) => animal.temperamento = value!,
      onChanged: (s) {
        setState(() {
          animal.temperamento = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese el temperamento de la mascota';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPeso() {
    return TextFormField(
      initialValue: animal.peso.toString(),
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: const InputDecoration(
        labelText: 'Peso en Kg.',
        labelStyle: TextStyle(fontSize: 21, color: Colors.black),
      ),
      //onSaved: (s) => animal.peso = double.parse(s!),
      onChanged: (s) {
        setState(() {
          animal.peso = double.parse(s);
        });
      },
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Solo números';
        }
      },
    );
  }

  Widget _crearTamanio() {
    final dropdownMenuOptions = _items.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Seleccione el tamaño: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButtonFormField<String>(
              hint: Text(animal.tamanio.toString()),
              //value: _selection,
              value: seleccionTam(),
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection = s;
                  animal.tamanio = s!;
                });
              }),
        ),
      ],
    );
  }

  seleccionTam() {
    if (animal.id == '') {
      return _selection;
    } else {
      return animal.tamanio.toString();
    }
  }

  Widget _crearColor() {
    return TextFormField(
      initialValue: animal.color,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      decoration: const InputDecoration(
        labelText: 'Color',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      //onSaved: (s) => animal.color = s!,
      onChanged: (s) {
        setState(() {
          animal.color = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese el color de la mascota';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearRaza() {
    return TextFormField(
      initialValue: animal.raza,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      decoration: const InputDecoration(
        labelText: 'Raza',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      //onSaved: (s) => animal.raza = s!,
      onChanged: (s) {
        setState(() {
          animal.raza = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese la raza de la mascota';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearEsterilizado() {
    final dropdownMenuOptions = _items4.map((String item) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: item, child: Text(item))).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Esterilizado: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButtonFormField<String>(
              hint: Text(animal.esterilizado.toString()),
              //value: _selection4,
              value: seleccionEst(),
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection4 = s;
                  animal.esterilizado = s!;
                });
              }),
        ),
      ],
    );
  }

  seleccionEst() {
    if (animal.id == '') {
      return _selection4;
    } else {
      return animal.esterilizado.toString();
    }
  }

  Widget _crearCaracteristicas() {
    return TextFormField(
      maxLines: 6,
      initialValue: animal.caracteristicas,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Características',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      //onSaved: (s) => animal.caracteristicas = s!,
      onChanged: (s) {
        setState(() {
          animal.caracteristicas = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese las características especiales';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
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
        if (editFoto == false) {
          if (formKey.currentState!.validate()) {
            // Si el formulario es válido, queremos mostrar un Snackbar
            SnackBar(
              content: Text('Información ingresada correctamente'),
            );
            _submit();
          } else {
            utils.mostrarAlerta(
                context, 'Asegúrate de que todos los campos estén llenos.');
            // utils.mostrarAlerta(context,
            //     'Asegurate de que todos los campos estan llenos y de haber escogido una foto de tu mascota.');
          }
        } else {
          if (formKey.currentState!.validate()) {
            // Si el formulario es válido, queremos mostrar un Snackbar
            SnackBar(
              content: Text('Información ingresada correctamente'),
            );
            animalProvider.editarAnimal(animal, webImage);
            utils.mostrarAlertaOk(
                context, 'Registro actualizado con éxito.', 'home');
          } else {
            utils.mostrarAlerta(
                context, 'Asegúrate de que todos los campos estén llenos.');
            // utils.mostrarAlerta(context,
            //     'Asegurate de que todos los campos estan llenos y de haber escogido una foto de tu mascota.');
          }
        }
      },
    );
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
          utils.mostrarAlertaBorrar(context,
              '¿Estás seguro de borrar el registro?', animal.id.toString());
        });
  }

  void _submit() async {
    if (animal.id == "") {
      if (webImage.length == 8) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  children: const [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                    Text('Información incorrecta'),
                  ],
                ),
                content: const Text('Ingrese la foto de la mascota.'),
                actions: [
                  TextButton(
                      child: const Text('Aceptar'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              );
            });
      } else {
        animal.estado = "En Adopción";
        animalProvider.crearAnimal1(animal, webImage);
        utils.mostrarAlertaOk(context, 'Registro guardado con éxito.', 'home');
      }

      //mostrarSnackbar('Registro guardado');
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: const [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                  Text('Información correcta'),
                ],
              ),
              content: const Text('¿Desea actualizar la foto de la mascota?'),
              actions: [
                TextButton(
                    child: const Text('Si'),
                    onLongPress: () {
                      editFoto = true;
                    },
                    onPressed: () {
                      editFoto = true;
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      animalProvider.editarAnimalSinFoto(
                          animal, animal.fotoUrl);
                      utils.mostrarAlertaOk(
                          context, 'Registro actualizado con éxito.', 'home');
                    }),
              ],
            );
          });
      // animalProvider.editarAnimal(animal, webImage);
      // //utils.mostrarMensaje(context, 'Registro actualizado');
      // utils.mostrarAlertaOk(context, 'Registro actualizado con éxito', 'home');
    }
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: const Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (editFoto == true) {
      return Image.memory(
        webImage,
        fit: BoxFit.cover,
        height: 230, //300
      );
    } else {
      if (animal.fotoUrl != '') {
        return FadeInImage(
          image: NetworkImage(animal.fotoUrl),
          placeholder: const AssetImage('assets/jar-loading.gif'),
          height: 230, //300
          fit: BoxFit.contain,
        );
      } else {
        if (webImage.length == 8) {
          return Image.asset(
            'assets/no-image.png',
            height: 230, //300
          );
        } else {
          return Image.memory(
            webImage,
            fit: BoxFit.cover,
            height: 230, //300
          );
        }
      }
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _procesarImagen(ImageSource origen) async {
    final ImagePicker picker = ImagePicker();
    if (animal.id == "") {
      editFoto = false;
      image = (await picker.pickImage(source: origen))!;
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
        });
      }
    } else {
      editFoto = true;
      image = (await picker.pickImage(source: origen))!;
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
        });
      }
    }
  }

  Widget _buildChild() {
    if (animal.id == "") {
      return _crearBoton();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _crearBoton(),
          const Padding(padding: EdgeInsets.only(right: 10.0)),
          _crearBotonEliminar()
        ],
      );
    }
  }

  Widget _buildChild1() {
    if (webImage.isNotEmpty) {
      return Image.memory(
        webImage,
        fit: BoxFit.cover,
        height: 300,
      );
    } else {
      return _mostrarFoto();
    }
  }
}
