import 'package:admin_web_v1/models/evidencia_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class VerArchivoEvidenciaPage extends StatefulWidget {
  const VerArchivoEvidenciaPage({Key? key}) : super(key: key);

  @override
  State<VerArchivoEvidenciaPage> createState() =>
      _VerArchivoEvidenciaPageState();
}

class _VerArchivoEvidenciaPageState extends State<VerArchivoEvidenciaPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  EvidenciasModel evidenciaA = EvidenciasModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Object? evidenciaData = ModalRoute.of(context)!.settings.arguments;
    if (evidenciaData != null) {
      evidenciaA = evidenciaData as EvidenciasModel;
      // ignore: avoid_print
      print(evidenciaA.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archivo"),
        backgroundColor: Colors.green,
        actions: const <Widget>[
          // IconButton(
          //   icon: const Icon(
          //     Icons.bookmark,
          //     color: Colors.white,
          //     semanticLabel: 'Bookmark',
          //   ),
          //   onPressed: () {
          //     //_pdfViewerKey.currentState?.openBookmarkView();
          //   },
          // ),
        ],
      ),
      body: SfPdfViewer.network(
        //'https://firebasestorage.googleapis.com/v0/b/flutter-varios-1637a.appspot.com/o/Evidencias%2FArchivos%2F1029284635%2FDiana%20Alexandra%20Lara%20Mera-24.%20%EC%96%B4%EB%94%94%EA%B0%80%20%EC%95%84%ED%94%84%EC%84%B8%EC%9A%94%20(D%C3%B3nde%20le%20duele).pdf?alt=media&token=75ffdc67-d384-491c-b263-3235ef7f658c',
        evidenciaA.archivoUrl,
        key: _pdfViewerKey,
      ),
    );
  }
}
