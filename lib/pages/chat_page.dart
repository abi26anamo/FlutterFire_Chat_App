import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_page_provider.dart';
import 'package:chat_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late ChatPageProvider _chatPageProvider;
  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ChatPageProvider(
                this.widget.chat.uid, _auth, _messagesListViewController))
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _chatPageProvider = _context.watch<ChatPageProvider>();
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02),
            height: _deviceHeight,
            width: _deviceWidth * 0.97,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomAppBar(
                  this.widget.chat.title(),
                  fontSize: 10,
                  primaryAction: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete),
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                  secondaryAction: IconButton(
                    onPressed: () {
                      
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
                _messagesListView(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _messagesListView() {
    if (_chatPageProvider.messages != null) {
      if (_chatPageProvider.messages!.length != 0) {
        return Container(
          height: _deviceHeight * 0.75,
          child: ListView.builder(
            itemCount: _chatPageProvider.messages!.length,
            itemBuilder: (BuildContext _context, int _index) {
              return Container(
                child: Text(
                  _chatPageProvider.messages![_index].content,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              );

            },
          ),
        );
      } else {
        return Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say Hi!",
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
  }
}
