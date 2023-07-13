import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/routing_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/chat_model.dart';

class UsersProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DatabaseService _database;
  late RoutingService _navigation;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;

  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UsersProvider(this._auth) {
    _database = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<RoutingService>();
    getUsers();
  }
  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      await _database.getUsersByName(name: name).then(
        (_snapshot) {
          users = _snapshot.docs
              .map((_doc) {
                Map<String, dynamic> _data =
                    _doc.data() as Map<String, dynamic>;
                _data['uid'] = _doc.id;
                return ChatUser.fromJSON(_data);
              })
              .cast<ChatUser>()
              .toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting users: $e");
    }
  }

  void updateSelectedUsers(ChatUser _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> _membersIds =
          _selectedUsers.map((_user) => _user.uid).toList();
      _membersIds.add(_auth.user.uid);
      bool _isGroupChat = _selectedUsers.length > 1;
      DocumentReference? _doc = await _database.createChat({
        "is_group": _isGroupChat,
        "is_activity": false,
        "members": _membersIds,
      });

      List<ChatUser> _members = [];
      for (var _uid in _membersIds) {
        DocumentSnapshot _userSnapshot = await _database.getUser(_uid);
        Map<String, dynamic> _userData =
            _userSnapshot.data() as Map<String, dynamic>;
        _userData["uid"] = _userSnapshot.id;
        _members.add(
          ChatUser.fromJSON(_userData),
        );
      }
      ChatPage _chatPage = ChatPage(
        chat: Chat(
          uid: _doc!.id,
          currentUserUid: _auth.user.uid,
          messages: [],
          members: _members,
          activity: false,
          group: _isGroupChat,
        ),
      );
      _selectedUsers = [];
      notifyListeners();
      _navigation.navigateToPage(
        _chatPage,
      );
    } catch (e) {
      print("Error creating chat: $e");
    }
  }
}
