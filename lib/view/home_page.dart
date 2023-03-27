import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
          child: Column(

            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.search),
                  hintText: 'Search',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 2.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                    focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.deepPurple)),
                    enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:const BorderSide(color: Colors.black),
                    )
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
