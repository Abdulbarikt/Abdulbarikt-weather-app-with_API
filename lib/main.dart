import 'package:apiweatherapp/screens/home_page.dart';
import 'package:apiweatherapp/services/location_provider.dart';
import 'package:apiweatherapp/services/weather_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => WeatherServiceProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WeaGo',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent, elevation: 0),
            iconTheme: const IconThemeData(color: Colors.white),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage()),
    );
  }
}
