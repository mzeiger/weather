import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.latitude, required this.longitude});

  final double latitude, longitude;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final double _zoomLevel = 13.0;
  LatLng? _initialPosition;

  @override
  void initState() {
    super.initState();
    _initialPosition = LatLng(widget.latitude, widget.longitude);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text(
            'Location',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                        initialCenter: _initialPosition!,
                        initialZoom: _zoomLevel,
                        interactionOptions: const InteractionOptions(
                          flags: ~InteractiveFlag.doubleTapZoom,
                        )),
                    children: [
                      openStreetMapTileLayer,
                      MarkerLayer(markers: [
                        Marker(
                            point: LatLng(widget.latitude, widget.longitude),
                            child: const Icon(
                              Icons.location_on_sharp,
                              color: Colors.red,
                              size: 60,
                            ))
                      ])
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
