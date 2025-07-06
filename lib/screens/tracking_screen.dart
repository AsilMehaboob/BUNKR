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
  final ProfileService _profileService = ProfileService();
  final TrackingService _trackingService = TrackingService();
  List<dynamic> _trackingData = [];
  int _remaining = 0;
  int _currentPage = 0;
  final int _itemsPerPage = 5;
  bool _isLoading = true;
  String? _error;
  String? _username;
  Map<String, bool> _deletingStates = {};
  bool _isDeletingAll = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

// Modify the _loadData() method to use TrackingService
Future<void> _loadData() async {
  try {
    debugPrint('🚀 Starting _loadData()...');
    
    final profile = await _profileService.fetchProfile();
    setState(() => _username = profile['username']);
    debugPrint('✅ Username: $_username');

    // Use TrackingService instead of direct HTTP calls
    debugPrint('📊 Calling fetchTrackingData()...');
    final trackingData = await _trackingService.fetchTrackingData();
    setState(() => _trackingData = trackingData.map((item) => item.toJson()).toList());
    debugPrint('✅ Received ${trackingData.length} tracking records');

    debugPrint('🔢 Calling fetchTrackingCount()...');
    final remaining = await _trackingService.fetchTrackingCount();
    setState(() => _remaining = remaining);
    debugPrint('✅ Remaining slots: $_remaining');

  } catch (e) {
    debugPrint('❌ Error loading data: $e');
    setState(() => _error = e.toString());
  } finally {
    setState(() => _isLoading = false);
    debugPrint('🏁 _loadData() completed');
  }
}
  void _goToPrevPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() => _currentPage++);
    }
  }

  Future<void> _handleDeleteRecord(
    String session,
    String course,
    String date,
  ) async {
    final key = '$session-$course-$date';
    setState(() => _deletingStates[key] = true);
    
    try {
      await _trackingService.deleteTrackingRecord(
        session,
        course,
        DateTime.parse(date),
      );
      await _loadData();
    } catch (e) {
      print('Error deleting record: $e');
      // Handle error - you might want to show a snackbar
    } finally {
      setState(() => _deletingStates.remove(key));
    }
  }

  Future<void> _handleDeleteAll() async {
    setState(() => _isDeletingAll = true);
    
    try {
      await _trackingService.deleteAllTrackingRecords();
      await _loadData();
      setState(() => _currentPage = 0);
    } catch (e) {
      print('Error deleting all records: $e');
      // Handle error - you might want to show a snackbar
    } finally {
      setState(() => _isDeletingAll = false);
    }
  }

  int get _totalPages => (_trackingData.length / _itemsPerPage).ceil();

  List<dynamic> get _currentPageItems {
    final start = _currentPage * _itemsPerPage;
    final end = start + _itemsPerPage;
    return _trackingData.sublist(
      start,
      end > _trackingData.length ? _trackingData.length : end,
    );
  }

  String _formatSessionName(String sessionName) {
    const romanToOrdinal = {
      'I': '1st hour',
      'II': '2nd hour',
      'III': '3rd hour',
      'IV': '4th hour',
      'V': '5th hour',
      'VI': '6th hour',
      'VII': '7th hour',
    };
    return romanToOrdinal[sessionName] ?? sessionName;
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
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(
          child: _trackingData.isEmpty
              ? _buildEmptyState()
              : _buildTrackingList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Tracker',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "These are absences you've marked for duty leave. Track their update status here",
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          _buildBadges(),
        ],
      ),
    );
  }

  Widget _buildBadges() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _remaining < 4 ? Colors.amber.withOpacity(0.12) : Colors.green.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _remaining < 4 ? Colors.amber.withOpacity(0.15) : Colors.green.withOpacity(0.15),
            ),
          ),
          child: Text(
            'You can add $_remaining more attendance ${_remaining == 1 ? 'record' : 'records'}',
            style: TextStyle(
              color: _remaining < 4 ? Colors.amber : Colors.green,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (_trackingData.isNotEmpty)
          TextButton(
            onPressed: _isDeletingAll ? null : _handleDeleteAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              backgroundColor: Colors.red.withOpacity(0.12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.red.withOpacity(0.15)),
              ),
            ),
            child: _isDeletingAll
                ? Row(
                    children: [
                      Text(
                        'Clearing...',
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Text(
                        'Clear all tracking data',
                        style: TextStyle(color: Colors.red),
                      ),
                      Icon(Icons.delete, color: Colors.red, size: 18),
                    ],
                  ),
          ),
      ],
    );
  }

  Widget _buildTrackingList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _currentPageItems.length,
            itemBuilder: (context, index) {
              final item = _currentPageItems[index];
              return _buildTrackItem(item);
            },
          ),
        ),
        if (_totalPages > 1) _buildPagination(),
      ],
    );
  }

  Widget _buildTrackItem(Map<dynamic, dynamic> item) {
    final status = item['status'] ?? 'Absent';
    final statusColor = {
      'Present': Colors.blue,
      'Absent': Colors.red,
      'Duty Leave': Colors.orange,
      'Other Leave': Colors.teal,
    }[status] ?? Colors.grey;

    final key = '${item['session']}-${item['course']}-${item['date']}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    item['course'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item['date'].toString().split('T')[0]} • ${_formatSessionName(item['session'])}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: _deletingStates[key] == true
                      ? null
                      : () => _handleDeleteRecord(
                            item['session'],
                            item['course'],
                            item['date'].toString().split('T')[0],
                          ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: Colors.amber.withOpacity(0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.amber.withOpacity(0.2)),
                    ),
                  ),
                  child: _deletingStates[key] == true
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.amber,
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              status == 'Absent' ? 'Not updated yet' : 'Updated',
                              style: TextStyle(color: Colors.amber),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.delete, color: Colors.amber, size: 18),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _goToPrevPage,
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: _currentPage == 0
                  ? Colors.grey[800]
                  : Colors.grey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Page ${_currentPage + 1} of $_totalPages',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: _goToNextPage,
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: _currentPage == _totalPages - 1
                  ? Colors.grey[800]
                  : Colors.grey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info, color: Colors.amber, size: 40),
          const SizedBox(height: 16),
          const Text(
            'No Records Found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "You haven't added any attendance records to tracking yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}