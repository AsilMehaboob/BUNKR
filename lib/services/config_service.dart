import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigService {
  static String? _baseUrl;
  static String? _apiSalt;
  static String? _supabaseAnonKey;
  static String? _supabaseUrl;

  static String get baseUrl => _baseUrl!;
  static String get apiSalt => _apiSalt!;
  static String get supabaseAnonKey => _supabaseAnonKey!;
  static String get supabaseUrl => _supabaseUrl!;

  static String get apiBaseUrl => '$_baseUrl/api/v1/$_apiSalt';

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
    _baseUrl = dotenv.env['BASE_URL'];
    _apiSalt = dotenv.env['API_SALT'];
    _supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    _supabaseUrl = dotenv.env['SUPABASE_URL'];

    if (_baseUrl == null || _apiSalt == null || _supabaseAnonKey == null || _supabaseUrl == null) {
      throw Exception('Missing required environment variables: BASE_URL, API_SALT, SUPABASE_ANON_KEY, and SUPABASE_URL');
    }
  }
}