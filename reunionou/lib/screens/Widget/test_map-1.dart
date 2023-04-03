// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

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
    return FlutterMap(
      options: MapOptions(
        // center: LatLng(currentLocation.latitude!,
        //     currentLocation.longitude!),
        center: center,
        minZoom: 18,
        maxZoom: 18,
        zoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        // MarkerLayer(
        // markers: setMarkerList(),
        // ),
      ],
    );
    // return const SfMaps(
    //   layers: [
    //     MapTileLayer(
    //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    //       initialZoomLevel: 12,
    //       // initialFocalLatLng: MapLatLng(47.10237958157978, 2.5262953592295556),
    //       initialFocalLatLng: center,
    //       // controller: _controller,
    //       // markerBuilder: (BuildContext context, int index) {
    //       //   return MapMarker(
    //       //     latitude: _markerPosition.latitude,
    //       //     longitude: _markerPosition.longitude,
    //       //     child: const Icon(Icons.location_on, color: Colors.red),
    //       //   );
    //       // },
    //     ),
    //   ],
    // );
  }
}
