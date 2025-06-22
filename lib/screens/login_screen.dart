import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _showPassword = false;
  String _loginMethod = 'username';
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  final Map<String, Map<String, String>> _loginMethodProps = {
    'username': {
      'label': 'Username',
      'type': 'text',
      'placeholder': 'therealdoe'
    },
    'email': {
      'label': 'Email',
      'type': 'email',
      'placeholder': 'johndoe@gmail.com'
    },
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
    Timer(const Duration(milliseconds: 300),
        () => _animationController.forward());
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    if (_loginController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fields won’t fill themselves, you know.'),
          backgroundColor: const Color.fromARGB(255, 189, 15, 15),
          duration: Duration(seconds: 4),
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    final success = await _authService.login(
      username: _loginController.text.trim(),
      password: _passwordController.text,
      stayLoggedIn: true,
    );

    setState(() => _isLoading = false);

    if (success) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Wrong details? Server meltdown? Who knows."),
          backgroundColor: const Color.fromARGB(255, 189, 15, 15),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildMethodIcon(String method, IconData icon) {
    return IconButton(
        icon: Icon(icon, size: 20),
        color: _loginMethod == method ? Colors.white : Colors.grey,
        onPressed: () => setState(() => _loginMethod = method),
        style: IconButton.styleFrom(
          backgroundColor:
              // ignore: deprecated_member_use
              _loginMethod == method
                  // ignore: deprecated_member_use
                  ? Color(0xFF2B2B2B).withOpacity(0.6)
                  : null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(
            // ignore: deprecated_member_use
            color:
                _loginMethod == method ? Color(0xFF2B2B2B) : Colors.transparent,
            width: 2,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141414),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 520,
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
                          const Image(
                            image: AssetImage("assets/images/logo.png"),
                            width: 38,
                            height: 38,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 0),
                          const Text(
                            'Bunkr',
                            style: TextStyle(
                              fontSize: 56,
                              fontFamily: "Klick",
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 0),
                          const SizedBox(
                            width: 320,
                            child: Text(
                              "Drop your ezygo credentials — we're just the aesthetic upgrade you deserved",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
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
                              // labelText:
                              //     _loginMethodProps[_loginMethod]!['label'],
                              hintText: _loginMethodProps[_loginMethod]![
                                  'placeholder'],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              // prefixIcon: Icon(
                              //   _loginMethod == 'username'
                              //       ? Icons.person
                              //       : _loginMethod == 'email'
                              //           ? Icons.email
                              //           : Icons.phone,
                              // ),
                              labelStyle: TextStyle(color: Colors.grey[300]),
                              filled: true,
                              fillColor: Color(0xFF1F1F1F),
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: Color(0xFF2B2B2B), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            keyboardType: _loginMethod == 'email'
                                ? TextInputType.emailAddress
                                : _loginMethod == 'phone'
                                    ? TextInputType.phone
                                    : TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF1F1F1F),
                        hintText: "••••••••••••",
                        // labelText: 'Password',
                        // prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                        labelStyle: TextStyle(color: Colors.grey[300]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              BorderSide(color: Color(0xFF2B2B2B), width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.white),
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
                        _buildMethodIcon('email', Icons.email_rounded),
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
                              borderRadius: BorderRadius.circular(14)),
                          backgroundColor: Colors.white,
                          elevation: 2,
                          // Add visual feedback for disabled state
                          disabledBackgroundColor:
                          // ignore: deprecated_member_use
                              Colors.white.withOpacity(0.7),
                          disabledForegroundColor:
                          // ignore: deprecated_member_use
                              Colors.black.withOpacity(0.7),
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "built by ",
                              style: TextStyle(
                                fontFamily: 'DM_Mono',
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              "zero-day",
                              style: TextStyle(
                                fontFamily: 'DM_Mono',
                                fontStyle: FontStyle.italic,
                                color: Colors.red,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  ],
                ),
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
