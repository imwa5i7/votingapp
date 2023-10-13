// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:disney_voting/controllers/auth_controller.dart';
import 'package:disney_voting/ui/screens/dashboard/components/character/characters.dart';
import 'package:disney_voting/ui/screens/dashboard/components/report/report.dart';
import 'package:disney_voting/ui/widgets/custom_appbar.dart';
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
    const CharactersWidget(),
    const ReportsWidget(),
  ];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _title = 'Characters';
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Wasil Khan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Palette.primary,
                        fontSize: Sizes.s20),
                  ),
                  Text(
                    'imwasil@gmail.com',
                    style:
                        TextStyle(color: Palette.primary, fontSize: Sizes.s12),
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
            title: const Text('Sign out'),
            leading: const Icon(Icons.exit_to_app),
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
