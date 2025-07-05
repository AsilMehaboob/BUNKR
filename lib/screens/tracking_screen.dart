import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tracking_service.dart';
import '../services/auth_service.dart';
import '../models/track_attendance.dart';

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final TrackingService _trackingService = TrackingService(
    baseUrl: 'your-supabase-function-url',
  );
  
  List<TrackAttendance> _trackingData = [];
  bool _isLoading = true;
  String? _username;
  int _remaining = 0;
  bool _isDeletingAll = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final token = await authService.getToken();
      _username = await authService.getUsername();
      
      if (token != null && _username != null) {
        _trackingData = await _trackingService.fetchTrackingData(token);
        _remaining = await _trackingService.fetchTrackingCount(token, _username!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      _trackingData = [];
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteItem(TrackAttendance item) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final token = await authService.getToken();
      
      if (token != null) {
        await _trackingService.deleteTrackingData(
          token: token,
          username: item.username,
          session: item.session,
          course: item.course,
          date: item.date.toIso8601String(),
        );
        await _loadData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting item: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteAll() async {
    if (_username == null) return;
    
    setState(() => _isDeletingAll = true);
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final token = await authService.getToken();
      
      if (token != null) {
        await _trackingService.deleteAllTrackingData(
          token: token,
          username: _username!,
        );
        await _loadData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting all items: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isDeletingAll = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Tracker'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _trackingData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber, size: 48),
                      SizedBox(height: 16),
                      Text('No Records Found'),
                      Text('You haven\'t added any attendance records yet'),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('Tracked Absences'),
                          SizedBox(height: 8),
                          Text('These are absences you\'ve marked for duty leave'),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Chip(
                                label: Text('Remaining: $_remaining'),
                                backgroundColor: _remaining > 0 
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                              ),
                              _isDeletingAll
                                  ? CircularProgressIndicator()
                                  : TextButton(
                                      onPressed: _deleteAll,
                                      child: Text('Clear All'),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _trackingData.length,
                        itemBuilder: (context, index) {
                          final item = _trackingData[index];
                          return ListTile(
                            title: Text(item.course),
                            subtitle: Text('${item.date.day}/${item.date.month}/${item.date.year} - ${item.session}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteItem(item),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}