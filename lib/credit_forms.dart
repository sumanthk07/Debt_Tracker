//form1.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loginpagecheck/credit.dart';
import '../firebase_options.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

// Modify the previous main() function
Future<void> forms() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(form());
}

class form extends StatelessWidget {
  Widget build(BuildContext context) {
    final appTitle = 'Details';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: Text(appTitle), backgroundColor: Color.fromARGB(143, 0, 0, 255)),
        body: MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  final controllerName = TextEditingController();
  final controllerphone_no = TextEditingController();
  final controllerAmount = TextEditingController();
  final controllerDueDate = TextEditingController();

  @override
  void initState() {
    dateinput.text = " "; //set the initial value of text field
    super.initState();
  }

  final format = DateFormat("yyyy-MM-dd");
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: controllerName,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter your full name',
              labelText: 'Name',
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
            controller: controllerphone_no,
            decoration: const InputDecoration(
              icon: const Icon(Icons.phone),
              hintText: 'Enter a phone number',
              labelText: 'Phone',
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please enter valid phone number';
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
            controller: controllerAmount,
            decoration: const InputDecoration(
              icon: const Icon(Icons.wallet),
              hintText: 'Enter an amount',
              labelText: 'Amount',
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please enter valid phone number';
              }
              return null;
            },
          ),
          DateTimeField(
            controller: controllerDueDate,
            decoration: const InputDecoration(
                icon: const Icon(Icons.calendar_today), //icon of text field
                labelText: "Due Date" //label text of field
                ),
            format: format,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color.fromARGB(143, 0, 0, 255), // <-- SEE HERE
                        onPrimary: Colors.white, // <-- SEE HERE
                        onSurface: Colors.black, // <-- SEE HERE
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          primary: Color.fromARGB(143, 0, 0, 255), // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
            },
          ),
          Container(
            padding: const EdgeInsets.only(left: 150.0, top: 40.0),
            child: RaisedButton(
              child: const Text('Submit'),
              onPressed: () {
                // It returns true if the form is valid, otherwise returns false

                final user = User(
                    name: controllerName.text,
                    phone_no: controllerphone_no.text,
                    Amount: controllerAmount.text,
                    DueDate: DateTime.parse(controllerDueDate.text));
                createUser(user);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => new Credit())));
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future createUser(User user) async {
  final db=FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final uid=_auth.currentUser?.uid;
  final docUser = db.collection('userdata').doc(uid).collection('credit');
  user.id = docUser.id;
  final json = user.toJson();
  await docUser.add(json);
}

class User {
  String id;
  final String name;
  final String phone_no;
  final String Amount;
  final DateTime DueDate;

  User({
    this.id = '',
    required this.name,
    required this.phone_no,
    required this.Amount,
    required this.DueDate,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone_no': phone_no,
        'Amount': Amount,
        'DueDate': DueDate,
      };
}
