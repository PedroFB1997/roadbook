class RoadbookEntry {
  final double totalDistance;
  final double partialDistance;
  final String directionIcon; // e.g. "left", "right", "straight"
  final String? note;

  RoadbookEntry({
    required this.totalDistance,
    required this.partialDistance,
    required this.directionIcon,
    this.note,
  });
}
