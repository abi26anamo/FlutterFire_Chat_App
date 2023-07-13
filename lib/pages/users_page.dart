import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/users_provider.dart';
import 'package:chat_app/widgets/custom_app_bar.dart';
import 'package:chat_app/widgets/custom_input_field.dart';
import 'package:chat_app/widgets/custom_list_view_tiles.dart';
import 'package:chat_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late UsersProvider _usersProvider;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsersProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _usersProvider = _context.watch<UsersProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAppBar(
              'Users',
              primaryAction: IconButton(
                onPressed: () {
                  _auth.logOut();
                },
                icon: Icon(
                  Icons.logout,
                  color: Color.fromRGBO(0, 82, 218, 1.0),
                ),
              ),
            ),
            CustomTextField(
              onEditingComplete: (_value) {
                _usersProvider.getUsers(name: _value);
                FocusScope.of(context).unfocus();
              },
              controller: _searchController,
              hintText: "search",
              obscureText: false,
              icon: Icons.search,
            ),
            _usersList(),
            _createChatButton(),
          ],
        ),
      );
    });
  }

  Widget _usersList() {
    List<ChatUser>? _users = _usersProvider.users;
    return Expanded(
      child: () {
        if (_users != null) {
          if (_users.length != 0) {
            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext _context, int _index) {
                return CustomListViewTile(
                  height: _deviceHeight * 0.10,
                  title: _users[_index].name,
                  subtitle: "last active ${_users[_index].lastActive}",
                  imagePath: _users[_index].imageURL,
                  isActive: _users[_index].wasRecentlyActive(),
                  isSelected:
                      _usersProvider.selectedUsers.contains(_users[_index]),
                  onTap: () {
                    _usersProvider.updateSelectedUsers(_users[_index]);
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "No users found",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      }(),
    );
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _usersProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: _usersProvider.selectedUsers.length == 1
            ? "Chat With ${_usersProvider.selectedUsers.first.name}"
            : "Create Group chat",
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPressed: () {
          _usersProvider.createChat();
        },
      ),
    );
  }
}
