// ignore_for_file: library_private_types_in_public_api, unused_label, dead_code, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginpagecheck/credit.dart';
import 'package:loginpagecheck/debit.dart';
import 'package:loginpagecheck/homePage.dart';
import 'package:loginpagecheck/login_page.dart';
import 'package:loginpagecheck/models/user_model.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/material.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  var _currentIndex = 0;
  final screens = [
    const homePage(),
    const Creditpage(),
    const Debitpage(),
    // const Debitpage(),

  ];
  final storage=const FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: screens[_currentIndex],
      // body: IndexedStack(
      //   index: _currentIndex,
      //   children: screens,
      // ),
      
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Colors.purple,
            ),

            /// Credit
            SalomonBottomBarItem(
              icon: const Icon(Icons.currency_rupee),
              title: const Text("Credit"),
              selectedColor: Colors.pink,
            ),

            /// Debit
            SalomonBottomBarItem(
              icon: const Icon(Icons.money),
              title: const Text("Debit"),
              selectedColor: Colors.orange,
            ),

            /// Profile
            // SalomonBottomBarItem(
            //   icon: const Icon(Icons.person),
            //   title: const Text("Profile"),
            //   selectedColor: Colors.teal,
            // ),
          ],
        ),
      );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await storage.delete(key: "uid");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}



