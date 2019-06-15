import 'package:flutter/material.dart';
import 'pages/places.dart';
import 'pages/home.dart';

void main() {
  runApp(MaterialApp(
    title: 'Dublin City Noise Monitor',
    home: new Places(title: "Dublin City Noise Monitor"),
  ));
}