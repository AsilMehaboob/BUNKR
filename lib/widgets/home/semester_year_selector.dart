import 'package:flutter/material.dart';

class SemesterYearSelector extends StatelessWidget {
  final String selectedSemester;
  final String selectedYear;
  final int selectedPercentage;
  final ValueChanged<String> onSemesterChanged;
  final ValueChanged<String> onYearChanged;
  final ValueChanged<int> onPercentageChanged;

  const SemesterYearSelector({
    super.key,
    required this.selectedSemester,
    required this.selectedYear,
    required this.selectedPercentage,
    required this.onSemesterChanged,
    required this.onYearChanged,
    required this.onPercentageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dropdown<String>(
          value: selectedSemester,
          items: const ['even', 'odd'],
          labelBuilder: (s) => s.toLowerCase(),
          onChanged: (v) => v != null ? onSemesterChanged(v) : null,
        ),
        const SizedBox(width: 16),
        _dropdown<String>(
          value: selectedYear,
          items: const ['2023-24', '2024-25', '2025-26'],
          labelBuilder: (y) => y,
          onChanged: (v) => v != null ? onYearChanged(v) : null,
        ),
        const SizedBox(width: 16),
        _dropdown<int>(
          value: selectedPercentage,
          items: const [75, 80, 85, 90, 95],
          labelBuilder: (p) => '$p%',
          onChanged: (v) => v != null ? onPercentageChanged(v) : null,
        ),
      ],
    );
  }

  DropdownButton<T> _dropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButton<T>(
      dropdownColor: const Color(0xFF1E1E1E),
      value: value,
      style: const TextStyle(color: Colors.white),
      underline: Container(height: 1, color: Colors.grey[700]),
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(
                  labelBuilder(e),
                  style: const TextStyle(color: Colors.white),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}