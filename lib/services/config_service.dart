import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigService {
  static String? _baseUrl;
  static String? _apiSalt;
  
  static String get baseUrl => _baseUrl!;
  static String get apiSalt => _apiSalt!;
  
  static String get apiBaseUrl => '$_baseUrl/api/v1/$_apiSalt';

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
    _baseUrl = dotenv.env['BASE_URL'];
    _apiSalt = dotenv.env['API_SALT'];
    
    if (_baseUrl == null || _apiSalt == null) {
      throw Exception('Missing required environment variables: BASE_URL and API_SALT');
    }
  }
}