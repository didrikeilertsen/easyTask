import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/routeGenerator.dart';
import 'package:project/styles/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: "solveIt",
      theme: Themes.themeData,

      initialRoute: '/landingScreen',
      onGenerateRoute: RouteGenerator.generateRoute,


      //for testing individual page
                 // home: const CreateProjectScreen(),

    );
  }
}
