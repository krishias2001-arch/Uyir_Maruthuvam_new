import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uyir_maruthuvam_new/features/patient/patient_view_doctor_screen.dart';

import 'package:uyir_maruthuvam_new/l10n/app_localizations.dart';

class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key});

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {

  String searchQuery = "";
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final List<String> categories = [
      l10n.all,
      l10n.dental,
      l10n.heart,
      l10n.eye,
      l10n.brain,
      l10n.ear,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchDoctors),
      ),
      body: Column(
        children: [

          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterBottomSheet(context);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          /// 🎯 CATEGORY FILTER
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedCategory == categories[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.redAccent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          /// 📋 DOCTOR LIST
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'doctor')
                  .where('profileCompleted', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var doctors = snapshot.data!.docs;

                /// 🔍 FILTER LOGIC
                var filteredDoctors = doctors.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;

                  String name = (data['name'] ?? '').toLowerCase();
                  String specialization = (data['specialization'] ?? '').toLowerCase();

                  bool matchesSearch = name.contains(searchQuery) ||
                      specialization.contains(searchQuery);

                  bool matchesCategory = selectedCategory == l10n.all ||
                      specialization.contains(selectedCategory.toLowerCase());

                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredDoctors.isEmpty) {
                  return Center(child: Text(l10n.noDoctorsFound));
                }

                return ListView.builder(
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {

                    var doctor = filteredDoctors[index];
                    var data = doctor.data() as Map<String, dynamic>;

                    String doctorId = doctor.id;
                    String name = data['name'] ?? 'Unknown';
                    String specialization = data['specialization'] ?? 'General';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(name),
                        subtitle: Text(specialization),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PatientViewDoctorScreen(
                                doctorId: doctorId,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🎯 FILTER BOTTOM SHEET
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Filters (Coming Soon)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text("• Distance filter"),
              Text("• Rating filter"),
              Text("• Availability filter"),
            ],
          ),
        );
      },
    );
  }
}
