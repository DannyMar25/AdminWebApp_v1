import 'package:admin_web_v1/models/evidencia_model.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class VerFotoEvidenciaPage extends StatefulWidget {
  const VerFotoEvidenciaPage({Key? key}) : super(key: key);

  @override
  State<VerFotoEvidenciaPage> createState() => _VerFotoEvidenciaPageState();
}

class _VerFotoEvidenciaPageState extends State<VerFotoEvidenciaPage> {
  EvidenciasModel evidenciaF = EvidenciasModel();
  @override
  Widget build(BuildContext context) {
    final Object? evidenciaData = ModalRoute.of(context)!.settings.arguments;
    if (evidenciaData != null) {
      evidenciaF = evidenciaData as EvidenciasModel;
      //print(evidenciaF.id);
    }
    return SizedBox(
      child: PhotoView(
        imageProvider: NetworkImage(evidenciaF.fotoUrl),
        //maxScale: 200.0,
      ),
    );
  }
}
