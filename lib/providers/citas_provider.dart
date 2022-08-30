import 'package:admin_web_v1/models/animales_model.dart';
import 'package:admin_web_v1/models/citas_model.dart';
import 'package:admin_web_v1/models/horarios_model.dart';
import 'package:admin_web_v1/providers/animales_provider.dart';
import 'package:admin_web_v1/providers/horarios_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CitasProvider {
  CollectionReference refCit = FirebaseFirestore.instance.collection('citas');
  FirebaseStorage storage = FirebaseStorage.instance;
  final horariosProvider = HorariosProvider();
  final animalesProvider = AnimalesProvider();

  Future<bool> crearCita(
    CitasModel cita,
  ) async {
    try {
      // print("este esadkjljdkjadkjskadjlkjsdljasdljasdj");
      var citasAdd = await refCit.add(cita.toJson());
      await refCit.doc(citasAdd.id).update({"id": citasAdd.id});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Future<CitasModel>>> cargarCitas() async {
    //final List<CitasModel> citas = <CitasModel>[];
    var documents = await refCit.where('estado', isEqualTo: 'Pendiente').get();
    //citas.addAll
    var s = (documents.docs.map((e) async {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      //var data = e.data() as Map<String, dynamic>;
      HorariosModel h1 = HorariosModel();
      AnimalModel anim = AnimalModel();
      h1 = await horariosProvider.cargarHorarioId(e["idHorario"]);
      anim = await animalesProvider.cargarAnimalId(e["idAnimal"]);
      var cita = CitasModel.fromJson({
        "id": e.id,
        "nombreClient": e["nombreClient"],
        "telfClient": e["telfClient"],
        "correoClient": e["correoClient"],
        "estado": e["estado"],
        "fechaCita": e["fechaCita"],
        "idAnimal": e["idAnimal"],
        "idHorario": e["idHorario"]
      });
      cita.horario = h1;
      cita.animal = anim;
      return cita;
    }));
    return s.toList();
  }

  Future<List<Future<CitasModel>>> cargarCitasFecha(String fecha) async {
    //final List<CitasModel> citas = <CitasModel>[];
    var documents = await refCit.where('fechaCita', isEqualTo: fecha).get();
    //citas.addAll
    var s = (documents.docs.map((e) async {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      //var data = e.data() as Map<String, dynamic>;
      HorariosModel h1 = HorariosModel();
      AnimalModel anim = AnimalModel();
      h1 = await horariosProvider.cargarHorarioId(e["idHorario"]);
      anim = await animalesProvider.cargarAnimalId(e["idAnimal"]);
      var cita = CitasModel.fromJson({
        "id": e.id,
        "nombreClient": e["nombreClient"],
        "telfClient": e["telfClient"],
        "correoClient": e["correoClient"],
        "estado": e["estado"],
        "fechaCita": e["fechaCita"],
        "idAnimal": e["idAnimal"],
        "idHorario": e["idHorario"]
      });
      cita.horario = h1;
      cita.animal = anim;
      return cita;
    }));
    return s.toList();
  }

  Future<List<Future<CitasModel>>> cargarCitasAtendidas(String fecha) async {
    //final List<CitasModel> citas = <CitasModel>[];
    var documents = await refCit
        .where('estado', isEqualTo: 'Atendido')
        .where('fechaCita', isEqualTo: fecha)
        .get();
    //citas.addAll
    var s = (documents.docs.map((e) async {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      //var data = e.data() as Map<String, dynamic>;
      HorariosModel h1 = HorariosModel();
      AnimalModel anim = AnimalModel();
      h1 = await horariosProvider.cargarHorarioId(e["idHorario"]);
      anim = await animalesProvider.cargarAnimalId(e["idAnimal"]);
      var cita = CitasModel.fromJson({
        "id": e.id,
        "nombreClient": e["nombreClient"],
        "telfClient": e["telfClient"],
        "correoClient": e["correoClient"],
        "estado": e["estado"],
        "fechaCita": e["fechaCita"],
        "idAnimal": e["idAnimal"],
        "idHorario": e["idHorario"]
      });
      cita.horario = h1;
      cita.animal = anim;
      return cita;
    }));
    return s.toList();
  }

  Future<bool> editarEstadoCita(CitasModel cita) async {
    try {
      String estado = "Atendido";
      await refCit.doc(cita.id).update({"estado": estado});
      return true;
    } catch (e) {
      return false;
    }
  }
}
