import 'package:apiweatherapp/data/image_path.dart';
import 'package:apiweatherapp/services/location_provider.dart';
import 'package:apiweatherapp/services/weather_service_provider.dart';
import 'package:apiweatherapp/utils/apptext.dart';
import 'package:apiweatherapp/utils/custom_divider_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city.toString());
        }
      }
    });

    super.initState();
  }

  final TextEditingController _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final weatherProvider = Provider.of<WeatherServiceProvider>(context);

// Get the sunrise timestamp from the API response
    int sunriseTimestamp = weatherProvider.weather?.sys?.sunrise ??
        0; // Replace 0 with a default timestamp if needed
    int sunsetTimestamp = weatherProvider.weather?.sys?.sunset ??
        0; // Replace 0 with a default timestamp if needed

// Convert the timestamp to a DateTime object
    DateTime sunriseDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

// Format the sunrise time as a string
    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Container(
        padding:
            const EdgeInsets.only(top: 65, left: 20, right: 20, bottom: 20),
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  background[
                          weatherProvider.weather?.weather![0].main ?? "N/A"] ??
                      "assets/img/default.png",
                ))),
        child: Stack(
          children: [
            SizedBox(
              height: 50,
              child: Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                String? locationCity;
                if (locationProvider.currentLocationName != null) {
                  locationCity = locationProvider.currentLocationName!.locality;
                } else {
                  locationCity = "Unknown Location";
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: locationCity,
                                color: Colors.white,
                                fw: FontWeight.w900,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            Align(
              alignment: const Alignment(0, -0.5),
              child: Image.asset(
                imagePath[weatherProvider.weather?.weather![0].main ?? "N/A"] ??
                    "assets/img/default.png",
                height: 160,
                width: 160,
                // Adjust the height as needed
              ),
            ),
            Align(
              alignment: const Alignment(0, 0),
              child: SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      data:
                          "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0)} \u00B0C" ??
                              "", // Display temperature
                      color: Colors.white,
                      fw: FontWeight.bold,
                      size: 32,
                    ),
                    AppText(
                      data: weatherProvider.weather?.name ?? "N/A",
                      color: Colors.white,
                      fw: FontWeight.w600,
                      size: 20,
                    ),
                    AppText(
                      data: weatherProvider.weather?.weather![0].main ?? "N/A",
                      color: Colors.white,
                      fw: FontWeight.w600,
                      size: 20,
                    ),
                    AppText(
                      data: DateFormat('hh:mm a').format(DateTime.now()),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.0, 0.75),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.4)),
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/img/temperature-high.png',
                              height: 55,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Temp Max",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                                AppText(
                                  data:
                                      "${weatherProvider.weather?.main!.tempMax!.toStringAsFixed(0)} \u00B0C" ??
                                          "N/A",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/img/temperature-low.png',
                              height: 55,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Temp Min",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                                AppText(
                                  data:
                                      "${weatherProvider.weather?.main!.tempMin!.toStringAsFixed(0)} \u00B0C" ??
                                          "N/A",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    const CustomDivider(
                      startIndent: 20,
                      endIndent: 20,
                      color: Colors.white,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/img/sun.png',
                              height: 55,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Sunrise",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                                AppText(
                                  data: "$formattedSunrise AM",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/img/moon.png',
                              height: 55,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Sunset",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                                AppText(
                                  data: "$formattedSunset PM",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _cityController,
                        decoration: const InputDecoration(
                          hintText: 'Enter city name',
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<WeatherServiceProvider>(context,
                                listen: false)
                            .fetchWeatherDataByCity(
                                _cityController.text.toString());
                      },
                      icon: const Icon(Icons.search, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
