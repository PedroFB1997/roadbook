import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/gpx_parser.dart';
import '../models/roadbook_entry.dart';
import 'package:logger/logger.dart';

class RoadbookScreen extends StatefulWidget {
  const RoadbookScreen({super.key, required String gpxFilePath});

  @override
  State<RoadbookScreen> createState() => _RoadbookScreenState();
}

class _RoadbookScreenState extends State<RoadbookScreen> {
  late Future<List<RoadbookEntry>> _entries;
  double currentSpeed = 0.0; // km/h
  double _realDistance = 0.0;
  Position? _lastPosition;

  @override
  void initState() {
    super.initState();
    _entries = parseGpxToRoadbook('assets/Pantanitos.gpx');
    _startTrackingSpeed();
  }

  void _startTrackingSpeed() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (!serviceEnabled || permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen((Position position) {
        setState(() {
          currentSpeed = position.speed * 3.6;
          if (_lastPosition != null) {
            _realDistance += Geolocator.distanceBetween(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              position.latitude,
              position.longitude,
            );
          }
          _lastPosition = position;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rally Roadbook')),
      body: FutureBuilder<List<RoadbookEntry>>(
        future: _entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }

          final entries = snapshot.data!;
          return Column(
            children: [
              Expanded(
                flex: 8,
                child: ListView.separated(
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    Logger().d(entry);
                    return ListTile(
                      leading: SvgPicture.asset(
                        'assets/icons/${entry.directionIcon}.svg',
                        height: 30,
                        width: 30,
                      ),
                      title: Text(
                        '${entry.totalDistance.toStringAsFixed(2)} km  (+${entry.partialDistance.toStringAsFixed(2)} m)',
                      ),
                      subtitle: Text(entry.note ?? '—'),
                    );
                  },
                ),
              ),
              const Divider(thickness: 2),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoBox(
                        'Velocidad',
                        '${currentSpeed.toStringAsFixed(1)} km/h',
                      ),
                      _infoBox(
                        'Distancia total',
                        '${(_realDistance / 1000).toStringAsFixed(2)} km',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
