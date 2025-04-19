import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:flutter/animation.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _showPassword = false;
  String _loginMethod = 'username';
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  final Map<String, Map<String, String>> _loginMethodProps = {
    'username': {'label': 'Username', 'type': 'text', 'placeholder': 'therealdoe'},
    'email': {'label': 'Email', 'type': 'email', 'placeholder': 'johndoe@gmail.com'},
    'phone': {'label': 'Phone', 'type': 'tel', 'placeholder': '919234567890'},
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    Timer(const Duration(milliseconds: 300), () => _animationController.forward());
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    final success = await _authService.login(
      username: _loginController.text.trim(),
      password: _passwordController.text,
      stayLoggedIn: true,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _errorMessage = 'Login failed. Please try again.');
    }
  }

  Widget _buildMethodIcon(String method, IconData icon) {
    return IconButton(
      icon: Icon(icon, size: 20),
      color: _loginMethod == method ? Colors.blue : Colors.grey,
      onPressed: () => setState(() => _loginMethod = method),
      style: IconButton.styleFrom(
        backgroundColor: _loginMethod == method ? Colors.blue.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'welcome to ',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  const Color(0xFF6CA2AB),
                                  const Color(0xFFB0CBCA),
                                  const Color(0xFFCCD9D6),
                                  const Color(0xFFEDBEA2),
                                ],
                                stops: const [0.0, 0.33, 0.66, 1.0],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: const Text(
                                'bunkr',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "use your ezygo credentials!",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey(_loginMethod),
                      children: [
                        TextField(
                          controller: _loginController,
                          decoration: InputDecoration(
                            labelText: _loginMethodProps[_loginMethod]!['label'],
                            hintText: _loginMethodProps[_loginMethod]!['placeholder'],
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(
                              _loginMethod == 'username' 
                                ? Icons.person
                                : _loginMethod == 'email'
                                  ? Icons.email
                                  : Icons.phone,
                            ),
                            labelStyle: TextStyle(color: Colors.grey[300]),
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[600]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          keyboardType: _loginMethod == 'email'
                              ? TextInputType.emailAddress
                              : _loginMethod == 'phone'
                                  ? TextInputType.phone
                                  : TextInputType.text,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                      labelStyle: TextStyle(color: Colors.grey[300]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMethodIcon('username', Icons.person),
                      const SizedBox(width: 8),
                      _buildMethodIcon('email', Icons.email),
                      const SizedBox(width: 8),
                      _buildMethodIcon('phone', Icons.phone),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Colors.white,
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Text(
                        'ezygo says...\n$_errorMessage',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 32),
                  AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 500),
                    child: const Text(
                      '"ezygo handles the login - we don\'t see your info, '
                      'and honestly, we don\'t want to" ~ admin',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}