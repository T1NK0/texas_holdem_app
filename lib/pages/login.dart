import 'package:flutter/material.dart';
import 'package:texas_holdem_app/globals.dart';
import 'package:texas_holdem_app/services/http_service.dart';

// Define a custom Form widget.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  //Properties
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  //Widget form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) => FutureBuilder(
              // future: clientService.getLoignToken(),
              builder: (BuildContext context, snapshot) {
            // if (!snapshot.hasData) {
            //   return const CircularProgressIndicator();
            // }
            // _loginToken = 'Bearer ${snapshot.data}';
            return Builder(
              builder: (context) => Center(
                child: Form(
                  key: _formKey,
                  child: Container(
                    height: 110,
                    width: 300,
                    child: Column(children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Angiv ønsket brugernavn',
                          labelText: 'Navn',
                          //Icon at stat of form
                          prefixIcon: const Icon(Icons.person),

                          //Icon to remove data
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => nameController.clear(),
                          ),
                          border: const OutlineInputBorder(),
                        ),

                        //Makes you able to choose already written names from the users history.
                        keyboardType: TextInputType.name,

                        //Makes you able to hit done in the bottom right on your keyboard.
                        textInputAction: TextInputAction.done,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Logger ind')),
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ]),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
