import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/model/weather.dart';
import 'package:weather_app/model/weather_state.dart';
import 'package:weather_app/services/weather_services.dart';

Weather weather = Weather(
    current: Current(
        cloud: 0,
        feelslikeC: 0,
        feelslikeF: 0,
        gustKph: 0,
        gustMph: 0,
        humidity: 0,
        isDay: 0,
        lastUpdated: '',
        lastUpdatedEpoch: 0,
        precipIn: 0,
        precipMm: 0,
        pressureIn: 0,
        pressureMb: 0,
        tempC: 0,
        tempF: 0,
        uv: 0,
        visKm: 0,
        visMiles: 0,
        windDegree: 0,
        windDir: '',
        windKph: 0,
        windMph: 0,
        condition: Condition(icon: '', code: 0, text: '')),
    location: Location(
        name: '',
        country: '',
        lat: 0,
        localtime: '',
        localtimeEpoch: 0,
        lon: 0,
        region: '',
        tzId: ''),
    forecast: Forecast(
      forecastday: [
              ]
    )
);

final weatherProvider = StateNotifierProvider<SearchProvider, WeatherState>(
    (ref) => SearchProvider(WeatherState(
        isError: false,
        errMessage: '',
        isSuccess: false,
        isLoad: false,
        weather: weather)));

class SearchProvider extends StateNotifier<WeatherState> {
  SearchProvider(super.state);

  Future<void> getSearchWeather({required String searchText}) async {
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);

    final res = await WeatherService.getWeather(searchText: searchText);
    res.fold((l) {
      state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(isLoad: false, isError: false, errMessage: '', isSuccess: true, weather: r);
    });
  }
}
