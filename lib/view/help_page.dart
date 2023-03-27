
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/view/home_page.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
            children:[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill
                  )
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('We Show Weather For You',textAlign: TextAlign.center ,
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w400),) ,
                    ElevatedButton(
                        onPressed: (){
                          Get.to(()=> HomePage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          minimumSize: const Size(130, 40),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)
                          )
                        ),
                        child: Text('Skip', style: TextStyle(fontSize: 16.sp),))
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }
}
