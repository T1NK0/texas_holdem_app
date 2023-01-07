// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:texas_holdem_app/globals.dart';
import 'package:texas_holdem_app/pages/gamehub.dart';
import 'package:texas_holdem_app/services/http_service.dart';

// Define a custom Form widget.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Properties
  late String _loginToken = "";
  final HttpClientService clientService = HttpClientService();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _openGameHub() {
    print("-----Gamehub Open-----");
    print('Token: ${currentUser.token}');
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const GamehubPage(),
      ),
    );
  }

  //Widget form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) => FutureBuilder(
              future: clientService.getLoginToken(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                _loginToken = 'Bearer ${snapshot.data}';
                return Builder(
                  builder: (context) => Center(
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                        height: 150,
                        width: 300,
                        child: Column(children: [
                          TextFormField(
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

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Angiv venligst et navn';
                              }
                              return null;
                            },

                            //Makes you able to choose already written names from the users history.
                            keyboardType: TextInputType.name,

                            //Makes you able to hit done in the bottom right on your keyboard.
                            textInputAction: TextInputAction.done,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                await clientService.login(
                                    nameController.value.toString(),
                                    _loginToken);
                                // If the form is valid, display a snackbar.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Logger ind')),
                                );
                                _openGameHub();
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
