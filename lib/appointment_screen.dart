import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 35),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_new, size: 25),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.more_vert, size: 25),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("images/doctor1.jpg"),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Dr.Docter Name",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Surgeon",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.call,
                          color: Colors.redAccent,
                          size: 25,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          CupertinoIcons.videocam_circle_fill,
                          color: Colors.redAccent,
                          size: 25,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          CupertinoIcons.chat_bubble_text_fill,
                          color: Colors.redAccent,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My aim is good medication for all every people deserve for better medical exposure",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Booking Date",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 25,
                            ),
                            decoration: BoxDecoration(
                              color: index == 1
                                  ? Colors.redAccent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${index + 8}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: index == 1
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                Text(
                                  "May",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: index == 1
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Booking Time",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 60,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 25,
                            ),
                            decoration: BoxDecoration(
                              color: index == 2
                                  ? Colors.redAccent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "${index + 6}:00 PM",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: index == 2
                                      ? Colors.white
                                      : Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(15),
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 4),
          ],
        ),
        child: InkWell(
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Book Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
