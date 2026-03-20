import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Clinic Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: selectedLocation != null
                ? () {
                    Navigator.pop(context, {
                      'latitude': selectedLocation!.latitude,
                      'longitude': selectedLocation!.longitude,
                    });
                  }
                : null,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(13.0827, 80.2707), // Default: Chennai
          zoom: 12,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        onTap: (LatLng location) {
          setState(() {
            selectedLocation = location;
            _markers.clear();
            _markers.add(
              Marker(
                markerId: const MarkerId('selected_location'),
                position: location,
                infoWindow: const InfoWindow(title: 'Clinic Location'),
              ),
            );
          });
        },
        markers: _markers,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = LatLng(position.latitude, position.longitude);
      
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: location, zoom: 15),
        ),
      );

      setState(() {
        selectedLocation = location;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: location,
            infoWindow: const InfoWindow(title: 'Current Location'),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }
}