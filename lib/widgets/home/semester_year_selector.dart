import 'package:flutter/material.dart';

class SemesterYearSelector extends StatelessWidget {
  final String selectedSemester;
  final String selectedYear;
  final ValueChanged<String> onSemesterChanged;
  final ValueChanged<String> onYearChanged;

  const SemesterYearSelector({
    super.key,
    required this.selectedSemester,
    required this.selectedYear,
    required this.onSemesterChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _labeledDropdown<String>(
          label: 'semester:',
          value: selectedSemester,
          items: const ['even', 'odd'],
          labelBuilder: (s) => s.toLowerCase(),
          onChanged: (v) => v != null ? onSemesterChanged(v) : null,
        ),
        const SizedBox(width: 16),
        _labeledDropdown<String>(
          label: 'year:',
          value: selectedYear,
          items: const ['2023-24', '2024-25', '2025-26'],
          labelBuilder: (y) => y,
          onChanged: (v) => v != null ? onYearChanged(v) : null,
        ),
      ],
    );
  }

  Widget _labeledDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 4),
        DropdownButton<T>(
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
        ),
      ],
    );
  }
}