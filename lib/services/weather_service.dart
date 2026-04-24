import 'dart:async';
import 'package:flutter/material.dart';

enum WeatherCondition { sunny, cloudy, rainy, night }

class WeatherService extends ChangeNotifier {
  WeatherCondition _currentCondition = WeatherCondition.sunny;
  String _currentTime = '';
  Timer? _timer;

  WeatherService() {
    _updateTime();
    _determineWeather();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  WeatherCondition get currentCondition => _currentCondition;
  String get currentTime => _currentTime;

  void _updateTime() {
    final now = DateTime.now();
    _currentTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    
    // Check if weather condition needs update based on time
    if (now.hour >= 18 || now.hour < 6) {
      if (_currentCondition != WeatherCondition.night) {
        _currentCondition = WeatherCondition.night;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  void _determineWeather() {
    // Simple logic to simulate weather
    final hour = DateTime.now().hour;
    if (hour >= 18 || hour < 6) {
      _currentCondition = WeatherCondition.night;
    } else if (hour >= 6 && hour < 10) {
      _currentCondition = WeatherCondition.sunny;
    } else if (hour >= 10 && hour < 15) {
      _currentCondition = WeatherCondition.cloudy;
    } else {
      _currentCondition = WeatherCondition.rainy;
    }
    notifyListeners();
  }

  List<Color> get backgroundGradient {
    switch (_currentCondition) {
      case WeatherCondition.sunny:
        return [Colors.lightBlue[300]!, Colors.blue[600]!];
      case WeatherCondition.cloudy:
        return [Colors.blueGrey[300]!, Colors.blueGrey[600]!];
      case WeatherCondition.rainy:
        return [Colors.indigo[400]!, Colors.indigo[900]!];
      case WeatherCondition.night:
        return [Colors.black87, const Color(0xFF191970)];
    }
  }

  IconData get weatherIcon {
    switch (_currentCondition) {
      case WeatherCondition.sunny:
        return Icons.wb_sunny;
      case WeatherCondition.cloudy:
        return Icons.cloud;
      case WeatherCondition.rainy:
        return Icons.umbrella;
      case WeatherCondition.night:
        return Icons.nights_stay;
    }
  }

  String get weatherText {
    switch (_currentCondition) {
      case WeatherCondition.sunny:
        return "Cerah";
      case WeatherCondition.cloudy:
        return "Berawan";
      case WeatherCondition.rainy:
        return "Hujan";
      case WeatherCondition.night:
        return "Malam Hari";
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

extension on Colors {
  static Color? get midnightBlue => const Color(0xFF191970);
}
