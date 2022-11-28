import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selected = 0;
  List<String> myList = ['Today', 'Tomorrow', '7 Days', 'Last Month'];

  late Position position;
  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forecastMap;

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longatute = position.longitude;
    });
    fetchWeatherData();
  }

  var latitude;
  var longatute;

  fetchWeatherData() async {
    String forecastUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longatute&units=metric&appid=f92bf340ade13c087f6334ed434f9761&fbclid=IwAR2MIhWnKnisutHJ1y1dgxc-XbFFbVlG_T_f8F9_fhd6ZFC4PRI3oNAWgMc";

    String weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longatute&units=metric&appid=f92bf340ade13c087f6334ed434f9761&fbclid=IwAR2MIhWnKnisutHJ1y1dgxc-XbFFbVlG_T_f8F9_fhd6ZFC4PRI3oNAWgMc";

    var weatherResponce = await http.get(Uri.parse(weatherUrl));

    var forecastResponce = await http.get(Uri.parse(forecastUrl));
    weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponce.body));
    forecastMap = Map<String, dynamic>.from(jsonDecode(forecastResponce.body));
    setState(() {});
    print("eeeeeeeeeee${forecastMap!["cod"]}");
  }

  @override
  void initState() {
    // TODO: implement initState
    determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: forecastMap != null
            ? Scaffold(
                backgroundColor: scaffoldClr,
                body: Container(
                  padding: EdgeInsets.all(20),
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: scaffoldClr2,
                                border: Border.all(width: 1, color: textClr3)),
                            child: Icon(
                              Icons.notifications,
                              color: textClr3,
                              size: 20,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${Jiffy(DateTime.now()).format("EEEE," 'd MMM')}',
                                style: myStyle(
                                    14, FontWeight.normal, Colors.white70),
                              ),
                              Text("${weatherMap!["name"]}",
                                  style: myStyle(16, FontWeight.bold, textClr)),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              padding: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: scaffoldClr2,
                              ),
                              child: Image.asset('images/cloudy.png'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "${weatherMap!["main"]["temp"].toInt()}°",
                                          style: myStyle(
                                              60, FontWeight.bold, textClr3)),
                                      TextSpan(
                                          text: 'C',
                                          style: myStyle(
                                              40, FontWeight.bold, textClr3)),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${weatherMap!["weather"][0]["description"]}",
                                  style: myStyle(16, FontWeight.bold, textClr),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: scaffoldClr2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Wind',
                                  style:
                                      myStyle(18, FontWeight.normal, textClr),
                                ),
                                Text(
                                  '${weatherMap!['wind']['speed']} km/h',
                                  style:
                                      myStyle(13, FontWeight.normal, textClr),
                                ),
                              ],
                            ),
                            Container(
                              width: 4,
                              height: 45,
                              color: scaffoldClr,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Temp',
                                  style:
                                      myStyle(18, FontWeight.normal, textClr),
                                ),
                                Text(
                                  '${weatherMap!['main']['temp'].toInt()}°',
                                  style:
                                      myStyle(13, FontWeight.normal, textClr),
                                ),
                              ],
                            ),
                            Container(
                              width: 4,
                              height: 45,
                              color: scaffoldClr,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Humidity',
                                  style:
                                      myStyle(18, FontWeight.normal, textClr),
                                ),
                                Text(
                                  '${weatherMap!['main']['humidity']}%',
                                  style:
                                      myStyle(13, FontWeight.normal, textClr),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 40,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selected = index;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: selected == index
                                            ? textClr3
                                            : scaffoldClr2),
                                    child: Text(
                                      myList[index],
                                      style: myStyle(
                                          16,
                                          FontWeight.bold,
                                          selected == index
                                              ? textClr
                                              : textClr3),
                                    ),
                                  ),
                                ),
                            separatorBuilder: (_, index) => SizedBox(
                                  width: 20,
                                ),
                            itemCount: myList.length),
                      ),
                      Expanded(
                          child: Container(
                        child: Column(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Container(
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .27,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: scaffoldClr2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: scaffoldClr),
                                                  child: Image.asset('images/cloudy.png'),
                                                ),
                                                Text(
                                                  '${forecastMap!['list'][index]['main']['temp'].toInt()}°',
                                                  style: myStyle(
                                                      25,
                                                      FontWeight.bold,
                                                      textClr3),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 30,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      color: timeClr,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.elliptical(
                                                                  50, 30))),
                                                  child: Text(
                                                    '${Jiffy(forecastMap!['list'][index]['dt_txt']).format('h:mm')}',
                                                    style: myStyle(
                                                        14,
                                                        FontWeight.bold,
                                                        Colors.black),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            width: 15,
                                          ),
                                      itemCount: forecastMap!.length),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(top: 20, bottom: 30),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: scaffoldClr2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.home_outlined,
                                        size: 30,
                                        color: textClr3,
                                      ),
                                      Icon(
                                        Icons.search,
                                        size: 30,
                                        color: textClr3,
                                      ),
                                      Icon(
                                        Icons.message_rounded,
                                        size: 25,
                                        color: textClr3,
                                      ),
                                      Icon(
                                        Icons.person,
                                        size: 30,
                                        color: textClr3,
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}

myStyle(double size, FontWeight weight, Color clr) {
  return TextStyle(fontSize: size, fontWeight: weight, color: clr);
}
