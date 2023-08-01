import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/view/hour_forecast.dart';

class HomePage extends ConsumerStatefulWidget {

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  LocationPermission? permission;
  Position? position;


  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _requestLocationPermission();
    super.initState();
  }

void _requestLocationPermission()async{
  permission = await Geolocator.requestPermission();
  if(permission==LocationPermission.denied){
    permission = await Geolocator.requestPermission();
  }else if(permission == LocationPermission.deniedForever){
    await Geolocator.openAppSettings();
  }else if(permission == LocationPermission.always || permission==LocationPermission.whileInUse){
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('permission allowed');
    if(position!=null){
      print(position);
      List<Placemark> placemarks = await placemarkFromCoordinates(position!.latitude, position!.longitude);
      print(placemarks[0]);
      searchTextController.text = placemarks[0].subAdministrativeArea!;
      ref.read(weatherProvider.notifier).getSearchWeather(searchText: searchTextController.text.trim());

    }else{

    }
  }
}

  @override
  Widget build(BuildContext context) {
    final weatherData = ref.watch(weatherProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchTextController,
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (val){
                        if(val.isEmpty){
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.symmetric(vertical: 60.0, horizontal: 16.0),
                              duration: Duration(seconds: 1),
                              content: Text('Required')));
                        }else{
                          FocusScope.of(context).unfocus();
                          ref.read(weatherProvider.notifier).getSearchWeather(
                              searchText: searchTextController.text.trim()
                          );
                        }

                      },
                      decoration: InputDecoration(
                        suffixIcon: const Icon(CupertinoIcons.search,color: Colors.deepPurple,),
                        hintText: 'Search',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)
                        ),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(color: Colors.deepPurple)),
                          enabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide:const BorderSide(color: Colors.grey),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: ()async {
                    searchTextController.text.isEmpty ? Container() :
                    ref.refresh(weatherProvider.notifier).getSearchWeather(searchText: searchTextController.text.trim());
                    },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           weatherData.isLoad ? const Center(child: Padding(
                             padding: EdgeInsets.all(8.0),
                             child: CupertinoActivityIndicator(),
                           )) : weatherData.isError ? Center(child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text(weatherData.errMessage),
                           )) :
                           Container(),
                           Text('${weatherData.weather.current.feelslikeC.toString()} C', style: TextStyle(fontSize: 48.sp),),
                           Text(weatherData.weather.current.condition.text, style: TextStyle(fontSize: 16.sp),),
                           Text('Wind Direction : ${weatherData.weather.current.windDir}', style: TextStyle(fontSize: 16.sp),),
                           weatherData.weather.current.condition.icon.isEmpty ? Container() :
                           Image.network('http:${weatherData.weather.current.condition.icon}'),
                           SizedBox(height: 10.h),
                           Container(
                             decoration: BoxDecoration(
                                 color: Colors.black54,
                                 borderRadius: BorderRadius.circular(8.0),
                                 boxShadow: [
                                   BoxShadow(
                                       color: Colors.grey.withOpacity(0.5),
                                       spreadRadius: 2,
                                       blurRadius: 5,
                                       offset: Offset(3,0)
                                   )
                                 ]
                             ),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text('Details', style: TextStyle(fontSize: 18.sp),),
                                   SizedBox(height: 8.h),
                                   Row(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Column(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text('Wind', style: TextStyle(fontSize: 18.sp)),
                                           Text('${weatherData.weather.current.windMph} Mph', ),
                                           SizedBox(height: 10.h),
                                           Text('Humidity', style: TextStyle(fontSize: 18.sp)),
                                           Text('${weatherData.weather.current.humidity.toString()} %', ),
                                           SizedBox(height: 10.h),
                                           Text('Visibility', style: TextStyle(fontSize: 18.sp)),
                                           Text('${weatherData.weather.current.visMiles.toString()} mi',),
                                         ],
                                       ),
                                       SizedBox(width: 50.w),
                                       Column(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text('Pressure', style: TextStyle(fontSize: 18.sp),),
                                           Text('${weatherData.weather.current.pressureIn} inHg', ),
                                           SizedBox(height: 10.h),
                                           Text('UV',style: TextStyle(fontSize: 18.sp)),
                                           Text(weatherData.weather.current.uv.toString(),),
                                           SizedBox(height: 10.h),
                                         ],
                                       )
                                     ],
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           SizedBox(height: 20.h),
                           Container(
                             decoration: BoxDecoration(
                                 color: Colors.black54,
                                 borderRadius: BorderRadius.circular(8.0),
                                 boxShadow: [
                                   BoxShadow(
                                       color: Colors.grey.withOpacity(0.5),
                                       spreadRadius: 2,
                                       blurRadius: 5,
                                       offset: Offset(3,0)
                                   )
                                 ]
                             ),
                             child: Column(
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.all(16.0),
                                   child: Row(
                                     children: [
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: const [
                                           Text('Country'),
                                           Text('Name'),
                                           Text('Time'),
                                           Text('Region'),
                                         ],
                                       ),
                                       SizedBox(width: 10.w),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: const [
                                           Text(':' ),
                                           Text(':' ),
                                           Text(':' ),
                                           Text(':' )
                                         ],
                                       ),
                                       SizedBox(width: 10.w),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(weatherData.weather.location.country.isEmpty ? 'N/A' : weatherData.weather.location.country),
                                           Text(weatherData.weather.location.name.isEmpty ? 'N/A' : weatherData.weather.location.name),
                                           Text(weatherData.weather.location.localtime.isEmpty ? 'N/A' : weatherData.weather.location.localtime),
                                           Text(weatherData.weather.location.region.isEmpty ? 'N/A' : weatherData.weather.location.region),

                                         ],
                                       ),
                                     ],
                                   ),
                                 )
                               ],
                             ),
                           ),
                           SizedBox(height: 20.h),
                           Container(
                             height: 140.h,
                             width: double.infinity,
                             decoration: BoxDecoration(
                                 color: Colors.black54,
                                 borderRadius: BorderRadius.circular(8.0),
                                 boxShadow: [
                                   BoxShadow(
                                       color: Colors.grey.withOpacity(0.5),
                                       spreadRadius: 2,
                                       blurRadius: 5,
                                       offset: Offset(3,0)
                                   )
                                 ]
                             ),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                     child: Text('Daily Forecast'),
                                   ),
                                   Container(
                                     height: 90.h,
                                     width: double.infinity,
                                     child: ListView.builder(
                                         scrollDirection: Axis.horizontal,
                                         shrinkWrap: true,
                                         physics: const BouncingScrollPhysics(),
                                         itemCount: weatherData.weather.forecast.forecastday.length,
                                         itemBuilder: (ctx, index){

                                           return Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                             children: [
                                               InkWell(
                                                 onTap: (){
                                                   Get.to(()=> HourForecast(forecastday: weatherData.weather.forecast.forecastday[index],));
                                                 },
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.center,
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   children: [
                                                     Text(DateFormat('d LLL, E').format(DateTime.parse(weatherData.weather.forecast.forecastday[index].date,)),
                                                       style: TextStyle(fontSize: 10.sp),),
                                                     Image.network('http:${weatherData.weather.forecast.forecastday[index].day.condition.icon}'),
                                                     Text(weatherData.weather.forecast.forecastday[index].day.condition.text,
                                                     style: TextStyle(fontSize: 10.sp),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                               SizedBox(width: 10.w)
                                             ],
                                           );
                                         }),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ],
                       ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
