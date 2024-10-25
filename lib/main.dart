import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parkinglot/controller/auth_controller.dart';
import 'package:parkinglot/controller/history_controller.dart';
import 'package:parkinglot/controller/home_controller.dart';
import 'package:parkinglot/view/auth_screen.dart';
import 'package:parkinglot/view/home_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyBQDQAcZYntzOvcotbKmOmYwo8xpYyP49U',
        appId: 'parking-lot-d97ad',
        messagingSenderId: '912123146616',
        projectId: 'parking-lot-d97ad'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthController(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryController(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeViewScreen();
              } else {
                return const AuthScreen();
              }
            }),
      ),
    );
  }
}
