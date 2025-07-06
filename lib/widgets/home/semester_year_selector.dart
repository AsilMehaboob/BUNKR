import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
        _customDropdown<String>(
          value: selectedSemester,
          items: const ['even', 'odd'],
          labelBuilder: (s) => s[0].toUpperCase() + s.substring(1).toLowerCase(),
          onChanged: (v) => onSemesterChanged(v),
        ),
        const SizedBox(width: 16),
        _customDropdown<String>(
          value: selectedYear,
          items: academicYears,
          labelBuilder: (y) => y,
          onChanged: (v) => onYearChanged(v),
        ),
      ],
    );
  }

  Widget _customDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0x90424242)),
        color: Colors.white.withOpacity(0.15),
      ),
      child: DropdownButton2<T>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    labelBuilder(e),
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        style: const TextStyle(color: Colors.white),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color.fromARGB(144, 76, 75, 75)),
            color: Color.fromARGB(255, 49, 48, 48),
          ),
          offset: const Offset(0, -8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        ),
        underline: Container(),
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          height: 40,
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
