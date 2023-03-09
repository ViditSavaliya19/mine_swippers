import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mine_swippers/screen/home_screen.dart';

void main()
{
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/':(context) => HomeScreen(),
      },
    ),
  );
}