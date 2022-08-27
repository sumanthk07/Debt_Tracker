

// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginpagecheck/credit.dart';
import 'package:loginpagecheck/debit.dart';
import 'package:loginpagecheck/login_page.dart';
import 'package:loginpagecheck/models/user_model.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final storage=const FlutterSecureStorage();

 @override
  void initState() {
    super.initState(); 
    FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
               DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(143, 0, 0, 255),
                ), //BoxDecoration
                child: Image.asset("images/profile.png", fit: BoxFit.contain), 
              ), 
              // ListTile(
              //   leading: const Icon(Icons.person),
              //   title: const Text(' My Profile '),
              //   onTap: () {},
              // ),
              ListTile(
                leading: const Icon(Icons.money),
                title: const Text(' Owed to me '),
                onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Debit()));
                            },
              ),
              ListTile(
                leading: const Icon(Icons.wallet_giftcard),
                title: const Text(' Owed by me '),
                onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Credit()));
                            },
              ),
              // ListTile(
              //   leading: const Icon(Icons.edit),
              //   title: const Text(' Edit Profile '),
              //   onTap: () {
              //                 Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) =>
              //                             const Debitpage()));
              //               },
              // ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('LogOut'),
                onTap: () {
                    logout(context);
                  },
              ),
            ],
          ),
        ),
        appBar: AppBar(
        title: const Text("Debt Tracker"),
        backgroundColor: const Color.fromARGB(143, 0, 0, 255),
        centerTitle: true,
      ),
        body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Image.asset("images/book.png", fit: BoxFit.contain),
              ),
              const Text(
                "Welcome ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              Text("${loggedInUser.email}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(
                height: 15,
              ),
              ActionChip(
                  label: const Text("Logout"),
                  onPressed: () {
                    logout(context);
                  }),
            ],
          ),
        ),
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