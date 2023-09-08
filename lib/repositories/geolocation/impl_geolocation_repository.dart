import 'package:geolocator/geolocator.dart';

abstract class ImplGeolocationRepository {
  Future<void> requestPermission();
  Future<Position?> getCurrentLocation();
}
