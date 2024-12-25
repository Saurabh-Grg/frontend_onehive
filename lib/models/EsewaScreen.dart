import 'package:flutter/material.dart';

import '../function/esewa.dart';

class EsewaScreen extends StatelessWidget {
  const EsewaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esewa Integration'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Image.network(
            'https://picsum.photos/id/237/200/300',
            width: 300,
            height: 200,
          ),
          Text(
            'Pariatur occaecat elit esse quis.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ElevatedButton(
            child: const Text('Pay with E-Sewa'),
            onPressed: () {
              Esewa esewa = Esewa();
              esewa.pay();
            },
          ),
        ],
      ),
    );
  }
}