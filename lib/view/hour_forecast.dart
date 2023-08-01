import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather.dart';

import '../provider/weather_provider.dart';

class HourForecast extends ConsumerWidget {
  final Forecastday forecastday;
  HourForecast({required this.forecastday});

  @override
  Widget build(BuildContext context, ref) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            children: [
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Details', style: TextStyle(fontSize: 16.sp),),
                        SizedBox(height: 8.h,),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sunrise'),
                                Text('Sunset'),
                                Text('Moonrise'),
                                Text('Moonset'),
                              ],
                            ),
                            SizedBox(width: 10.w,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(':'),
                                Text(':'),
                                Text(':'),
                                Text(':'),
                              ],
                            ),
                            SizedBox(width: 10.w,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(forecastday.astro.sunrise),
                                Text(forecastday.astro.sunset),
                                Text(forecastday.astro.moonrise),
                                Text(forecastday.astro.moonset),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )),
              SizedBox(height: 20.h,),
              Flexible(
                child:Container(
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.0),
                          child: Text('Hourly Forecast'),
                        ),
                        Container(
                          height: 90.h,
                          width: double.infinity,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: forecastday.hour.length,
                              itemBuilder: (ctx, index){

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(DateFormat('jms').format(DateTime.parse(forecastday.hour[index].time,)),
                                          style: TextStyle(fontSize: 10.sp),),
                                        Image.network('http:${forecastday.hour[index].condition.icon}'),
                                        Text(forecastday.hour[index].condition.text,
                                          style: TextStyle(fontSize: 10.sp),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10.w)
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
