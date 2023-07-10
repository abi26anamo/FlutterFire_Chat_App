import 'dart:async';
import 'package:chat_app/models/chat_message.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
    getChats();
  }

  @override
  void dispose() {
    _chatStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatStream =
          _db.getChatsForUser(_auth.user.uid).listen((_snapshot) async {
        chats = await Future.wait(
          _snapshot.docs.map((_doc) async {
            Map<String, dynamic> _chatData =
                _doc.data() as Map<String, dynamic>;
            List<ChatUser> _members = [];
            for (var _uid in _chatData['members']) {
              DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
              Map<String, dynamic> _userData =
                  _userSnapshot.data() as Map<String, dynamic>;
              _members.add(
                ChatUser.fromJSON(_userData),
              );
            }
            List<ChatMessage> _messages = [];
            QuerySnapshot _chatMessage = await _db.getLastMessageForChat(_doc.id);
            if (_chatMessage.docs.isNotEmpty){
              Map<String,dynamic> _messageData = _chatMessage.docs[0].data()! as Map<String,dynamic>;
              ChatMessage _message = ChatMessage.fromJSON(_messageData);
              _messages.add(_message);
            }
            return Chat(
              uid: _doc.id,
              currentUserUid: _auth.user.uid,
              activity: _chatData['is_activity'],
              group: _chatData['is_group'],
              members: _members,
              messages: _messages,
            );
          },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print("Error getting chats");
      print(e);
    }
  }
}
