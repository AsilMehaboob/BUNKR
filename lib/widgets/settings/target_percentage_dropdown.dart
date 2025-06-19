import 'package:flutter/material.dart';
import '../home/shadcn_select.dart';

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
        ShadSelect<int>(
          value: selectedPercentage,
          placeholder: Text(
            '$selectedPercentage%',
            style: const TextStyle(color: Colors.white),
          ),
          options:[
            ShadOption(value: 75, child: Text('75%', style: TextStyle(color: Colors.white))),
            ShadOption(value: 80, child: Text('80%', style: TextStyle(color: Colors.white))),
            ShadOption(value: 85, child: Text('85%', style: TextStyle(color: Colors.white))),
            ShadOption(value: 90, child: Text('90%', style: TextStyle(color: Colors.white))),
            ShadOption(value: 95, child: Text('95%', style: TextStyle(color: Colors.white))),
          ],
          selectedOptionBuilder: (context, value) => Text(
            '$value%',
            style: const TextStyle(color: Colors.white),
          ),
          onChanged: onChanged,
          minWidth: 110,
        ),
      ],
    );
  }
}