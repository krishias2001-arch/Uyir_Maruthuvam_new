import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClinicLocationMapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const ClinicLocationMapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng clinicLocation = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clinic Location"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: clinicLocation,
          zoom: 15,
        ),

        /// ✅ Show marker
        markers: {
          Marker(
            markerId: const MarkerId("clinic"),
            position: clinicLocation,
            infoWindow: const InfoWindow(
              title: "Clinic Location",
            ),
          ),
        },

        /// ✅ Optional improvements
        myLocationEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}