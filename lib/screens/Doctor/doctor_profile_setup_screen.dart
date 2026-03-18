import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
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
  File? _image;
  String? imageUrl;
  final ImagePicker _picker = ImagePicker();
  double? latitude;
  double? longitude;
  bool locationAdded = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }


  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location services
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enable location services")),
      );
      return null;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  Future<String?> uploadImage() async {
    if (_image == null) return imageUrl;

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final storage = FirebaseStorage.instanceFor(
        bucket: 'uyirmaruthuvam-d3601.firebasestorage.app',
      );

      final ref = storage
          .ref()
          .child('doctor_images')
          .child('$uid.jpg');

      await ref.putFile(_image!);

      final downloadUrl = await ref.getDownloadURL();

      print("Download URL: $downloadUrl");

      return downloadUrl;

    } catch (e) {
      print("UPLOAD ERROR: $e");
      return null;
    }
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
      
      final loadedImageUrl = data['imageUrl'] as String?;
      print('Loaded image URL from Firestore: $loadedImageUrl');
      
      setState(() {
        imageUrl = loadedImageUrl;
      });

      if (data['profileCompleted'] ?? false) {
        setState(() {
          isEditMode = true;
        });
      }
      latitude = data['latitude'];
      longitude = data['longitude'];

      if (latitude != null && longitude != null) {
        locationAdded = true;
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
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.blueAccent,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: Stack(
                        children: [
                          if (_image != null)
                            ClipOval(
                              child: Image.file(
                                _image!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          else if (imageUrl != null && imageUrl!.isNotEmpty)
                            ClipOval(
                              child: Image.network(
                                imageUrl!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.person, size: 40, color: Colors.grey);
                                },
                              ),
                            )
                          else
                            const Icon(Icons.camera_alt, size: 40, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: () async {
                    final position = await _getCurrentLocation();

                    if (position != null) {
                      setState(() {
                        latitude = position.latitude;
                        longitude = position.longitude;
                        locationAdded = true;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Location added successfully")),
                      );
                    }
                  },
                  icon: const Icon(Icons.location_on),
                  label: Text(
                    locationAdded ? "Location Added ✓" : "Add Clinic Location (Optional)",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    locationAdded ? Colors.green : Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
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

    final uploadedImageUrl = await uploadImage();

    print("Uploaded image URL: $uploadedImageUrl");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'name': nameController.text,
      'specialization': specializationController.text,
      'clinic': clinicController.text,
      'experience': experienceController.text,
      'registration': registrationController.text,
      'clinicAddress': clinicaddressController.text,
      'phone': phoneController.text,
      'imageUrl': uploadedImageUrl ?? "",
      'profileCompleted': true,

      // ✅ NEW (optional)
      'latitude': latitude,
      'longitude': longitude,

    }, SetOptions(merge: true));

    setState(() {
      imageUrl = uploadedImageUrl;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          locationAdded
              ? "Profile saved with location"
              : "Profile saved (add location later for map visibility)",
        ),
      ),
    );
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
