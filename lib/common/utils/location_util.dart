/* File to get location of user
* used dependencies - location => to get location coordinates of user,
*   - geoLocation => To get Address from the location coordinates
 */
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

Future<LocationData> getLocation() async {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.granted) {
    return await location.getLocation();
  } else {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted == PermissionStatus.granted) {
      return await location.getLocation();
    }
    return null;
  }
}

Future<Address> getUserLocation() async {
  try {
    LocationData currentLocation = await getLocation();
    if (currentLocation == null) {
      return null;
    }
    final coordinates =
        Coordinates(currentLocation.latitude, currentLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return first;
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      print(e.message);
    }
    if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
      print(e.message);
    }
  }
  return null;
}
