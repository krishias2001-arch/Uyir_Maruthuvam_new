import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PatientStorageScreen extends StatefulWidget {
  const PatientStorageScreen({super.key});

  @override
  State<PatientStorageScreen> createState() => _PatientStorageScreenState();
}

class _PatientStorageScreenState extends State<PatientStorageScreen> {

  final ImagePicker picker = ImagePicker();

  Future pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      uploadFile(file);
    }
  }

  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      uploadFile(file);
    }
  }

  Future uploadFile(File file) async {

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    await FirebaseStorage.instance
        .ref("patient_uploads/$fileName")
        .putFile(file);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Upload successful")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Storage"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            ElevatedButton.icon(
              icon: const Icon(Icons.photo),
              label: const Text("Upload from Gallery"),
              onPressed: pickImage,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.insert_drive_file),
              label: const Text("Upload File"),
              onPressed: pickFile,
            ),

          ],
        ),
      ),
    );
  }
}