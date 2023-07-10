import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";

class CloudStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  CloudStorageService() {}

  Future<String?> saveUserImageToStorage(
      String _uid, PlatformFile _image) async {
    try {
      Reference _ref = _firebaseStorage
          .ref()
          .child("images/users/$_uid/profile.${_image.extension}");
      UploadTask _task = _ref.putFile(File(_image.path!));
      return _task.then((_result) => _result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
  }

  Future<String?> saveChatImageToStorage(String _chatId, String _userId, PlatformFile _file)async{
    try{
      Reference _ref = _firebaseStorage.ref().child("images/chats/$_chatId/${_userId} ${Timestamp.now().millisecondsSinceEpoch}.${_file.extension}");
      UploadTask _task = _ref.putFile(File(_file.path!));
      return _task.then((_result) => _result.ref.getDownloadURL());
    }catch(e){
      print(e);
    }
  }
}
