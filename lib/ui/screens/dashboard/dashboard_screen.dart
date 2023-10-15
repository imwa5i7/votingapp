// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:disney_voting/controllers/auth_controller.dart';
import 'package:disney_voting/controllers/voting_controller.dart';
import 'package:disney_voting/ui/screens/auth/change_password.dart';
import 'package:disney_voting/ui/screens/dashboard/components/character/characters.dart';
import 'package:disney_voting/ui/screens/dashboard/components/report/report.dart';
import 'package:disney_voting/ui/widgets/custom_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/config.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final List<Widget> _widgetList = [
    CharactersWidget(),
    const ReportsWidget(),
    const ChangePasswordScreen(),
  ];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _title = 'Characters';
  User? currentUser = instance<FirebaseAuth>().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.7,
        child: NavigationDrawer(children: [
          Container(
              height: Sizes.s80,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentUser != null
                        ? currentUser!.displayName!
                        : 'Wasil Khan',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Palette.primary,
                        fontSize: Sizes.s20),
                  ),
                  Text(
                    currentUser != null
                        ? currentUser!.email!
                        : 'imwasil@gmail.com',
                    style: const TextStyle(
                        color: Palette.primary, fontSize: Sizes.s12),
                  ),
                ],
              )),
          ListTile(
            title: const Text('Characters'),
            leading: const Icon(Icons.person),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Palette.primary),
            onTap: () {
              setState(() {
                _currentIndex = 0;
                _title = 'Characters';
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Reports'),
            leading: const Icon(Icons.bar_chart),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Palette.primary),
            onTap: () {
              setState(() {
                _currentIndex = 1;
                _title = 'Reports';
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Change Password'),
            leading: const Icon(Icons.lock),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Palette.primary),
            onTap: () async {
              setState(() {
                _currentIndex = 2;
                _title = 'Change Password';
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Sign out'),
            leading: const Icon(Icons.exit_to_app_rounded),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Palette.primary),
            onTap: () async {
              bool success = await context.read<AuthController>().signOut();
              log(success.toString());
              if (success) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
          ),
        ]),
      ),
      appBar: CustomAppbar(
        title: _title,
        actions: [
          if (_currentIndex == 1) ...[
            IconButton(
              icon: const Icon(Icons.restore),
              onPressed: () {
                context.read<VotingController>().setToAll();
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () async {
                context
                    .read<VotingController>()
                    .filerListByCurrentDate(context);
              },
            ),
          ] else
            ...[],
        ],
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.sort,
              color: Palette.primary,
            )),
      ),
      body: _widgetList[_currentIndex],
    );
  }
}
