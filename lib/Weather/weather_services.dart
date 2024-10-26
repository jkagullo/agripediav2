import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:agripediav3/Weather/weather_model.dart';
import 'package:agripediav3/Weather/weather_services.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to load weather data.");
    }
  }

  Future<String> getCurrentCity() async {
    // check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error("Location services are disabled.");
    }

    // check and request necessary permissions
    await requestLocationPermissions();

    // get current position with high accuracy
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      )
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude
    );

    String? city = placemarks[0].locality;
    print("Current City: $city");

    return city ?? "Unknown City";
  }

  // Permission handling
  Future<void> requestLocationPermissions() async {
    // request fine and coarse location permissions
    PermissionStatus fineLocationStatus = await Permission.location.request();
    if (fineLocationStatus.isDenied || fineLocationStatus.isPermanentlyDenied){
      print("Fine location permission denied");
      return;
    }

    if (await Permission.locationAlways.isDenied){
      PermissionStatus backgroundStatus = await Permission.locationAlways.request();
      if (backgroundStatus.isDenied || backgroundStatus.isPermanentlyDenied){
        print("Background location permission denied");
      }
    }
  }
}