import 'package:flutter/material.dart';

class DamagePanel extends StatelessWidget {
  final int damage;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  const DamagePanel({
    super.key,
    required this.damage,
    required this.onIncrease,
    required this.onDecrease,
    required this.onConfirm,
    required this.onCancel,

  });
    @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          'Enter Damage',
          style: TextStyle(fontSize: 24),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onDecrease,
              icon: const Icon(Icons.remove),
            ),

            Text(
              '$damage',
              style: const TextStyle(fontSize: 64),
            ),

            IconButton(
              onPressed: onIncrease,
              icon: const Icon(Icons.add),
            ),
          ],
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: onCancel,
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: onConfirm,
              child: const Text('Confirm'),
            ),
          ],
        ),
      ],
    );
  }
}