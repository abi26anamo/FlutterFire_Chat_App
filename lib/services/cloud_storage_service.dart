import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


const String USER_COLLECTION = "Users";

class CloudStorageService{

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  CloudStorageService(){}

}