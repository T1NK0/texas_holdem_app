import 'package:flutter/material.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => LoginFormWidgetState();
}

class LoginFormWidgetState extends State<LoginFormWidget> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) => Center(
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            buildEmail(),
            const SizedBox(height: 24),
          ],
        ),
      );

  Widget buildEmail() => TextField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'examle@example.com',
          labelText: 'Email',
          //Icon at stat of form
          prefixIcon: const Icon(Icons.mail),

          //Icon to remove data
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => emailController.clear(),
          ),
          border: const OutlineInputBorder(),
        ),

        //Makes you able to choose already written emails.
        keyboardType: TextInputType.emailAddress,

        //Makes you able to hit done in the bottom right on your keyboard.
        textInputAction: TextInputAction.done,
      );
}
