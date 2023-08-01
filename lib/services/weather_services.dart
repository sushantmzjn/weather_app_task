import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/api_exception.dart';
import 'package:weather_app/model/weather.dart';


class WeatherService{
static Dio dio= Dio();

//weather search
static Future<Either<String, Weather>> getWeather({
required String searchText
})async{
  try{
    final res =await dio.get(Api.baseUrl,
    queryParameters:{'key': 'caaf6f80535743b39f4153130232903', 'q' : searchText, 'days': 7 });
    final data = Weather.fromJson(res.data);

    // print(res.data);
    return Right(data);
  }on DioError catch(err){
    return Left(DioException.getDioError(err));
  }
}

}