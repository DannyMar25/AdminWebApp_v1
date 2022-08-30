import 'dart:html';
import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:admin_web_v1/utils/utils.dart' as utils;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({Key? key}) : super(key: key);

  //const ProductoPage({Key? key}) : super(key: key);

  @override
  _AnimalPageState createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  CollectionReference refAn = FirebaseFirestore.instance.collection('animales');
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animalProvider = AnimalesProvider();
  final userProvider = UsuarioProvider();
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseStorage fs = FirebaseStorage.instance;
  String archivoUrl = '';
  String nombreArchivo = '';
  AnimalModel animal = AnimalModel();
  File? foto;
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
      // ignore: avoid_print
      print(animal.id);
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Animal'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_size_select_actual),
            onPressed: () => uploadImage1(),
          ),
          // IconButton(
          //   icon: Icon(Icons.camera_alt),
          //   onPressed: _tomarFoto,
          // ),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearEspecie(),
                _crearNombre(),
                _crearSexo(),
                //_crearEdad(),
                Row(children: [_crearEdad(), infoEtapa()]),
                _crearTemperamento(),
                _crearPeso(),
                _crearTamanio(),
                _crearColor(),
                _crearRaza(),
                _crearEsterilizado(),
                _crearCaracteristicas(),
                // _crearDisponible(),
                //_crearBoton(),
                _buildChild(),
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
              value: _selection3,
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

  Widget _crearNombre() {
    return TextFormField(
      initialValue: animal.nombre,
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
              value: _selection1,
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
              value: _selection2,
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
              value: _selection,
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

  Widget _crearColor() {
    return TextFormField(
      initialValue: animal.color,
      textCapitalization: TextCapitalization.sentences,
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
              value: _selection4,
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
      onPressed: () {
        if (formKey.currentState!.validate() && foto != null) {
          // Si el formulario es válido, queremos mostrar un Snackbar
          const SnackBar(
            content: Text('Información ingresada correctamente'),
          );
          _submit();
        } else {
          utils.mostrarAlerta(context,
              'Asegurate de que todos los campos estan llenos y de haber escogido una foto de tu mascota.');
        }
      },
    );
  }

  void _submit() async {
    if (animal.id == "") {
      animal.estado = "En Adopción";
      var animalAdd = await refAn.add(animal.toJson());
      String path;
      String fec = DateTime.now().toString();
      path = '/animales/${animal.id}/${animal.id! + fec}.jpg';
      uploadImage(onSelected: (file) async {
        var snapshot = await fs.ref().child(path).putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          fotoUrl = downloadUrl;
        });
      });

      await refAn
          .doc(animalAdd.id)
          .update({"fotoUrl": fotoUrl, "id": animalAdd.id});

      //animalProvider.crearAnimal1(animal, fotoUrl!);
      utils.mostrarAlertaOk(context, 'Registro guardado con éxito', 'home');
    } else {
      await refAn.doc(animal.id).update(animal.toJson());
      String path;
      String fec = DateTime.now().toString();
      path = '/animales/${animal.id}/${animal.id! + fec}.jpg';
      uploadImage(onSelected: (file) async {
        var snapshot = await fs.ref().child(path).putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          fotoUrl = downloadUrl;
        });
      });
      await refAn.doc(animal.id).update({"fotoUrl": fotoUrl});
      utils.mostrarAlertaOk(context, 'Registro actualizado con exito', 'home');
      //animalProvider.editarAnimal(animal, fotoUrl!);
    }
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: const Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  uploadToStorage() {
    String path;
    String fec = DateTime.now().toString();
    path = '/animales/${animal.id}/${animal.id! + fec}.jpg';
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs.ref().child(path).putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          fotoUrl = downloadUrl;
        });
      });
    });
  }

  void uploadImage({required Function(File file) onSelected}) {
    FileUploadInputElement uploadInput = FileUploadInputElement()
      ..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  Widget _mostrarFoto() {
    if (animal.fotoUrl != '') {
      return FadeInImage(
        image: NetworkImage(animal.fotoUrl),
        placeholder: const AssetImage('assets/jar-loading.gif'),
        height: 300,
        fit: BoxFit.contain,
      );
    } else {
      // if (foto != null) {
      //   return Image.memory(
      //     file!,
      //     fit: BoxFit.cover,
      //     height: 300.0,
      //   );
      // }
      return Image.asset('assets/no-image.png');
    }
  }
  //}

  uploadImage1() {
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    //FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        // _mostrarFoto();
      });
    });
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
        utils.mostrarAlertaBorrar(context, 'Estas seguro de borrar el registro',
            animal.id.toString());
      },
    );
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
}
