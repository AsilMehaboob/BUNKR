// tracking_screen.dart
import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../services/tracking_service.dart';
import '../widgets/appbar/app_bar.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final TrackingService _trackingService = TrackingService();
  int _count = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  Future<void> _loadCount() async {
    try {
      final trackingData = await _trackingService.fetchTrackingData();
      setState(() => _count = trackingData.length);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error', style: const TextStyle(color: Colors.white)))
              : _buildCountDisplay(),
    );
  }

  Widget _buildCountDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _count.toString(),
            style: const TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Attendance records tracked',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(color: Colors.grey, fontSize: 16),
                children: [
                  TextSpan(text: 'For detailed tracking and updates,\n'),
                  TextSpan(text: 'visit '),
                  TextSpan(
                    text: 'https://bunkr-web.vercel.app/tracking',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}