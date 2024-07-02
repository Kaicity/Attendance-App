import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  late LocationData _locData;

  Future<void> initialize() async {
    bool serviceEnable;
    PermissionStatus permission;

    serviceEnable = await location.serviceEnabled();
    if (!serviceEnable) {
      serviceEnable = await location.requestService();
      if (!serviceEnable) {
        return;
      }
    }

    permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<double?> getLatitude() async {
    _locData = await location.getLocation();
    return _locData.latitude;
  }

  Future<double?> getLongitude() async {
    _locData = await location.getLocation();
    return _locData.longitude;
  }
}
