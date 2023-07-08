import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/routing_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final RoutingService _routingServices;
  late final DatabaseService _databaseService;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _routingServices = GetIt.instance.get<RoutingService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
  }

  Future<void> emailPasswordSignIn(String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print(_auth.currentUser);
    } on FirebaseAuthException {
      print("Error logging into Firebase");
    } catch (e){
      print(e);
    }
  }
}
