import 'dart:convert';
import 'dart:html' as h;
import 'package:admin_web_v1/models/animales_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:http/http.dart' as http;

class AnimalesProvider {
  CollectionReference refAn = FirebaseFirestore.instance.collection('animales');
  //late AnimalModel animal1;

  final String _url =
      'https://flutter-varios-1637a-default-rtdb.firebaseio.com';
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> crearAnimal1(AnimalModel animal, String url) async {
    try {
      // print("este esadkjljdkjadkjskadjlkjsdljasdljasdj");
      var animalAdd = await refAn.add(animal.toJson());
      await refAn
          .doc(animalAdd.id)
          .update({"fotoUrl": url, "id": animalAdd.id});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarAnimal(AnimalModel animal, String url) async {
    try {
      await refAn.doc(animal.id).update(animal.toJson());
      await refAn.doc(animal.id).update({"fotoUrl": url});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<AnimalModel>> cargarAnimal1() async {
    final List<AnimalModel> animales = <AnimalModel>[];
    var documents = await refAn.get();
    animales.addAll(documents.docs.map((e) {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      var data = e.data() as Map<String, dynamic>;
      var animal = AnimalModel.fromJson({
        "id": e.id,
        "especie": data["especie"],
        "nombre": data["nombre"],
        "sexo": data["sexo"],
        "etapaVida": data["etapaVida"],
        "temperamento": data["temperamento"],
        "peso": data["peso"],
        "tamanio": data["tamanio"],
        "color": data["color"],
        "raza": data["raza"],
        "esterilizado": data["esterilizado"],
        "estado": data["estado"],
        "caracteristicas": data["caracteristicas"],
        "fotoUrl": data["fotoUrl"]
      });
      return animal;
    }).toList());
    return animales;
  }

  Future<List<AnimalModel>> cargarAnimalBusqueda(String nombre) async {
    final List<AnimalModel> animales = <AnimalModel>[];
    var documents =
        await refAn.where('nombre', isGreaterThanOrEqualTo: nombre).get();
    animales.addAll(documents.docs.map((e) {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      var data = e.data() as Map<String, dynamic>;
      var animal = AnimalModel.fromJson({
        "id": e.id,
        "especie": data["especie"],
        "nombre": data["nombre"],
        "sexo": data["sexo"],
        "etapaVida": data["etapaVida"],
        "temperamento": data["temperamento"],
        "peso": data["peso"],
        "tamanio": data["tamanio"],
        "color": data["color"],
        "raza": data["raza"],
        "esterilizado": data["esterilizado"],
        "estado": data["estado"],
        "caracteristicas": data["caracteristicas"],
        "fotoUrl": data["fotoUrl"]
      });
      return animal;
    }).toList());
    return animales;
  }

  Future<List<AnimalModel>> cargarBusqueda(String especie, String sexo,
      String etapaVida, String tamanio, String estado) async {
    final List<AnimalModel> animales = <AnimalModel>[];
    var documents = await refAn
        .where('especie', isEqualTo: especie)
        .where('estado', isEqualTo: estado)
        .where('sexo', isEqualTo: sexo)
        .where('etapaVida', isEqualTo: etapaVida)
        .where('tamanio', isEqualTo: tamanio)
        .get();
    //var s = (documents.docs.map((e) async {
    animales.addAll(documents.docs.map((e) {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      var data = e.data() as Map<String, dynamic>;
      var animal = AnimalModel.fromJson({
        "id": e.id,
        "especie": data["especie"],
        "nombre": data["nombre"],
        "sexo": data["sexo"],
        "etapaVida": data["etapaVida"],
        "temperamento": data["temperamento"],
        "peso": data["peso"],
        "tamanio": data["tamanio"],
        "color": data["color"],
        "raza": data["raza"],
        "esterilizado": data["esterilizado"],
        "estado": data["estado"],
        "caracteristicas": data["caracteristicas"],
        "fotoUrl": data["fotoUrl"]
      });
      return animal;
    }).toList());
    //return s.toList();
    return animales;
  }

  Future<int> borrarAnimal(String id) async {
    await refAn.doc(id).delete();

    return 1;
  }

  Future<AnimalModel> cargarAnimalId(String id) async {
    AnimalModel animals = AnimalModel();
    final doc = await refAn.doc(id).get();
    var data = doc.data() as Map<String, dynamic>;

    animals = AnimalModel.fromJson({
      "id": doc.id,
      "especie": data["especie"],
      "nombre": data["nombre"],
      "sexo": data["sexo"],
      "etapaVida": data["etapaVida"],
      "temperamento": data["temperamento"],
      "peso": data["peso"],
      "tamanio": data["tamanio"],
      "color": data["color"],
      "raza": data["raza"],
      "esterilizado": data["esterilizado"],
      "estado": data["estado"],
      "caracteristicas": data["caracteristicas"],
      "fotoUrl": data["fotoUrl"]
    });

    return animals;
  }

  Future<bool> editarEstado(AnimalModel animal, String estado) async {
    try {
      //String disp = "";
      await refAn.doc(animal.id).update({"estado": estado});
      return true;
    } catch (e) {
      return false;
    }
  }
}
