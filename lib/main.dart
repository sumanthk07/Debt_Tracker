// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loginpagecheck/credit.dart';
import 'package:loginpagecheck/debit.dart';
import 'package:loginpagecheck/credit_forms.dart';
import 'package:loginpagecheck/login_page.dart';
import 'package:loginpagecheck/signup_page.dart';
import 'package:loginpagecheck/welcome_page.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final storage=const FlutterSecureStorage();

  Future<bool>checkLoginStatus() async{
    String? value =await storage.read(key: "uid");
    if(value==null){
      return false;
    }
    return true;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool>snapshot){
          if (snapshot.data==false){
            return LoginScreen();
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Container(
                color: Color.fromARGB(143, 0, 0, 255),
               child: Center(child: CircularProgressIndicator(
              ),),
            );
          }
          return WelcomePage();
        }),
      routes: {
        '/loginpge/':(context) => const LoginScreen(),
        '/register/':(context) =>   const RegistrationScreen(),
        '/home/':(context)=> const WelcomePage(), 
        '/Credit': (context) => Creditpage(),
        '/Debit': (context) => const Debitpage(),
        '/form': (context) => form(),
      },
    );
  }
}


