import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uyir_maruthuvam_new/features/patient/screens/patient_view_doctor_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final userId = FirebaseAuth.instance.currentUser!.uid;
    
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
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = userSnapshot.data!.data() as Map<String, dynamic>?;
                List<String> favorites = List<String>.from(data?['favorites'] ?? []);

                return StreamBuilder(
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
                        String specialization = (data['specialization'] ?? '')
                            .toLowerCase();

                        bool matchesSearch = name.contains(searchQuery) ||
                            specialization.contains(searchQuery);

                        bool matchesCategory = selectedCategory == l10n.all ||
                            specialization.contains(
                                selectedCategory.toLowerCase());

                        return matchesSearch && matchesCategory;
                      }).toList();

                      if (filteredDoctors.isEmpty) {
                        return Center(child: Text(l10n.noDoctorsFound));
                      }

                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredDoctors.length,
                          itemBuilder: (context, index) {
                            var doctor = filteredDoctors[index];
                            var data = doctor.data() as Map<String, dynamic>;

                            String doctorId = doctor.id;
                            String name = data['name'] ?? 'Unknown';
                            String specialization = data['specialization'] ??
                                'General';
                            String imageUrl = data['imageUrl'] ?? '';
                            bool isFavorite = favorites.contains(doctorId);
                            double rating = (data['rating'] ?? 0).toDouble();

                            return Container(
                                height: 320,
                                width: 200,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PatientViewDoctorScreen(
                                                      doctorId: doctorId,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius
                                                .only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                            child: Container(
                                              height: 160,
                                              width: 200,
                                              color: Colors.grey[300],
                                              child: imageUrl.isNotEmpty
                                                  ? Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              )
                                                  : const Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            height: 35,
                                            width: 35,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  spreadRadius: 2,
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () async {
                                                final userRef = FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(userId);

                                                if (isFavorite) {
                                                  await userRef.update({
                                                    'favorites': FieldValue
                                                        .arrayRemove([doctorId])
                                                  });
                                                } else {
                                                  await userRef.update({
                                                    'favorites': FieldValue
                                                        .arrayUnion([doctorId])
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.redAccent,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black.withOpacity(
                                                  0.8),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            specialization,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black.withOpacity(
                                                  0.6),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                rating == 0 ? "0.0" : rating.toStringAsFixed(1),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black.withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: SizedBox(
                                        height: 35,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PatientViewDoctorScreen(
                                                        doctorId: doctorId),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                          ),
                                          child: Text(
                                            l10n.bookAppointment,
                                            style: const TextStyle(
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )

                            );
                          }
                      );
                    }
                );
              }
                  )
                  )
                  ]
                  )


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
