import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/providers/usuario_provider.dart';
import 'package:admin_web_v1/utils/utils.dart';
import 'package:flutter/material.dart';

class BusquedaPage extends StatefulWidget {
  const BusquedaPage({Key? key}) : super(key: key);

  @override
  State<BusquedaPage> createState() => _BusquedaPageState();
}

class _BusquedaPageState extends State<BusquedaPage> {
  final formKey = GlobalKey<FormState>();
  AnimalModel animal = AnimalModel();
  final List<String> _especie = ['Canina', 'Felina'].toList();
  String? _selection;
  final List<String> _sexo = ['Macho', 'Hembra'].toList();
  String? _selection1;
  final List<String> _etapaVida = [
    'Cachorro',
    'Joven',
    'Adulto',
    'Anciano',
    'Geriátrico',
  ].toList();
  String? _selection2;
  final List<String> _tamanio = ['Pequeño', 'Mediano', 'Grande'].toList();
  String? _selection3;

  bool isChecked1 = false;
  bool isChecked2 = false;

  final List<String> _estadoAdopcion =
      ['Pendiente', 'En Adopción', 'Adoptado'].toList();
  String? _selection4;

  final userProvider = UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'home');
          },
        ),
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
        title: const Text('Búsqueda de mascotas'),
      ),
      body: Stack(
        children: [
          //Background(),
          SingleChildScrollView(
            child: Flexible(
              fit: FlexFit.loose,
              child: Container(
                //padding: EdgeInsets.all(15.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        //Padding(padding: EdgeInsets.only(top: 1.0)),
                        const SizedBox(
                          height: 170,
                          child: Image(
                            image: AssetImage("assets/dog_an6.gif"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        const Text('Buscador',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                            )),
                        const Padding(padding: EdgeInsets.only(bottom: 10.0)),
                        const Text(
                          'Selecciona la o las categorías de tu gusto y te mostraremos los resultados.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        //Divider(),
                        //Text('Especie:'),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              spacing: 10,
                              children: const [
                                Expanded(
                                  child: SizedBox(
                                      height: 80,
                                      child: Image(
                                          image: AssetImage(
                                              "assets/dog_an1.gif"))),
                                ),
                                Expanded(
                                  child: SizedBox(
                                      height: 80,
                                      child: Image(
                                          image: AssetImage(
                                              "assets/cat_im2.jpg"))),
                                ),
                              ],
                            )
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        _seleccionarEspecie(),

                        const Padding(padding: EdgeInsets.only(bottom: 30.0)),
                        _seleccionarEstadoAdopcion(),
                        const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              spacing: 20,
                              children: const [
                                Expanded(
                                  child: SizedBox(
                                      height: 50,
                                      child: Image(
                                          image: AssetImage(
                                              "assets/huella_azul3.png"))),
                                ),
                                Expanded(
                                  child: SizedBox(
                                      height: 50,
                                      child: Image(
                                          image: AssetImage(
                                              "assets/huella_rosa3.png"))),
                                )
                              ],
                            )
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        _seleccionarSexo(),
                        const Padding(padding: EdgeInsets.only(bottom: 25.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Expanded(
                              child: SizedBox(
                                  height: 150.0,
                                  child: Image(
                                      image: AssetImage("assets/pets_4.png"))),
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        _seleccionarEtapaVida(),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     //Padding(padding: EdgeInsets.only(left: 150.0)),
                        //     Expanded(
                        //       child: SizedBox(
                        //           height: 200,
                        //           child: Image(
                        //               image: AssetImage("assets/pets_2.png"))),
                        //     ),
                        //   ],
                        // ),
                        //Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        // _seleccionarTamanio(),
                        buildChild(),
                        const Padding(padding: EdgeInsets.only(bottom: 40.0)),
                        _crearBoton()
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChild() {
    if (_selection == 'Canina') {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              //Padding(padding: EdgeInsets.only(left: 150.0)),
              Expanded(
                child: SizedBox(
                    height: 200,
                    child: Image(image: AssetImage("assets/pets_2.png"))),
              ),
            ],
          ),
          _seleccionarTamanio(),
        ],
      );
    } else {
      return const Text('');
    }
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

  Widget _seleccionarEspecie() {
    final dropdownMenuOptions = _especie
        .map((String especie) =>
            //new DropdownMenuItem<String>(value: item, child: new Text(item)))
            DropdownMenuItem<String>(value: especie, child: Text(especie)))
        .toList();
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        const Text(
          'Seleccione especie:',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            //Se cambio dropdownbutton por dropdownbuttonformfiel y con esto se anadio validator
            child: SizedBox(
              width: 150.0,
              child: DropdownButtonFormField<String>(
                  //hint: Text(animal.tamanio.toString()),
                  value: _selection,
                  items: dropdownMenuOptions,
                  validator: (value) =>
                      value == null ? 'Selecciona una opción' : null,
                  onChanged: (s) {
                    setState(() {
                      _selection = s;
                      //animal.tamanio = s!;
                    });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seleccionarSexo() {
    final dropdownMenuOptions = _sexo.map((String sexo) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: sexo, child: Text(sexo))).toList();
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        const Text(
          'Seleccione género:',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              width: 150.0,
              child: DropdownButtonFormField<String>(
                  //hint: Text(animal.tamanio.toString()),
                  value: _selection1,
                  items: dropdownMenuOptions,
                  validator: (value) =>
                      value == null ? 'Selecciona una opción' : null,
                  onChanged: (s) {
                    setState(() {
                      _selection1 = s;
                      //animal.tamanio = s!;
                    });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seleccionarEtapaVida() {
    final dropdownMenuOptions = _etapaVida.map((String edad) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: edad, child: Text(edad))).toList();
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        const Text(
          'Seleccione etapa:',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              width: 150.0,
              child: DropdownButtonFormField<String>(
                  //hint: Text(animal.tamanio.toString()),
                  value: _selection2,
                  items: dropdownMenuOptions,
                  validator: (value) =>
                      value == null ? 'Selecciona una opción' : null,
                  onChanged: (s) {
                    setState(() {
                      _selection2 = s;
                      //animal.tamanio = s!;
                    });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seleccionarTamanio() {
    final dropdownMenuOptions = _tamanio
        .map((String tamanio) =>
            //new DropdownMenuItem<String>(value: item, child: new Text(item)))
            DropdownMenuItem<String>(value: tamanio, child: Text(tamanio)))
        .toList();
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        const Text(
          'Seleccione tamaño:',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              width: 150.0,
              child: DropdownButtonFormField<String>(
                  //hint: Text(animal.tamanio.toString()),
                  value: _selection3,
                  items: dropdownMenuOptions,
                  // validator: (value) =>
                  //     value == null ? 'Selecciona una opción' : null,
                  onChanged: (s) {
                    setState(() {
                      _selection3 = s;
                      //animal.tamanio = s!;
                    });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seleccionarEstadoAdopcion() {
    final dropdownMenuOptions = _estadoAdopcion.map((String estado) =>
        //new DropdownMenuItem<String>(value: item, child: new Text(item)))
        DropdownMenuItem<String>(value: estado, child: Text(estado))).toList();
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        const Text(
          'Seleccione estado de adopción:',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              width: 150.0,
              child: DropdownButtonFormField<String>(
                  //hint: Text(animal.tamanio.toString()),
                  value: _selection4,
                  items: dropdownMenuOptions,
                  validator: (value) =>
                      value == null ? 'Selecciona una opción' : null,
                  onChanged: (s) {
                    setState(() {
                      _selection4 = s;
                      //animal.tamanio = s!;
                    });
                  }),
            ),
          ),
        ),
      ],
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
      label: const Text('Buscar'),
      icon: const Icon(Icons.search),
      autofocus: true,
      //onPressed: (_guardando) ? null : _submit,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          const SnackBar(
            content: Text('Por favor selecciona una opción.'),
          );
          //_submit();
          buildChild1();
        } else {
          mostrarAlerta(context,
              'Todos los campos deben ser seleccionados. Asegúrate de haber completado todos.');
        }
        //_submit();
      },
    );
  }

  buildChild1() {
    if (_selection == 'Canina') {
      return _submit();
    } else {
      return _submit4();
    }
  }

  void _submit() async {
    Navigator.pushNamed(context, 'resultadoBusqueda', arguments: {
      'especie': _selection,
      'sexo': _selection1,
      'etapaVida': _selection2,
      'tamanio': _selection3,
      'estado': _selection4
    });
  }

  void _submit4() async {
    Navigator.pushNamed(context, 'resultadoBusqueda', arguments: {
      'especie': _selection,
      'sexo': _selection1,
      'etapaVida': _selection2,
      'tamanio': null,
      'estado': _selection4
    });
  }
}
