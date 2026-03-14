import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../patient_view_docter_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  HomeScreen({super.key, required this.username});
  final List<String> catNames = ["Dental", "Heart", "Eye", "Brain", "Ear"];

  final List<Icon> catIcons = [
    Icon(MdiIcons.toothOutline, color: Colors.redAccent, size: 30),
    Icon(MdiIcons.heartPlus, color: Colors.redAccent, size: 30),
    Icon(MdiIcons.eye, color: Colors.redAccent, size: 30),
    Icon(MdiIcons.brain, color: Colors.redAccent, size: 30),
    Icon(MdiIcons.earHearing, color: Colors.redAccent, size: 30),
  ];

  final List<String> imgs = [
    "images/doctor1.jpg",
    "images/doctor2.jpg",
    "images/doctor3.jpg",
    "images/doctor4.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          "images/patient_profile.jpg",
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Hello, $username",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F8FF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 4,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Colors.redAccent,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                    left: 15,
                    right: 15,
                    bottom: 20,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 3,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "symptoms",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 110,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: catNames.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 15,
                              ),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(child: catIcons[index]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              catNames[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Our Best Doctors",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                Container(
                  height: 340,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: imgs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            height: 300,
                            width: 200,
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
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
                                                DocterScreen(doctorId: 'doctor_${index + 1}'),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        child: Image.asset(
                                          imgs[index],
                                          height: 200,
                                          width: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
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
                                        child: Center(
                                          child: Icon(
                                            Icons.favorite_outline,
                                            color: Colors.redAccent,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Dr.Doctor Name",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                      Text(
                                        "Surgeon",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.amber),
                                          SizedBox(width: 5),
                                          Text(
                                            "4.9",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black.withOpacity(
                                                0.6,
                                              ),
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
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
