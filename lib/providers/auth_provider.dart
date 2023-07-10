import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/routing_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final RoutingService _routingServices;
  late final DatabaseService _databaseService;
  late ChatUser user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _routingServices = GetIt.instance.get<RoutingService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
   
    _auth.signOut();

    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        _databaseService.updateUserLastSeen(_user.uid);
        _databaseService.getUser(_user.uid).then((_snapshot) {
          Map<String, dynamic> _userData =
              _snapshot.data() as Map<String, dynamic>;
          user = ChatUser.fromJSON(
            {
              "uid": _user.uid,
              "email": _userData["email"],
              "name": _userData["name"],
              "last_active": _userData["last_active"],
              "image": _userData["image"],
            },
          );
          _routingServices.removeAndNavigateToRoute('/home');
        });
      } else {
        _routingServices.removeAndNavigateToRoute('/login');
      }
    });
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
    } catch (e) {
      print(e);
    }
  }

  Future<String?> singupUsingEmailandPassword(
      String _email, String _password) async {
    try {
      UserCredential _credentials = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      return _credentials.user!.uid;
    } on FirebaseAuthException {
      print("Error Registering user");
    } catch (e) {
      print(e);
    }
   
  }

  Future<void> logOut()async{
    try{
      await _auth.signOut();
    }catch(e){
      print(e);
    }
  }
}
