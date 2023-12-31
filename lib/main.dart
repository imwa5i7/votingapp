import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_voting/controllers/auth_controller.dart';
import 'package:disney_voting/controllers/characters_controller.dart';
import 'package:disney_voting/controllers/voting_controller.dart';
import 'package:disney_voting/data/repository/repository.dart';
import 'package:disney_voting/ui/screens/voting/voting_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initAppModule();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) => AuthController(instance<Repository>())),
    ChangeNotifierProvider(
        create: (_) => CharacterController(instance<Repository>())),
    ChangeNotifierProvider(
        create: (_) => VotingController(
            instance<Repository>(), instance<FirebaseFirestore>()))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        useMaterial3: true,
      ),
      navigatorKey: navKey,
      onGenerateRoute: RouteGenerator.getRoute,
      home: const VotingScreen(),
    );
  }
}
