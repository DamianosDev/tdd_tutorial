import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_tutorial/src/presentation/cubit/authentication_cubit.dart';

class AddUserDialog extends StatelessWidget {
  final TextEditingController nameController;
  const AddUserDialog({required this.nameController, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  const avatar =
                      'https://images.unsplash.com/photo-1472099645785-56'
                      '58abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEy'
                      'MDd9&auto=format&fit=facearea&fa'
                      'cepad=2&w=256&h=256&q=80';

                  context.read<AuthenticationCubit>().createUser(
                        name: name,
                        avatar: avatar,
                        createdAt: DateTime.now().toString(),
                      );
                  Navigator.of(context).pop();
                },
                child: const Text('Create User'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
