import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  ScrollController controller = ScrollController();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              height: 200,
              width: 400,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),
            ),
            Positioned(
              bottom: 100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget> [
                      FloatingActionButton(
                        onPressed: _onMapTypeButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.map, size: 36.0),
                      ),
                      SizedBox(height: 16.0),
                      FloatingActionButton(
                        onPressed: _onAddMarkerButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.add_location, size: 36.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200,
              height: 500,
              width: 400,
              child: ListView.builder(
                controller: controller,
                itemCount: 5,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text('Rape'),
                    subtitle: Text('A woman raped a man'),
                    onTap: (){
                      print(index);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}