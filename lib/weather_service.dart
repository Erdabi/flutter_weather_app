import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '1055b8dac7c1c47041a75facca678230';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data for $city');
    }
  }

  // 🔹 Fetch by coordinates (for location-based weather)
  Future<Map<String, dynamic>> fetchWeatherByLocation(double lat, double lon) async {
    final url = Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data for your location');
    }
  }


  
}
