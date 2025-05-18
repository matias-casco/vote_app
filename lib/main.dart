import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vote_app/pages/pages.dart';
import 'package:vote_app/services/socket_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomePage(),
          '/status': (context) => const StatusPage(),
        },
      ),
    );
  }
}
