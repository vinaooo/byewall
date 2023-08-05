import 'package:flutter/material.dart';

class DonationsScreen extends StatelessWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations'),
      ),
      body: Center(
        child: Text(
          'Donations',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
