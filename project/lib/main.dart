import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/services/RouteGenerator.dart';
import 'package:project/screens/project/create_project_screen.dart';
import 'package:project/static_data/example_data.dart';
import 'package:project/styles/themes.dart';
import './models/project.dart';
import 'package:project/screens/profile/create_profile_screen.dart';
import 'package:project/screens/profile/profile_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static List<Project> projects = ExampleData.projects;

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
