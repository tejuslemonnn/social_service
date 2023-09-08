import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_service/models/auto_complete_address_model.dart';
import 'package:social_service/models/routing_direction_model.dart';
import 'package:social_service/repositories/geolocation/geolocation_repository.dart';

class GeoapifyRepository {
  static final Dio _dio = Dio();
  final String apiKey = dotenv.get('GEOAPIFY_API_KEY');
  final GeolocationRepository _geolocationRepository = GeolocationRepository();

  Future<AutoCompleteAddress?> getCurrentPosition() async {
    try {
      final currentLocation = await _geolocationRepository.getCurrentLocation();

      final response = await _dio.get(
        'https://api.geoapify.com/v1/geocode/reverse',
        queryParameters: {
          'lat': currentLocation?.latitude,
          'lon': currentLocation?.longitude,
          'format': 'json',
          'apiKey': apiKey,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;

        AutoCompleteAddress autoCompleteAddress =
            AutoCompleteAddress.fromJson(data);

        return autoCompleteAddress;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching geocoding data: $error');
    }

    return null;
  }

  Future<AutoCompleteAddress?> autoCompleteAddress(String query) async {
    try {
      final response = await _dio.get(
        'https://api.geoapify.com/v1/geocode/autocomplete',
        queryParameters: {
          'text': query,
          'format': 'json',
          'apiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;

        AutoCompleteAddress autoCompleteAddress =
            AutoCompleteAddress.fromJson(data);

        return autoCompleteAddress;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching geocoding data: $error');
    }

    return null;
  }

  Future<RoutingDirection?> routingDirection(
      {required double fromLat,
      required double fromLon,
      required double toLat,
      required double toLon}) async {
    try {
      String apiKey = dotenv.get('GEOAPIFY_API_KEY');
      final response = await _dio.get(
        'https://api.geoapify.com/v1/routing',
        queryParameters: {
          'waypoints': '$fromLat,$fromLon|$toLat,$toLon',
          'mode': 'motorcycle',
          'apiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;

        RoutingDirection routingDirection = RoutingDirection.fromJson(data);

        return routingDirection;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching geocoding data: $error');
    }

    return null;
  }
}
