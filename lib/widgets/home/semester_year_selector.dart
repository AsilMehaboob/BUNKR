import 'package:flutter/material.dart';
import '../home/shadcn_select.dart';

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
    final now = DateTime.now();
    final currentYear = now.year;
    final academicYears = <String>[];
    for (int year = currentYear; year >= 2018; year--) {
      final nextYearTwoDigits = (year + 1).toString().substring(2);
      academicYears.add('$year-$nextYearTwoDigits');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _labeledDropdown<String>(
          label: 'semester:',
          value: selectedSemester,
          items: const ['even', 'odd'],
          labelBuilder: (s) => s.toLowerCase(),
          onChanged: (v) => onSemesterChanged(v),
        ),
        const SizedBox(width: 16),
        _labeledDropdown<String>(
          label: 'year:',
          value: selectedYear,
          items: academicYears,
          labelBuilder: (y) => y,
          onChanged: (v) => onYearChanged(v),
        ),
      ],
    );
  }

  Widget _labeledDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 4),
        ShadSelect<T>(
          value: value,
          placeholder: Text(
            labelBuilder(value),
            style: const TextStyle(color: Colors.white),
          ),
          options: items
              .map((e) => ShadOption<T>(
                    value: e,
                    child: Text(
                      labelBuilder(e),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
          selectedOptionBuilder: (context, value) => Text(
            labelBuilder(value),
            style: const TextStyle(color: Colors.white),
          ),
          onChanged: onChanged,
          minWidth: 120,
        ),
      ],
    );
  }
}
