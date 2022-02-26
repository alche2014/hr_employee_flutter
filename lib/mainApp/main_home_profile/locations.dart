import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoHelper {
  static Future<Map<String, String>> getLocationName(LatLng location) async {
    Map<String, String> markPlace = Map();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    Placemark first = placemarks.first;
    markPlace['street'] = first.street!;
    markPlace['sublocality'] = first.subLocality!;
    markPlace['locality'] = first.locality!;
    return markPlace;
  }
}
