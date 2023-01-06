import 'package:flutter/material.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => LoginFormWidgetState();
}

class LoginFormWidgetState extends State<LoginFormWidget> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) => Center(
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            buildName(),
            const SizedBox(height: 24),
          ],
        ),
      );

  Widget buildName() => TextField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: 'Pokerplayer1',
          labelText: 'Name',
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
      );
}
