import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String hint;
  final bool ispassword;
  final List<Color> gradientColors;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.hint,
    this.ispassword = false,
    required this.gradientColors,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.ispassword,
        style: TextStyle(color: Color(0xFF1D1C1D)),
        decoration: InputDecoration(
          prefixIcon: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Icon(widget.icon, color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(color: Color(0xFF1D1D1D).withOpacity(0.5)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
