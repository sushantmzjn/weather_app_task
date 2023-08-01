import 'package:weather_app/model/weather.dart';

class WeatherState {
  final bool isError;
  final String errMessage;
  final bool isSuccess;
  final bool isLoad;
  final Weather weather;

  WeatherState({
    required this.isError,
    required this.errMessage,
    required this.isSuccess,
    required this.isLoad,
    required this.weather,
  });

  WeatherState copyWith(
      {bool? isError,
      String? errMessage,
      bool? isSuccess,
      bool? isLoad,
      Weather? weather}) {
    return WeatherState(
      isError: isError ?? this.isError,
      errMessage: errMessage ?? this.errMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoad: isLoad ?? this.isLoad,
      weather: weather ?? this.weather,
    );
  }
}
