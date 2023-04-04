// ignore_for_file: file_names, must_be_immutable, no_logic_in_create_state, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatefulWidget {
  LatLng center;
  MapPreview(this.center, {super.key});

  @override
  State<MapPreview> createState() => _MappPreviewState(center);
}

class _MappPreviewState extends State<MapPreview> {
  LatLng center;
  _MappPreviewState(this.center);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Localisation de l'évènement"), centerTitle: true),
      body: Column(
        children: [
          Flexible(
              child: FlutterMap(
            options: MapOptions(
              center: center,
              zoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                      point: center,
                      builder: (context) => const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                          )),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}
