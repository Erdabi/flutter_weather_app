import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weatherhelper.dart';
import 'package:lottie/lottie.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  _WeatherHomeState createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  @override
  void initState() {
    super.initState();
    _loadWeatherByLocation();
  }

  final _controller = TextEditingController();
  final _service = WeatherService();
  Map<String, dynamic>? _weatherData;
  bool _loading = false;

  void _searchWeather() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _loading = true);
    try {
      final data = await _service.fetchWeather(_controller.text.trim());
      setState(() => _weatherData = data);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _loadWeatherByLocation() async {
    setState(() => _loading = true);
    try {
      final position = await getCurrentLocation();
      final data = await _service.fetchWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      setState(() => _weatherData = data);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to get location: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  String getWeatherCondition(String? mainCondition) {
    if (mainCondition == null) return 'lib/assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'lib/assets/Weather-windy.json';
      case 'rain':
      case 'rainy':
        return 'lib/assets/rainy icon.json';
      case 'clear':
      case 'sunny':
        return 'lib/assets/sunny.json';
      default:
        return 'lib/assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Manual city input
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter city',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            if (_loading) ...[
              SizedBox(height: 30),
              CircularProgressIndicator(),
            ],
            if (_weatherData != null) ...[
              SizedBox(height: 30),
              Text(
                "📍 ${_weatherData!['name']}",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text("🌡️ Temp: ${_weatherData!['main']['temp']} °C"),
              Text(
                "☁️ Condition: ${_weatherData!['weather'][0]['description']}",
              ),
            ],
            SizedBox(
              height: 300,
              child: Lottie.asset(
                getWeatherCondition(_weatherData!['weather'][0]['main']),
                fit: BoxFit.contain,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _searchWeather,
                  icon: Icon(Icons.search_rounded),
                  label: Text('Search'),
                ),
                ElevatedButton.icon(
                  onPressed:
                      _loadWeatherByLocation, // new location-based function
                  icon: Icon(Icons.my_location),
                  label: Text("Use My Location"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
