import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/l10n/app_localizations.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';

class SignupScreen extends StatelessWidget {
  final VoidCallback onLoginTap;

  const SignupScreen({super.key, required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                          l10n.joinUsToday,
                          style: TextStyle(
                            color: Color(0xFF4A154B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        l10n.createYourAccount,
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
                        hint: l10n.email,
                        gradientColors: [Color(0xFF4A154B), Color(0xFF6B1A6B)],
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        icon: CupertinoIcons.person,
                        hint: l10n.userName,
                        gradientColors: [Color(0xFF4A154B), Color(0xFF6B1A6B)],
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        icon: CupertinoIcons.lock,
                        hint: l10n.password,
                        ispassword: true,
                        gradientColors: [Color(0xFF4A154B), Color(0xFF6B1A6B)],
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        icon: CupertinoIcons.lock,
                        hint: l10n.confirmPassword,
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
                  child: CustomButton(onPressed: () {}, text: l10n.createAccount),
                ),
                SizedBox(height: 24),
                FadeIn(
                  duration: Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.alreadyHaveAccount,
                        style: TextStyle(color: Color(0xFF1D1C1D)),
                      ),
                      GestureDetector(
                        onTap: onLoginTap,
                        child: Text(
                          ' ${l10n.login}',
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
                                  colors: [Colors.transparent, Color(0xFFE0E0E0)],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              l10n.orContinueWith,
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
                                  colors: [Colors.transparent, Color(0xFFE0E0E0)],
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
                              label: l10n.apple,
                              gradientColors: [
                                Color(0xFF000000),
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
