import 'package:flutter/material.dart';

class LoadingColum extends StatelessWidget {
  final String message;
  const LoadingColum({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 10,
          ),
          Text('$message...'),
        ],
      ),
    );
  }
}
