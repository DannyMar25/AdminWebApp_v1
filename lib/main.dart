import 'package:admin_web_v1/blocs/provider.dart';
import 'package:admin_web_v1/pages/agendarCitas_page.dart';
import 'package:admin_web_v1/pages/animal_page.dart';
import 'package:admin_web_v1/pages/donacionesIn_page.dart';
import 'package:admin_web_v1/pages/donacionesOutAdd_page.dart';
import 'package:admin_web_v1/pages/donacionesOut_page.dart';
import 'package:admin_web_v1/pages/forgotPassword_page.dart';
import 'package:admin_web_v1/pages/home_page.dart';
import 'package:admin_web_v1/pages/horariosA_page.dart';
import 'package:admin_web_v1/pages/horarios_page.dart';
import 'package:admin_web_v1/pages/login_page.dart';
import 'package:admin_web_v1/pages/registro_page.dart';
import 'package:admin_web_v1/pages/seguimiento_archivos_page.dart';
import 'package:admin_web_v1/pages/seguimiento_desparasitacion_page.dart';
import 'package:admin_web_v1/pages/seguimiento_fotos_page.dart';
import 'package:admin_web_v1/pages/seguimiento_informacion_page.dart';
import 'package:admin_web_v1/pages/seguimiento_page.dart';
import 'package:admin_web_v1/pages/seguimiento_vacunas_page.dart';
import 'package:admin_web_v1/pages/solicitud_datosPer_page.dart';
import 'package:admin_web_v1/pages/solicitud_domicilio_page.dart';
import 'package:admin_web_v1/pages/solicitud_observacion_page.dart';
import 'package:admin_web_v1/pages/solicitud_pdf_page.dart';
import 'package:admin_web_v1/pages/solicitud_relacionAn_page.dart';
import 'package:admin_web_v1/pages/solicitud_situacionFam_page.dart';
import 'package:admin_web_v1/pages/solicitudesMain_page.dart';
import 'package:admin_web_v1/pages/solicitudes_aprobadasMain_page.dart';
import 'package:admin_web_v1/pages/solicitudes_aprobadas_page.dart';
import 'package:admin_web_v1/pages/solicitudes_page.dart';
import 'package:admin_web_v1/pages/solicitudes_rechazadasMain_page.dart';
import 'package:admin_web_v1/pages/solicitudes_rechazadas_page.dart';
import 'package:admin_web_v1/pages/soporte_page.dart';
import 'package:admin_web_v1/pages/verCitasAt_page.dart';
import 'package:admin_web_v1/pages/verCitasR_page.dart';
import 'package:admin_web_v1/pages/verCitas_page.dart';
import 'package:admin_web_v1/pages/verDonacionesIn1_page.dart';
import 'package:admin_web_v1/pages/verDonacionesIn_page.dart';
import 'package:admin_web_v1/pages/verDonacionesOut1_page.dart';
import 'package:admin_web_v1/pages/verDonacionesOut_page.dart';
import 'package:admin_web_v1/pages/ver_archivo_page.dart';
import 'package:admin_web_v1/pages/ver_foto_page.dart';
import 'package:admin_web_v1/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';
//import 'package:formvalidation/src/pages/producto_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    //print(prefs.token);

    return Provider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'), // English, no country code
            Locale('es', 'ES'), // Spanish, no country code
          ],
          initialRoute: 'login',
          routes: {
            'login': (_) => LoginPage(),
            'registro': (_) => RegistroPage(),
            'home': (_) => HomePage(),
            'animal': (_) => AnimalPage(),
            // 'bienvenida': (_) => BienvenidaPage(),
            // 'ubicacion': (_) => UbicacionPage(),
            'citasAdd': (_) => const HorariosPage(),
            'horariosAdd': (_) => const HorariosAgregados(),
            'verCitasAg': (_) => VerCitasPage(),
            'verCitasR': (_) => VerCitasRegistradas(),
            'agendarCita': (_) => AgendarCitasPage(),
            'verCitasAt': (_) => VerCitasAtendidasPage(),
            'donacionesInAdd': (_) => IngresoDonacionesInPage(),
            'verDonacionesInAdd': (_) => const VerDonacionesInAddPage(),
            'verDonacionesIn1': (_) => VerDonacionesIn1Page(),
            ForgotPassword.id: (context) => ForgotPassword(),
            'donacionesOutAdd': (_) => IngresoDonacionesOutPage(),
            // //'enviarMail': (_) => EmailSender(),
            'enviarMail': (_) => const SoportePage(),
            // 'perfilUser': (_) => PerfilUsuarioPage(),
            'DonacionesOutAdd1': (_) => IngresoDonacionesOutAddPage(),
            'verDonacionesOutAdd': (_) => const VerDonacionesOutAddPage(),
            'verDonacionesOutAdd1': (_) => VerDonacionesOut1Page(),
            'seguimientoPrincipal': (_) => const SeguimientoPrincipalPage(),
            'solicitudes': (_) => const SolicitudesPage(),
            'verSolicitudesMain': (_) => const SolicitudesMainPage(),
            'solicitudesAprobadas': (_) => const SolicitudesAprobadasPage(),
            'verSolicitudAprobada': (_) => SolicitudAprobadaMainPage(),
            'solicitudesRechazadas': (_) => const SolicitudesRechazadasPage(),
            'verSolicitudRechazada': (_) => SolicitudRechazadaMainPage(),
            'datosPersonales': (_) => const DatosPersonalesPage(),
            'situacionFam': (_) => const SituacionFamiliarPage(),
            'domicilio': (_) => const DomicilioPage(),
            'relacionAnim': (_) => const RelacionAnimalPage(),
            'observacionSolicitud': (_) => const ObservacionFinalPage(),
            'seguimientoInfo': (_) => InformacionSeguimientoPage(),
            'verRegistroVacunas': (_) => const VerRegistroVacunasPage(),
            'verRegistroDesp': (_) => const VerRegistroDespPage(),
            'verEvidenciaP1': (_) => const VerEvidenciaFotosPage(),
            'verFotoEvidencia': (_) => const VerFotoEvidenciaPage(),
            'verEvidenciaP2': (_) => const VerEvidenciaArchivosPage(),
            'verArchivoEvidencia': (_) => const VerArchivoEvidenciaPage(),
            'crearPDF': (_) => const CrearSolicitudPdfPage(),
            // 'soporte': (_) => SoportePage(),
          },
          theme: ThemeData(primaryColor: Colors.deepPurple)),
    );
  }
}
