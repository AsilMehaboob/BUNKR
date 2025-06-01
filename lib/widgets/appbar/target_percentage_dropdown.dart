// target_percentage_dropdown.dart
import 'package:flutter/material.dart';

class TargetPercentageDropdown extends StatelessWidget {
  final int selectedPercentage;
  final ValueChanged<int> onChanged;

  const TargetPercentageDropdown({
    super.key,
    required this.selectedPercentage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Target:',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 4),
        DropdownButton<int>(
          value: selectedPercentage,
          dropdownColor: const Color(0xFF1E1E1E),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          underline: Container(height: 1, color: Colors.grey[700]),
          items: const [
            DropdownMenuItem<int>(value: 75, child: Text('75%')),
            DropdownMenuItem<int>(value: 80, child: Text('80%')),
            DropdownMenuItem<int>(value: 85, child: Text('85%')),
            DropdownMenuItem<int>(value: 90, child: Text('90%')),
            DropdownMenuItem<int>(value: 95, child: Text('95%')),
          ],
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ],
    );
  }
}