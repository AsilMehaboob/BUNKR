// institution_card.dart
import 'package:flutter/material.dart';
import '../services/institution_service.dart';

class InstitutionCard extends StatefulWidget {
  const InstitutionCard({super.key});

  @override
  State<InstitutionCard> createState() => _InstitutionCardState();
}

class _InstitutionCardState extends State<InstitutionCard> {
  final InstitutionService _institutionService = InstitutionService();
  int? _selectedInstitutionId;
  int? _initialInstitutionId;
  bool _isSaving = false;

  Future<void> _saveDefaultInstitution() async {
    if (_selectedInstitutionId == null || 
        _selectedInstitutionId == _initialInstitutionId) return;
    
    setState(() => _isSaving = true);
    try {
      // Replace with actual API call to save default institution
      await Future.delayed(const Duration(seconds: 1));
      
      // Update initial ID after successful save
      _initialInstitutionId = _selectedInstitutionId;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Default institution updated'),
          backgroundColor: Colors.green.shade800,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red.shade800,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InstitutionUser>>(
      future: _institutionService.fetchInstitutions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _buildErrorCard(snapshot.error);
        }

        final institutions = snapshot.data!;
        if (institutions.isEmpty) {
          return _buildEmptyStateCard();
        }

        // Set initial institution on first load
        if (_initialInstitutionId == null) {
          _initialInstitutionId = institutions.first.institution.id;
          _selectedInstitutionId = _initialInstitutionId;
        }

        return _buildInstitutionCard(institutions);
      },
    );
  }

 Widget _buildLoadingCard() {
    return Card(
      color: const Color(0xFF1F1F1F),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ListTile(
              title: Text('Institutions',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              subtitle: Text('Loading institutions...',
                  style: TextStyle(color: Colors.grey)),
            ),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(Object? error) {
    return Card(
      color: const Color(0xFF1F1F1F),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            Text(
              'Failed to load institutions: ${error ?? 'Unknown error'}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard() {
    return Card(
      color: const Color(0xFF1F1F1F),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text('No Institutions Found',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text('Contact your administrator to get enrolled',
                  style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstitutionCard(List<InstitutionUser> institutions) {
    return Card(
      color: const Color(0xFF1F1F1F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade800, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Institutions',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const SizedBox(height: 8),
            ...institutions.map((institution) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2B2B).withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedInstitutionId == institution.institution.id
                      ? Colors.blue.shade400
                      : Colors.grey.shade800,
                  width: 1.5,
                ),
              ),
              child: RadioListTile<int>(
                title: Text(
                  institution.institution.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Role: ${institution.institutionRole.name}',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                value: institution.institution.id,
                groupValue: _selectedInstitutionId,
                onChanged: (value) => setState(
                  () => _selectedInstitutionId = value),
                activeColor: Colors.blue.shade400,
                tileColor: Colors.transparent,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            )).toList(),
            const SizedBox(height: 16),
            SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: (_isSaving || _selectedInstitutionId == null || _selectedInstitutionId == _initialInstitutionId)
        ? null
        : _saveDefaultInstitution,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade800,
      foregroundColor: Colors.white,
      // Add disabled colors
      disabledBackgroundColor: Colors.grey.shade800,
      disabledForegroundColor: Colors.grey.shade500,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: _isSaving
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white),
          )
        : const Text('Save as Default',
            style: TextStyle(fontWeight: FontWeight.bold)),
  ),
),
          ],
        ),
      ),
    );
  }
}