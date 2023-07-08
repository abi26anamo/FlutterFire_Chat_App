import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MediaServices{

  Future<PlatformFile?>pickkImage() async{
    FilePickerResult? _result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (_result != null){
      return _result.files[0];
    }
    return null;

  }

}