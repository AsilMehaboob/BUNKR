import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class TargetAttendanceDropdown extends StatelessWidget {
  final int targetPercentage;
  final ValueChanged<int> onChanged;

  const TargetAttendanceDropdown({
    super.key,
    required this.targetPercentage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0x60313131),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Target Attendance:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0x90424242)),
              color: Colors.white.withOpacity(0.15),
            ),
            child: DropdownButton2<int>(
              value: targetPercentage,
              items: [75, 80, 85, 90, 95]
                  .map((e) => DropdownMenuItem<int>(
                        value: e,
                        child: Text('$e%', style: const TextStyle(color: Colors.white)),
                      ))
                  .toList(),
              onChanged: (val) => onChanged(val!),
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
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                width: 90,
              ),
              menuItemStyleData: const MenuItemStyleData(height: 40),
            ),
          ),
        ],
      ),
    );
  }
}
