import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weatherhelper.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
  } finally {
    setState(() => _loading = false);
  }
}


  void _loadWeatherByLocation() async {
  setState(() => _loading = true);
  try {
    final position = await getCurrentLocation();
    final data = await _service.fetchWeatherByLocation(position.latitude, position.longitude);
    setState(() => _weatherData = data);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to get location: $e")));
  } finally {
    setState(() => _loading = false);
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
            decoration: InputDecoration(labelText: 'Enter city'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _searchWeather,
                child: Text('Search'),
              ),
              ElevatedButton.icon(
                onPressed: _loadWeatherByLocation, // new location-based function
                icon: Icon(Icons.my_location),
                label: Text("Use My Location"),
              ),
            ],
          ),
          if (_loading) ...[
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
          if (_weatherData != null) ...[
            SizedBox(height: 20),
            Text("📍 ${_weatherData!['name']}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("🌡️ Temp: ${_weatherData!['main']['temp']} °C"),
            Text("☁️ Condition: ${_weatherData!['weather'][0]['description']}"),
          ],
        ],
      ),
    ),
  );
}
}
