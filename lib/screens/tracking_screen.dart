import 'package:flutter/material.dart';
import '../widgets/appbar/app_bar.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text(
          'Tracking',
        ),
      ),
    );
  }
}
