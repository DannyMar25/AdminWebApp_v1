import 'package:admin_web_v1/blocs/provider.dart';
import 'package:admin_web_v1/pages/agendarCitas_page.dart';
import 'package:admin_web_v1/pages/animal_page.dart';
import 'package:admin_web_v1/pages/bienvenida_page.dart';
import 'package:admin_web_v1/pages/busqueda_page.dart';
import 'package:admin_web_v1/pages/cambiarPassword_page.dart';
import 'package:admin_web_v1/pages/donacionesIn_page.dart';
import 'package:admin_web_v1/pages/donacionesOutAdd_page.dart';
import 'package:admin_web_v1/pages/donacionesOut_page.dart';
import 'package:admin_web_v1/pages/forgotPassword_page.dart';
import 'package:admin_web_v1/pages/galeriaMascotas_page.dart';
import 'package:admin_web_v1/pages/horariosA_page.dart';
import 'package:admin_web_v1/pages/horarios_page.dart';
import 'package:admin_web_v1/pages/login_page.dart';
import 'package:admin_web_v1/pages/registro_page.dart';
import 'package:admin_web_v1/pages/resultados_busqueda_page.dart';
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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = PreferenciasUsuario();
    //print(prefs.token);
    final email = prefs.email;
    final rol = prefs.rol;
    //print(prefs.token);

    return Provider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Polipet',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'), // English, no country code
            Locale('es', 'ES'), // Spanish, no country code
          ],
          //initialRoute: 'login',
          initialRoute: email == '' ? 'login' : 'bienvenida',
          routes: {
            'login': (_) => LoginPage(),
            'registro': (_) => const RegistroPage(),
            'home': (_) => const GaleriaMascotasPage(),
            'animal': (_) => const AnimalPage(),
            'bienvenida': (_) => BienvenidaPage(),
            // 'ubicacion': (_) => UbicacionPage(),
            'citasAdd': (_) => const HorariosPage(),
            'horariosAdd': (_) => const HorariosAgregados(),
            'verCitasAg': (_) => const VerCitasPage(),
            'verCitasR': (_) => const VerCitasRegistradas(),
            'agendarCita': (_) => const AgendarCitasPage(),
            'verCitasAt': (_) => const VerCitasAtendidasPage(),
            'donacionesInAdd': (_) => const IngresoDonacionesInPage(),
            'verDonacionesInAdd': (_) => const VerDonacionesInAddPage(),
            'verDonacionesIn1': (_) => const VerDonacionesIn1Page(),
            ForgotPassword.id: (context) => const ForgotPassword(),
            'donacionesOutAdd': (_) => const IngresoDonacionesOutPage(),
            // //'enviarMail': (_) => EmailSender(),
            'enviarMail': (_) => const SoportePage(),
            'cambiarContrasena': (_) => const CambiarPasswordPage(),
            'DonacionesOutAdd1': (_) => const IngresoDonacionesOutAddPage(),
            'verDonacionesOutAdd': (_) => const VerDonacionesOutAddPage(),
            'verDonacionesOutAdd1': (_) => const VerDonacionesOut1Page(),
            'seguimientoPrincipal': (_) => const SeguimientoPrincipalPage(),
            'solicitudes': (_) => const SolicitudesPage(),
            'verSolicitudesMain': (_) => const SolicitudesMainPage(),
            'solicitudesAprobadas': (_) => const SolicitudesAprobadasPage(),
            'verSolicitudAprobada': (_) => const SolicitudAprobadaMainPage(),
            'solicitudesRechazadas': (_) => const SolicitudesRechazadasPage(),
            'verSolicitudRechazada': (_) => const SolicitudRechazadaMainPage(),
            'datosPersonales': (_) => const DatosPersonalesPage(),
            'situacionFam': (_) => const SituacionFamiliarPage(),
            'domicilio': (_) => const DomicilioPage(),
            'relacionAnim': (_) => const RelacionAnimalPage(),
            'observacionSolicitud': (_) => const ObservacionFinalPage(),
            'seguimientoInfo': (_) => const InformacionSeguimientoPage(),
            'verRegistroVacunas': (_) => const VerRegistroVacunasPage(),
            'verRegistroDesp': (_) => const VerRegistroDespPage(),
            'verEvidenciaP1': (_) => const VerEvidenciaFotosPage(),
            'verFotoEvidencia': (_) => const VerFotoEvidenciaPage(),
            'verEvidenciaP2': (_) => const VerEvidenciaArchivosPage(),
            'verArchivoEvidencia': (_) => const VerArchivoEvidenciaPage(),
            'crearPDF': (_) => const CrearSolicitudPdfPage(),
            'soporte': (_) => const SoportePage(),
            'busqueda': (_) => const BusquedaPage(),
            'resultadoBusqueda': (_) => const ResultadosBusquedaPage(),
          },
          theme: ThemeData(primaryColor: Colors.deepPurple)),
    );
  }
}
