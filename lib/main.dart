import 'package:chat_app/pages/splash_screen.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/services/routing_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    SplashScreen(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => AuthenticationProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chatify',
        theme: ThemeData(
          backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
        ),
        navigatorKey: RoutingService.navigatorKey,
        initialRoute: '/login',
        routes: {'/login': (BuildContext contenxt) =>const LoginPage()},
      ),
    );
  }
}
