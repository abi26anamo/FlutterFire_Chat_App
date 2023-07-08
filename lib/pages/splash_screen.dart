import 'package:chat_app/services/cloud_storage_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/routing_service.dart';
import 'package:get_it/get_it.dart';
import 'package:chat_app/services/media_sevices.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashScreen({required Key key, required this.onInitializationComplete})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((_) {
      _firebaseSetUp().then(
        (_) => widget.onInitializationComplete(),
      );
    });
  }

  Future<void> _firebaseSetUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerServices();
  }

  void _registerServices() {
    GetIt getIt = GetIt.instance;
    getIt.registerSingleton<RoutingService>(
      RoutingService(),
    );
    getIt.registerSingleton<MediaServices>(
      MediaServices(),
    );

    getIt.registerSingleton<CloudStorageService>(
      CloudStorageService(),
    );
    getIt.registerSingleton<DatabaseService>(
      DatabaseService(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChatApp",
      theme: ThemeData(
          backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0)),
      home: Scaffold(
        body: Center(
          child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.contain,
                ),
              )),
        ),
      ),
    );
  }
}
