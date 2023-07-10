import 'dart:async';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//chats provider

class ChatProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DatabaseService _db;

  List<Chat>? chats;

  late StreamSubscription _chatStream;

  ChatProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
  }

  @override
  void dispose() {
    _chatStream.cancel();
    super.dispose();
  }

  void getChats() async {}
}
