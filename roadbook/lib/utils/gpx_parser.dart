import 'package:gpx/gpx.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/roadbook_entry.dart';
import 'geo_utils.dart';

Future<List<RoadbookEntry>> parseGpxToRoadbook(String assetPath) async {
  final xmlString = await rootBundle.loadString(assetPath);
  final gpx = GpxReader().fromString(xmlString);

  final points = gpx.trks.first.trksegs.expand((seg) => seg.trkpts).toList();
  final List<RoadbookEntry> entries = [];
  double total = 0;

  for (int i = 1; i < points.length - 1; i++) {
    final prev = points[i - 1];
    final curr = points[i];
    final next = points[i + 1];

    final partial = GeoUtils.haversineDistance(
      prev.lat!,
      prev.lon!,
      curr.lat!,
      curr.lon!,
    );
    total += partial;

    final angle = GeoUtils.angleBetween(
      prev.lat!,
      prev.lon!,
      curr.lat!,
      curr.lon!,
      next.lat!,
      next.lon!,
    );
    final dir = GeoUtils.directionFromAngle(angle);

    final note = curr.name ?? curr.desc ?? 'null';

    entries.add(
      RoadbookEntry(
        totalDistance: total / 1000,
        partialDistance: partial,
        directionIcon: dir,
        note: note,
      ),
    );
  }

  return entries;
}
