import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/scan_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import GoogleMap and LatLng


// usa tambien ipinfo.io/188.86.28.212/geo
class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType _mapType = MapType.normal;
  String? _publicIp;

  @override
  void initState() {
    super.initState();
    _fetchPublicIp();
  }

  Future<void> _fetchPublicIp() async {
    final response = await http.get(Uri.parse('https://api.ipify.org/?format=json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _publicIp = data['ip'];
      });
    } else {
      throw Exception('Failed to load public IP');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context)!.settings.arguments as ScanModel;
    final CameraPosition _puntInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17,
      tilt: 50,
    );

    final Set<Marker> markers = {
      Marker(
        markerId: MarkerId('id1'),
        position: scan.getLatLng(),
      )
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
        actions: [
          IconButton(
            icon: Icon(
              _mapType == MapType.normal ? Icons.satellite : Icons.map,
            ),
            onPressed: () {
              setState(() {
                _mapType = (_mapType == MapType.normal) ? MapType.satellite : MapType.normal;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: _mapType,
            markers: markers,
            initialCameraPosition: _puntInicial,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          if (_publicIp != null)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Text('Public IP: $_publicIp'),
              ),
            ),
        ],
      ),
    );
  }
}