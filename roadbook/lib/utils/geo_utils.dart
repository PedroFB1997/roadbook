import 'dart:math';

class GeoUtils {
  static double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // metres
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;

    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) *
            sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // in meters
  }

  static String directionFromAngle(double angle) {
    if (angle.abs() < 15) return 'straight';
    if (angle > 15 && angle < 160) return 'right';
    if (angle < -15 && angle > -160) return 'left';
    return 'u-turn';
  }

  static double angleBetween(double lat1, double lon1, double lat2, double lon2, double lat3, double lon3) {
    final dx1 = lat2 - lat1;
    final dy1 = lon2 - lon1;
    final dx2 = lat3 - lat2;
    final dy2 = lon3 - lon2;

    final angle1 = atan2(dy1, dx1);
    final angle2 = atan2(dy2, dx2);
    final angle = (angle2 - angle1) * 180 / pi;
    return angle;
  }
}
