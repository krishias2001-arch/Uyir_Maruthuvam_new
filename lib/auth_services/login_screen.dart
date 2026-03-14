
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/screens/role_selection_screen.dart';
import 'custom_button.dart';
import 'custom_field.dart';
import 'package:uyir_maruthuvam_new/auth_services/google_auth.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onSignupTap;
  const LoginScreen({Key? key, required this.onSignupTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FD),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),

          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  FadeInDown(
                    duration: Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF4A154B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: Color(0xFF4A154B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Log in to your account',
                          style: TextStyle(
                            color: Color(0xFF4A154B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  FadeInUp(
                    duration: Duration(milliseconds: 600),
                    delay: Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        CustomTextField(
                          icon: CupertinoIcons.mail,
                          hint: 'Email',
                          gradientColors: [
                            Color(0xFF4A154B),
                            Color(0xFF6B1A6B),
                          ],
                        ),
                        SizedBox(height: 40),
                        CustomTextField(
                          icon: CupertinoIcons.lock,
                          hint: 'Password',
                          ispassword: true,
                          gradientColors: [
                            Color(0xFF4A154B),
                            Color(0xFF6B1A6B),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  FadeInUp(
                    duration: Duration(milliseconds: 600),
                    delay: Duration(milliseconds: 400),
                    child: CustomButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RoleSelectionScreen(),
                          ),
                        );
                      },
                      text: 'Log In',
                    ),
                  ),
                  SizedBox(height: 24),
                  FadeIn(
                    duration: Duration(milliseconds: 600),
                    delay: Duration(milliseconds: 600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Color(0xFF1D1C1D)),
                        ),
                        GestureDetector(
                          onTap: onSignupTap,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xFF4A154B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  FadeInUp(
                    duration: Duration(milliseconds: 600),
                    delay: Duration(milliseconds: 800),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xFFE0E0E0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Or continue With",
                                style: TextStyle(
                                  color: Color(0xFF1D1C1D),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0x00ffe0e0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElasticIn(
                              duration: Duration(milliseconds: 800),
                              delay: Duration(milliseconds: 1200),
                              child: _buildSocialButton(
                                icon: Icons.g_mobiledata,
                                label: 'Google',
                                gradientColors: [
                                  Color(0xFFDB4437),
                                  Color(0xFFF66D5B),
                                ],
                                onTap: () async {
                                  try {
                                    UserCredential? result = await GoogleAuth().signInWithGoogle();
                                    if (result != null && context.mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const RoleSelectionScreen(),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Sign-in failed: $e'),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            ElasticIn(
                              duration: Duration(milliseconds: 800),
                              delay: Duration(milliseconds: 1200),
                              child: _buildSocialButton(
                                icon: Icons.apple,
                                label: 'Apple',
                                gradientColors: [
                                  Color(0xff000000),
                                  Color(0xFF2C2C2C),
                                ],
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
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
}

Widget _buildSocialButton({
  required IconData icon,
  required String label,
  required List<Color> gradientColors,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 55,
      width: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColors[0].withOpacity(0.1),
            gradientColors[1].withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: gradientColors[0]),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: gradientColors[0],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
