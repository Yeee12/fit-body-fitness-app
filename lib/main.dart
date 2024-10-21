import 'package:firebase_core/firebase_core.dart';
import 'package:fit_body_fitness_app/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures binding before initialization

  // Initialize Firebase before running the app
  await Firebase.initializeApp();  // This needs to be awaited

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(  // Change to CustomUser?
      value: AuthService().user,  // This should be a stream of CustomUser?
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
