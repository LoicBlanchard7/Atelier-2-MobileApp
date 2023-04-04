// ignore_for_file: file_names, must_be_immutable, no_logic_in_create_state, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:reunionou/main.dart';

class MapPreview extends StatefulWidget {
  LatLng center;
  MapPreview(this.center, {super.key});

  @override
  State<MapPreview> createState() => _MappPreviewState(center);
}

class _MappPreviewState extends State<MapPreview> {
  LatLng center;
  _MappPreviewState(this.center);

  late String temperature;
  late String windspeed;

  Future<List<double>> _fetchWeather() {
    return weatherProvider.getWeather(
        center.latitude.toString(), center.longitude.toString());
  }

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
          FutureBuilder<List<double>>(
              future: _fetchWeather(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
                if (snapshot.hasData) {
                  List<double> data = snapshot.data as List<double>;
                  return Container(
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: Table(children: [
                      // const TableRow(children: [
                      //   Center(
                      //       child: Padding(
                      //     padding: EdgeInsets.only(top: 8.0),
                      //     child: Text(
                      //       'Température',
                      //       style: TextStyle(color: Colors.white, fontSize: 30),
                      //     ),
                      //   )),
                      //   Center(
                      //       child: Padding(
                      //     padding: EdgeInsets.only(top: 8.0),
                      //     child: Text('Vent',
                      //         style: TextStyle(color: Colors.white, fontSize: 30)),
                      //   )),
                      // ]),
                      TableRow(children: [
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.thermostat, color: Colors.red),
                              Text('${data[0]} °C',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ],
                          ),
                        )),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.wind_power_outlined),
                              Text('${data[1]} km/h',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ],
                          ),
                        )),
                      ]),
                    ]),
                  );
                }
                return Container();
              }),
        ],
      ),
    );
  }
}
