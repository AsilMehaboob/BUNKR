// institution_card.dart
import 'package:flutter/material.dart';
import '../../services/institution_service.dart';

class InstitutionCard extends StatefulWidget {
  const InstitutionCard({super.key});

  @override
  State<InstitutionCard> createState() => _InstitutionCardState();
}

class _InstitutionCardState extends State<InstitutionCard> {
  final InstitutionService _service = InstitutionService();
  List<InstitutionUser> _institutions = [];
  int? _selectedId;
  int? _defaultId;
  bool _isLoading = true;
  bool _isUpdating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final institutions = await _service.fetchStudentInstitutions();
      final defaultId = await _service.getDefaultInstitutionUser();
      
      final validDefault = institutions.any((i) => i.id == defaultId);
      if (!validDefault && institutions.isNotEmpty) {
        await _service.updateDefaultInstitutionUser(institutions.first.id);
        _defaultId = institutions.first.id;
      } else {
        _defaultId = defaultId;
      }

      setState(() {
        _institutions = institutions;
        _selectedId = _defaultId;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateDefault() async {
    if (_selectedId == null || _selectedId == _defaultId) return;

    setState(() => _isUpdating = true);
    try {
      await _service.updateDefaultInstitutionUser(_selectedId!);
      setState(() => _defaultId = _selectedId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Default institution updated'),
          backgroundColor: Colors.green.shade800,
        ),
      );
    } catch (e) {
      setState(() => _selectedId = _defaultId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update failed: ${e.toString()}'),
          backgroundColor: Colors.red.shade800,
        ),
      );
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Widget _buildLoading() {
    return Card(
      color: const Color(0xFF1F1F1F),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading institutions...',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Card(
      color: const Color(0xFF1F1F1F),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 40),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Failed to load institutions',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstitutionList() {
    return Column(
      children: _institutions.map((inst) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B).withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedId == inst.id
                ? Colors.blue.shade400
                : Colors.grey.shade800,
            width: 1.5,
          ),
        ),
        child: RadioListTile<int>(
          title: Text(
            inst.institution.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            'Role: ${inst.institutionRole.name}',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          value: inst.id,
          groupValue: _selectedId,
          onChanged: _isUpdating ? null : (value) => setState(() => _selectedId = value),
          activeColor: Colors.blue.shade400,
          tileColor: Colors.transparent,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoading();
    if (_errorMessage != null) return _buildError();
    if (_institutions.isEmpty) {
      return Card(
        color: const Color(0xFF1F1F1F),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.school, color: Colors.grey, size: 40),
              const SizedBox(height: 16),
              Text(
                'No Institutions Found',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Contact your administrator to get enrolled',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: const Color(0xFF1F1F1F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade800,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Institutions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 16),
            _buildInstitutionList(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUpdating || _selectedId == _defaultId
                    ? null
                    : _updateDefault,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade800,
                  disabledForegroundColor: Colors.grey.shade500,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUpdating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save as Default',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}