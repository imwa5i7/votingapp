import 'package:disney_voting/ui/screens/dashboard/components/character/add_character.dart';
import 'package:disney_voting/ui/screens/dashboard/components/character/characters.dart';
import 'package:disney_voting/ui/screens/dashboard/components/character/update_character.dart';
import 'package:disney_voting/ui/screens/dashboard/components/character/view_character.dart';
import 'package:disney_voting/ui/screens/dashboard/components/report/report.dart';
import 'package:disney_voting/ui/screens/dashboard/dashboard_screen.dart';
import 'package:disney_voting/ui/screens/voting/voting_screen.dart';
import 'package:flutter/material.dart';

import '../ui/screens/auth/login_screen.dart';
import '../ui/screens/auth/register_screen.dart';

class Routes {
  static const String login = "/login";
  static const String register = "/register";
  static const String dashboard = "/dashboard";
  static const String addCharacter = "/add-character";
  static const String udpateCharacter = "/update-character";

  static const String viewCharacter = "/view-character";
  static const String characters = "/characters";
  static const String reports = "/reports";
  static const String voting = "/voting";
}

class RouteGenerator {
  static Route<dynamic> getRoute(
    RouteSettings routeSettings,
  ) {
    switch (routeSettings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case Routes.addCharacter:
        return MaterialPageRoute(builder: (_) => const AddCharacterScreen());
      case Routes.udpateCharacter:
        final String? id = routeSettings.arguments as String?;

        return MaterialPageRoute(
            builder: (_) => UpdateCharacter(
                  id: id,
                ));
      case Routes.viewCharacter:
        final String id = routeSettings.arguments as String;

        return MaterialPageRoute(
            builder: (_) => ViewCharacterScreen(
                  id: id,
                ));

      case Routes.characters:
        return MaterialPageRoute(builder: (_) => const CharactersWidget());

      case Routes.reports:
        return MaterialPageRoute(builder: (_) => const ReportsWidget());
      case Routes.voting:
        return MaterialPageRoute(builder: (_) => const VotingScreen());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('No Route Found!'),
              ),
              body: const Center(child: Text('No Route Found!')),
            ));
  }
}
