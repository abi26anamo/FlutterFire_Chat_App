import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/services/cloud_storage_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/media_sevices.dart';
import 'package:chat_app/services/routing_service.dart';
import 'package:chat_app/widgets/custom_input_field.dart';
import 'package:chat_app/widgets/rouded_image.dart';
import 'package:chat_app/widgets/rounded_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;
  late RoutingService _navigation;

  PlatformFile? _profileImage;
  final _singUpFromKey = GlobalKey<FormState>();

  String? _email;
  String? _password;
  String? _name;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
    _navigation = GetIt.instance.get<RoutingService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageField(),
            SizedBox(height: _deviceHeight * 0.05),
            _singUpForm(),
            SizedBox(height: _deviceHeight * 0.05),
            _singUpButton()
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((_file) {
          setState(() {
            _profileImage = _file!;
          });
        });
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: _profileImage!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return RoudedNetworkImage(
            key: UniqueKey(),
            imagePath: "https://i.pravatar.cc/150?img=65",
            size: _deviceHeight * 0.2,
          );
        }
      }(),
    );
  }

  Widget _singUpForm() {
    return Container(
      height: _deviceHeight * 0.40,
      child: Form(
        key: _singUpFromKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _name = _value;
                });
              },
              regEx: r".{8,}",
              hintText: "Name",
              obscureText: false,
            ),
            SizedBox(
              height: _deviceHeight * 0.03,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              regEx:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: "Email",
              obscureText: false,
            ),
            SizedBox(
              height: _deviceHeight * 0.03,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              regEx: r".{8,}",
              hintText: "Password",
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _singUpButton() {
    return RoundedButton(
      name: "Register",
      height: _deviceHeight * 0.085,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if(_singUpFromKey.currentState!.validate() && _profileImage !=null){
          _singUpFromKey.currentState!.save();
          String? _uid = await _auth.singupUsingEmailandPassword(_email!, _password!);
          String? _imageURL = await _cloudStorage.saveUserImageToStorage(_uid!, _profileImage!);
          await _db.createUserInDB(_uid, _email!,_name!, _imageURL!);
          await _auth.logOut();
          await _auth.emailPasswordSignIn(_email!, _password!);
        } 
      },
    );
  }
}
