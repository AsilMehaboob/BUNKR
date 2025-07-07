import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
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
  Timer? _refreshTimer;
  final String _trackingUrl = 'https://bunkr-web.vercel.app';

  @override
  void initState() {
    super.initState();
    _loadCount();
    _refreshTimer =
        Timer.periodic(const Duration(seconds: 5), (_) => _loadCount());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadCount() async {
    try {
      final trackingData = await _trackingService.fetchTrackingData();
      setState(() {
        _count = trackingData.length;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Failed to load tracking data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(_trackingUrl);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $_trackingUrl')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCount,
          color: Colors.blue,
          backgroundColor: Colors.black,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blue))
              : _error != null
                  ? _buildErrorWidget()
                  : _buildCountDisplay(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $_error',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadCount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountDisplay() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 73, 83, 91),
                  Color.fromARGB(255, 48, 51, 64)
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 38, 44, 48).withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AnimatedFlipCounter(
                value: _count,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                thousandSeparator: ',',
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                textStyle: const TextStyle(
                  fontSize: 86,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Absence\'s Being Monitored',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Flexible(
                child: Text(
                  'Yep, that’s the number.\nEverything else is on the web. Obviously.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 242),
            child: InkWell(
              onTap: _launchURL,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.open_in_new,
                            color: Colors.blue, size: 13),
                        const SizedBox(width: 8),
                        Text(
                          _trackingUrl,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
