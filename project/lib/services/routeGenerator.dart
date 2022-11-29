import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/project/edit_project_screen.dart';
import 'package:project/screens/project/project_overview_screen.dart';
import 'package:project/screens/project_calendar_screen.dart';
import 'package:project/screens/sign_in/landing_screen.dart';
import 'package:project/screens/sign_in/login_screen.dart';
import 'package:project/screens/sign_in/registration_screen.dart';
import 'package:project/screens/task/edit_task_screen.dart';
import 'package:project/screens/task/task_detail_screen.dart';
import 'package:project/screens/task/task_overview_screen.dart';
import 'package:project/services/auth.dart';

import '../models/project.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/profile_screen.dart';

///This class separates the routing logic for the entire application
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    //USE THIS TO NAVIGATE IN AN ON-PRESSED ======= Navigator.of(context).pushNamed('/pageName', arguments: agrumentsToPass );

    switch (settings.name) {
      case '/landingScreen':
        return MaterialPageRoute(builder: (_) => LandingScreen(auth: Auth()));

      case '/registrationScreen':
        return MaterialPageRoute(
            builder: (_) => RegistrationScreen(auth: Auth()));

      case '/loginScreen':
        return MaterialPageRoute(builder: (_) => LogInScreen(auth: Auth()));

      case '/projects':
        return MaterialPageRoute(builder: (_) => const ProjectOverviewScreen());

      case '/editProject':
        return MaterialPageRoute(builder: (_) => const EditProjectScreen(null));

      case '/task':
        return MaterialPageRoute(builder: (_) => const TaskDetailScreen());

      case '/tasks':
        return MaterialPageRoute(builder: (_) => const TaskOverviewScreen());

      case '/editProfile':
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      case '/editTask':
        // Validation of correct data type
        if (args is Project) {
          return MaterialPageRoute(
              builder: (_) => EditTaskScreen(project: args));
        } else {
          // If args is not of the correct type, return an error page.
          return _errorRoute();
        }

      case '/project/calendar':
        return MaterialPageRoute(builder: (_) => const ProjectCalendarScreen());

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
