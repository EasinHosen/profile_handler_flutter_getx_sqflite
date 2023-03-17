import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenPage extends StatefulWidget {
  const MapScreenPage({Key? key}) : super(key: key);

  @override
  State<MapScreenPage> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreenPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 10.0,
  );

  List<Marker> marker = [];
  LatLng? selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select location'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: selectedPosition);
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: initialPosition,
          mapType: MapType.normal,
          onMapCreated: (controller) => _controller.complete(controller),
          onTap: _handleTap,
          markers: Set.from(marker),
        ),
      ),
    );
  }

  void _handleTap(LatLng pos) {
    setState(() {
      marker = [];
      marker.add(
        Marker(
          markerId: MarkerId(
            pos.toString(),
          ),
          position: pos,
        ),
      );
      selectedPosition = pos;
    });
  }
}
