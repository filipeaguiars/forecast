import 'package:flutter/material.dart';
import 'ui/Home.dart';

void main() {

  runApp(
    MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(
    ),
    title: 'Brompton Forecast',
    ),
  );
}