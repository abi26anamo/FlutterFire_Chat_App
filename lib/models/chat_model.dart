

import 'package:chat_app/models/chat_message.dart';
import 'package:chat_app/models/chat_user.dart';

class Chat{
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser>members;
  final List<ChatMessage> messages;
  late final List<ChatUser> _recepients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.activity,
    required this.group,
    required this.members,
    required this.messages,
  }){
    _recepients = members.where((_i) => _i.uid != currentUserUid).toList();
  }
  List<ChatUser> get recepients => _recepients;

  String title(){
    return group ? 
                  _recepients.map((_user) => _user.name).join(",") 
                  : recepients[0].name;
  }
  String imageURL(){
    return group ? 
     "https://e7.pngegg.com/pngimages/380/670/png-clipart-group-chat-logo-blue-area-text-symbol-metroui-apps-live-messenger-alt-2-blue-text.png" 
     : recepients[0].imageURL;
  }
}