import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/local/gpsTrackModel.dart';

class MapScreen extends StatefulWidget {
  final List<GpsTrackModel> trackList;
  final bool canGoArrow;
  const MapScreen({super.key, required this.trackList, required this.canGoArrow});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [      
              GoogleMap(
                      initialCameraPosition: CameraPosition(
                target: LatLng(widget.trackList.first.latitude! ?? 43.03,
                    widget.trackList.first.longitude!),
                zoom: 13.5),
                      markers: {
              Marker(
                  markerId: const MarkerId("source"),
                  position: LatLng(widget.trackList.first.latitude!,
                      widget.trackList.first.longitude!)),
              Marker(
                  markerId: const MarkerId("destination"),
                  position: LatLng(widget.trackList.last.latitude!,
                      widget.trackList.last.longitude!))
                      },
                      polylines: {
              Polyline(
                width: 5,
                color: Colors.blue,
                  polylineId: const PolylineId("route"),
                  points: widget.trackList
                      .map((e) => LatLng(e.latitude!, e.longitude!))
                      .toList())
                      },
                    ),
                                 if(widget.canGoArrow) Positioned(
                              top: 40,
                              left: 20,
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.3)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ), 
            ],
          )),
    );
  }
}
