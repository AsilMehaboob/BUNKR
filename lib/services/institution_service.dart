// institution_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';
import 'config_service.dart';

class InstitutionService {
  final AuthService _authService = AuthService();
  final String _baseUrl = ConfigService.apiBaseUrl;

  Future<List<InstitutionUser>> fetchStudentInstitutions() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/institutionusers/myinstitutions'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      final institutions = data.map((j) => InstitutionUser.fromJson(j)).toList();
      
      // Filter student institutions
      final studentInstitutions = institutions.where(
        (i) => i.institutionRole.name.toLowerCase() == 'student'
      ).toList();

      if (studentInstitutions.isEmpty) {
        throw Exception('No student institutions found');
      }

      return studentInstitutions;
    }
    throw Exception('Failed to load institutions (status ${response.statusCode})');
  }

  Future<int> getDefaultInstitutionUser() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/user/setting/default_institutionUser'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as int;
    }
    throw Exception('Failed to fetch default institution user');
  }

  Future<void> updateDefaultInstitutionUser(int institutionUserId) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/user/setting/default_institutionUser'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'default_institutionUser': institutionUserId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update default institution user');
    }
  }
}

class InstitutionUser {
  final int id;
  final String firstName;
  final String lastName;
  final Institution institution;
  final InstitutionRole institutionRole;

  InstitutionUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.institution,
    required this.institutionRole,
  });

  factory InstitutionUser.fromJson(Map<String, dynamic> json) {
    return InstitutionUser(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      institution: Institution.fromJson(json['institution']),
      institutionRole: InstitutionRole.fromJson(json['institution_role']),
    );
  }
}

class Institution {
  final int id;
  final String name;
  final String type;

  Institution({required this.id, required this.name, required this.type});

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}

class InstitutionRole {
  final int id;
  final String name;

  InstitutionRole({required this.id, required this.name});

  factory InstitutionRole.fromJson(Map<String, dynamic> json) {
    return InstitutionRole(
      id: json['id'],
      name: json['name'],
    );
  }
}