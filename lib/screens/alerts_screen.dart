import 'package:bunkr/widgets/appbar/app_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/alerts/notifications_card.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _selectedPercentage = 75; // Added local state for percentage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        targetPercentage: _selectedPercentage,
        onTargetChanged: (value) {
          setState(() {
            _selectedPercentage = value;
          });
        },
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: CardNotifications(),
      ),
    );
  }
}