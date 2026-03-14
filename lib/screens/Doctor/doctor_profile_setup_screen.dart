import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/Doctor_main_screen.dart';
class DoctorProfileSetupScreen extends StatefulWidget {
  const DoctorProfileSetupScreen({super.key});

  @override
  State<DoctorProfileSetupScreen> createState() =>
      _DoctorProfileSetupScreenState();
}

class _DoctorProfileSetupScreenState extends State<DoctorProfileSetupScreen> {
  bool isEditMode = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController clinicController = TextEditingController();
  final TextEditingController clinicaddressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    
    final data = userDoc.data();
    if (data != null) {
      nameController.text = data['name'] ?? "";
      specializationController.text = data['specialization'] ?? "";
      clinicController.text = data['clinic'] ?? "";
      experienceController.text = data['experience'] ?? "";
      registrationController.text = data['registration'] ?? "";
      clinicaddressController.text = data['clinicAddress'] ?? "";
      phoneController.text = data['phone'] ?? "";

      if (data['profileCompleted'] ?? false) {
        setState(() {
          isEditMode = true;
        });
      }
    }
  }

  Future<void> saveProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name': nameController.text,
      'specialization': specializationController.text,
      'clinic': clinicController.text,
      'experience': experienceController.text,
      'registration': registrationController.text,
      'clinicAddress': clinicaddressController.text,
      'phone': phoneController.text,
      'profileCompleted': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Profile" : "Complete Doctor Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(nameController, "Full Name"),
                _buildTextField(specializationController, "Specialization"),
                _buildTextField(
                  experienceController,
                  "Years of Experience",
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  registrationController,
                  "Medical Registration Number",
                ),
                _buildTextField(clinicController, "Clinic / Hospital Name"),
                _buildTextField(clinicaddressController, "Clinic Address"),
                _buildTextField(
                  phoneController,
                  "Phone Number",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'name': nameController.text,
                            'specialization': specializationController.text,
                            'clinic': clinicController.text,
                            'experience': experienceController.text,
                            'registration': registrationController.text,
                            'clinicAddress': clinicaddressController.text,
                            'phone': phoneController.text,
                            'profileCompleted': true,
                          });
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile completed successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      isEditMode ? "Save Changes" : "Save & Continue",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }
}
