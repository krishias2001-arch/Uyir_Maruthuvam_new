import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'custom_field.dart';

class SignupScreen extends StatelessWidget {
  final VoidCallback onLoginTap;

  const SignupScreen({super.key, required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FD),
      body: SafeArea(
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
                          'Join us Today',
                          style: TextStyle(
                            color: Color(0xFF4A154B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Create your account',
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
                        gradientColors: [Color(0xFF4A154B), Color(0xFF6B1A6B)],
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        icon: CupertinoIcons.person,
                        hint: 'User name',
                        gradientColors: [Color(0xFF4A154B), Color(0xFF6B1A6B)],
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        icon: CupertinoIcons.lock,
                        hint: 'Password',
                        ispassword: true,
                        gradientColors: [Color(0xFF4A154B), Color(0xFF6B1A6B)],
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        icon: CupertinoIcons.lock,
                        hint: 'Confirm Password',
                        ispassword: true,
                        gradientColors: [Color(0xFF4A154B), Color(0xFF6B1A6B)],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                FadeInUp(
                  duration: Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 400),
                  child: CustomButton(onPressed: () {}, text: 'Create Account'),
                ),
                SizedBox(height: 24),
                FadeIn(
                  duration: Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Color(0xFF1D1C1D)),
                      ),
                      GestureDetector(
                        onTap: onLoginTap,
                        child: Text(
                          'Log In',
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
                                  colors: [Colors.transparent, Color(0xFFE0E0)],
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
                                  colors: [Colors.transparent, Color(0xFFE0E0)],
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
                              icon: Icons.apple,
                              label: 'Apple',
                              gradientColors: [
                                Color(0xFFF000000),
                                Color(0xFF2C2C2C),
                              ],
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
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
  }) {
    return Container(
      height: 55,
      width: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColors[0].withOpacity(0.1),
            gradientColors[1].withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: gradientColors[0]),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: gradientColors[0],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
