// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapApp extends StatefulWidget {
  const MapApp({super.key});

  @override
  State<MapApp> createState() => _SigInpAppState();
}

class _SigInpAppState extends State<MapApp> {
  late MapLatLng _markerPosition;
  late MapZoomPanBehavior _mapZoomPanBehavior;
  late MapTileLayerController _controller;
  late MapLatLng selectedPoint;

  @override
  void initState() {
    selectedPoint = const MapLatLng(0, 0);
    _controller = MapTileLayerController();
    _mapZoomPanBehavior = MapZoomPanBehavior(zoomLevel: 6);
    super.initState();
  }

  void updateMarkerChange(Offset position) {
    _markerPosition = _controller.pixelToLatLng(position);
    selectedPoint = _markerPosition;
    if (_controller.markersCount > 0) {
      _controller.clearMarkers();
    }
    _controller.insertMarker(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Séléctionnez un lieu pour votre évènement')),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () async {
            List<String> txt = [
              "Souhaitez vous sauvegarder cette adresse ?",
              "Annuler",
              "Confirmer"
            ];
            if (selectedPoint.toString() == "MapLatLng(0, 0)") {
              txt = [
                "Vous n'avez pas séléctionné d'addresse",
                "Continuer",
                "Quitter",
              ];
            }
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(txt[0]),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(txt[1]),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(txt[2]),
                    ),
                  ],
                );
              },
            );
            if (confirm == true) {
              if (selectedPoint.toString() == "MapLatLng(0, 0)") {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop(
                    'Latitude : "${selectedPoint.latitude}" - Longitude : "${selectedPoint.latitude}"');
              }
            }
          }),
      body: GestureDetector(
        onTapUp: (TapUpDetails details) {
          updateMarkerChange(details.localPosition);
        },
        child: SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              zoomPanBehavior: _mapZoomPanBehavior,
              initialFocalLatLng:
                  const MapLatLng(47.10237958157978, 2.5262953592295556),
              controller: _controller,
              markerBuilder: (BuildContext context, int index) {
                return MapMarker(
                  latitude: _markerPosition.latitude,
                  longitude: _markerPosition.longitude,
                  child: const Icon(Icons.location_on, color: Colors.red),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
