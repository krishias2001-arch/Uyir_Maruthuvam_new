import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uyir_maruthuvam_new/core/services/patient_services.dart';
import 'package:uyir_maruthuvam_new/data/models/patient_model.dart';


class PatientProfileScreenSetup extends StatefulWidget {
  const PatientProfileScreenSetup({super.key});

  @override
  State<PatientProfileScreenSetup> createState() =>
      _PatientProfileScreenSetupState();

}

class _PatientProfileScreenSetupState extends State<PatientProfileScreenSetup> {
  bool isEditing = false;
  File? _imageFile;
  String? imageUrl;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
final ageController = TextEditingController();
  final patientId = FirebaseAuth.instance.currentUser!.uid; // replace with FirebaseAuth UID
  String? selectedGender;

  final List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
  ];
  @override
  void initState() {
    super.initState();
    loadPatient();
  }
  Future<String?> uploadImage() async {
    if (_imageFile == null) return null;

    final ref = FirebaseStorage.instance
        .ref()
        .child('patient_images/$patientId.jpg');

    await ref.putFile(_imageFile!);

    return await ref.getDownloadURL();
  }
  Future<void> loadPatient() async {
    final patient =
    await PatientService().getPatient(patientId);

    if (patient != null) {
      nameController.text = patient.name;
      emailController.text = patient.email;
      phoneController.text = patient.phone;
      ageController.text = patient.age.toString();
      imageUrl = patient.imageUrl;
      selectedGender = patient.gender; // ✅ IMPORTANT
      setState(() {});
    }
  }

  Future<void> savePatient() async {
    final uploadedUrl = await uploadImage();
    final patient = PatientModel(
      id: patientId,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      age: int.tryParse(ageController.text) ?? 0, // ✅ safe parsing
      gender: selectedGender ?? "", // ✅ from dropdown
      imageUrl: uploadedUrl ?? imageUrl ?? "",
    );

    await PatientService().addPatient(patient);

    setState(() => isEditing = false);
  }
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  InputDecoration buildInput(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                savePatient();
              } else {
                setState(() => isEditing = true);
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child:
          SingleChildScrollView(
            child:
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: isEditing ? pickImage : null,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.redAccent,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (imageUrl != null && imageUrl!.isNotEmpty
                            ? NetworkImage(imageUrl!) as ImageProvider
                            : null),
                        child: (_imageFile == null && (imageUrl == null || imageUrl!.isEmpty))
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    /// NAME
                    TextField(
                      controller: nameController,
                      enabled: isEditing,
                      decoration: buildInput("Name"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      enabled: isEditing,
                      decoration: buildInput("Email"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      enabled: isEditing,
                      decoration: buildInput("phone"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ageController,
                      enabled: isEditing,
                      decoration: buildInput("age"),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: const InputDecoration(
                        labelText: "Gender",
                        border: OutlineInputBorder(),
                      ),
                      items: genderOptions.map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: isEditing
                          ? (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      }
                          : null,
                    ),
                  ],
                ),
              ),

          ),

      ),
    );
  }
}