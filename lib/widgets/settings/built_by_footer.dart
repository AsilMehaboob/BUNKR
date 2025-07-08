import 'package:flutter/material.dart';

class BuiltByFooter extends StatelessWidget {
  const BuiltByFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "built by ",
            style: TextStyle(
              fontFamily: 'DM_Mono',
              fontStyle: FontStyle.italic,
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 3),
          Text(
            "zero-day",
            style: TextStyle(
              fontFamily: 'DM_Mono',
              fontStyle: FontStyle.italic,
              color: Colors.red,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
