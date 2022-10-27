import 'package:flutter/material.dart';
import 'package:project/screens/project_calendar_screen.dart';
import 'package:project/screens/task_detail_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import 'package:project/sign_in/landing_screen.dart';


///This class separates the routing logic for the entire application
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/landingScreen':
        return MaterialPageRoute(builder: (_) => const LandingScreen());

      case '/tasks':
        return MaterialPageRoute(builder: (_) => const TaskOverviewScreen());

      case '/task':
        return MaterialPageRoute(builder: (_) => const TaskDetailScreen());

      case '/project/calendar':
        return MaterialPageRoute(builder: (_) => const ProjectCalendarScreen());

        //   case '/project/calendar':
        // // Validation of correct data type
        //   if (args is String) {
        //     return MaterialPageRoute(
        //       builder: (_) => const ProjectCalendarScreen()(
        //         data: args,
        //       ),
        //     );
        //   }

        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
