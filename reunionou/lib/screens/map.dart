import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  String address = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), centerTitle: true),
      body: OpenStreetMapSearchAndPick(
        center: LatLong(48.6897855, 6.1751375),
        buttonColor: Colors.blue,
        buttonText: 'Sauvegarder cette localisation',
        hintText: 'Rechercher une adresse',
        onPicked: (pickedData) {
          Navigator.of(context).pop(
              'Latitude : "${pickedData.latLong.latitude}" - Longitude : "${pickedData.latLong.longitude}"');
          // print(pickedData.address);
        },
      ),
    );
  }
}
