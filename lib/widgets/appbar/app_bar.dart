import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'profile_dropdown.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AuthService authService = AuthService();

  static const double _gapHeight = 5.0;
  static const double _borderHeight = 1.0;
  static const double _bottomTotalHeight = _gapHeight + _borderHeight;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFF1F1F1F),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_bottomTotalHeight),
        child: Padding(
          padding: const EdgeInsets.only(top: _gapHeight),
          child: Container(
            height: _borderHeight,
            color: const Color.fromARGB(112, 66, 66, 66),
          ),
        ),
      ),
      title: const Text(
        'Bunkr',
        style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w600,
            fontFamily: 'Klick',
            color: Colors.white,
            letterSpacing: 2),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: authService.client
                .get('/Xcr45_salt/myprofile')
                .then((res) => res.data),
            builder: (context, profileSnapshot) {
              return FutureBuilder<Map<String, dynamic>>(
                future: authService.client
                    .get('/Xcr45_salt/user')
                    .then((res) => res.data),
                builder: (context, userSnapshot) {
                  return ProfileDropdown(
                    profile: profileSnapshot.data,
                    user: userSnapshot.data,
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + _bottomTotalHeight);
}
