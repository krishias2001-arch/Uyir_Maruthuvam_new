import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:uyir_maruthuvam_new/features/map_services/map_selection_screen.dart';

class DoctorProfileSetupScreen extends StatefulWidget {
  const DoctorProfileSetupScreen({super.key});

  @override
  State<DoctorProfileSetupScreen> createState() =>
      _DoctorProfileSetupScreenState();
}

class _DoctorProfileSetupScreenState extends State<DoctorProfileSetupScreen> {
  bool isEditMode = false;
  String? locationMethod; // "gps" or "map"


  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController clinicController = TextEditingController();
  final TextEditingController clinicaddressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

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
  void _openLocationOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 180,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.my_location),
                title: const Text("Use Current Location"),
                onTap: () async {
                  Navigator.pop(context);

                  final position = await _getCurrentLocation();

                  if (position != null) {
                    setState(() {
                      latitude = position.latitude;
                      longitude = position.longitude;
                      locationAdded = true;
                      locationMethod = "gps";
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Location set using GPS")),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text("Select on Map"),
                onTap: () async {
                  Navigator.pop(context);

                  final selected = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MapSelectionScreen(),
                    ),
                  );

                  if (selected != null) {
                    setState(() {
                      latitude = selected.latitude;
                      longitude = selected.longitude;
                      locationAdded = true;
                      locationMethod = "map";
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Location selected from map")),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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

      feeController.text = (data['fee'] ?? "").toString();
      aboutController.text = data['about'] ?? "";


      
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
      latitude = data['latitude'] as double?;
      longitude = data['longitude'] as double?;
      locationMethod = data['locationMethod'];


      if (latitude != null && longitude != null) {
        locationAdded = true;
      }
    }
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
                  isOptional: true,
                ),
                _buildTextField(
                  registrationController,
                  "Medical Registration Number",
                  isOptional: true,
                ),
                _buildTextField(clinicController, "Clinic / Hospital Name"),
                _buildTextField(clinicaddressController, "Clinic Address"),
                const SizedBox(height: 10),

                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.redAccent),
                  title: const Text("Clinic Location"),
                  subtitle: Text(
                    locationAdded
                        ? "Location set (${locationMethod ?? "unknown"})"
                        : "Not set",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _openLocationOptions,
                ),
                _buildTextField(feeController, "Consultation Fee", keyboardType: TextInputType.number, isOptional: true),
                _buildTextField(aboutController, "About Doctor", isOptional: true),

                const SizedBox(height: 10),


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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uploadedImageUrl = await uploadImage();

    Map<String, dynamic> data = {
      'name': nameController.text,
      'specialization': specializationController.text,
      'clinic': clinicController.text,
      'clinicAddress': clinicaddressController.text,
      'experience': experienceController.text,
      'registration': registrationController.text,
      'phone': phoneController.text,
      'fee': int.tryParse(feeController.text) ?? 0,
      'about': aboutController.text,
      'imageUrl': uploadedImageUrl ?? imageUrl ?? "",
      'profileCompleted': true,
    };
    if (latitude != null && longitude != null) {
      data['latitude'] = latitude;
      data['longitude'] = longitude;
      data['locationMethod'] = locationMethod; // ✅ ADD THIS
    }


    /// ✅ NOW SAVE
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(data, SetOptions(merge: true));



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
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: isOptional ? "$label (Optional)" : label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }
}
