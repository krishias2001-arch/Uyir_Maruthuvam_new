import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DoctorMapScreen extends StatefulWidget {
  const DoctorMapScreen({super.key});

  @override
  State<DoctorMapScreen> createState() => _DoctorMapScreenState();
}

class _DoctorMapScreenState extends State<DoctorMapScreen> {

  GoogleMapController? mapController;

  final LatLng initialPosition = const LatLng(11.0168, 76.9558);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctors Near You")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 14,
        ),
        myLocationEnabled: true,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}