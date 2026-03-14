import 'package:flutter/material.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {

  String selectedLanguage = "en";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Text(
            "Select Language",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          RadioListTile(
            value: "en",
            groupValue: selectedLanguage,
            title: const Text("English"),
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
              });
            },
          ),

          RadioListTile(
            value: "ta",
            groupValue: selectedLanguage,
            title: const Text("தமிழ்"),
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
              });
            },
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Apply"),
          ),

          const SizedBox(height: 10),

        ],
      ),
    );
  }
}