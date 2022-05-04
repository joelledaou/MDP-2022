import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math';
import '../model_data/weather_data.dart';
import '../screens/details_page.dart';

enum BatteryState { full, charging, discharging, unknown }

//add1
Weather? currentTemp;
List<Weather>? fourDay;

String lat = "";
String lon = "";
//String city = "Beirut";

String getLon(String city) {
  if (city == "Beirut") {
    lon = "35.47843";
  } else if (city == "Amioun") {
    lon = "35.816685";
  } else if (city == "Baalbek") {
    lon = "36.2117096";
  } else if (city == "Batroun") {
    lon = "35.6588567";
  } else if (city == "Bcharre") {
    lon = "36.0117";
  } else if (city == "Bhamdoun") {
    lon = "35.576399";
  } else if (city == "Byblos") {
    lon = "35.6492047";
  } else if (city == "El Hermel") {
    lon = "36.3895597";
  } else if (city == "El Ksar") {
    lon = "35.8231";
  } else if (city == "Halba") {
    lon = "36.0783772";
  } else if (city == "Hasbaiya") {
    lon = "35.68202";
  } else if (city == "Jezzine") {
    lon = "35.5843949";
  } else if (city == "Joubb Jannine") {
    lon = "35.7838352";
  } else if (city == "Jounieh") {
    lon = "35.6200633";
  } else if (city == "Marjayoun") {
    lon = "35.5902134";
  } else if (city == "Nabatiye et Tahta") {
    lon = "35.4833734";
  } else if (city == "Rachaiya el Ouadi") {
    lon = "35.8437";
  } else if (city == "Ramlet el Bayda") {
    lon = "35.48214740160091";
  } else if (city == "Sidon") {
    lon = "35.3780338";
  } else if (city == "Tripoli") {
    lon = "35.8348712";
  } else if (city == "Tyre") {
    lon = "35.1964023";
  } else if (city == "Zahle") {
    lon = "35.9026269";
  } else if (city == "Zgharta") {
    lon = "35.8967113";
  }
  return lon;
}

String getLat(String city) {
  if (city == "Beirut") {
    lat = "33.8959203";
  } else if (city == "Amioun") {
    lat = "34.3004082";
  } else if (city == "Baalbek") {
    lat = "34.009653";
  } else if (city == "Batroun") {
    lat = "34.2548879";
  } else if (city == "Bcharre") {
    lat = "34.2507";
  } else if (city == "Bhamdoun") {
    lat = "33.85022";
  } else if (city == "Byblos") {
    lat = "34.123528";
  } else if (city == "El Hermel") {
    lat = "34.4028835";
  } else if (city == "El Ksar") {
    lat = "34.3119";
  } else if (city == "Halba") {
    lat = "34.5444034";
  } else if (city == "Hasbaiya") {
    lat = "33.398014";
  } else if (city == "Jezzine") {
    lat = "33.5439343";
  } else if (city == "Joubb Jannine") {
    lat = "33.6266499";
  } else if (city == "Jounieh") {
    lat = "33.9741506";
  } else if (city == "Marjayoun") {
    lat = "33.3592529";
  } else if (city == "Nabatiye et Tahta") {
    lat = "33.3775564";
  } else if (city == "Rachaiya el Ouadi") {
    lat = "33.5009";
  } else if (city == "Ramlet el Bayda") {
    lat = "33.87890605";
  } else if (city == "Sidon") {
    lat = "33.5618345";
  } else if (city == "Tripoli") {
    lat = "34.4367931";
  } else if (city == "Tyre") {
    lat = "33.2721211";
  } else if (city == "Zahle") {
    lat = "33.8476479";
  } else if (city == "Zgharta") {
    lat = "34.3929847";
  }
  return lat;
}

class Dashboard extends StatefulWidget {
  //add2
  final String valueC;
  final Function() updateData;

  const Dashboard({Key? key, required this.valueC, required this.updateData})
      : super(key: key);
  //const Dashboard({Key? key}) : super(key: key);

  // const Dashboard({Key? key, required this.sevenDay,}) : super(key: key);
  // final List<Weather> sevenDay;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
//add3
  getData() async {
    fetchData(getLat(widget.valueC), getLon(widget.valueC), widget.valueC)
        .then((value) {
      currentTemp = value[0];
      //todayWeather = value[1];
      //tomorrowTemp = value[0];
      fourDay = value[1];
      setState(() {});
    });
  }

  //variables for the method getBatteryPercentage()
  var battery = Battery();
  int percentage = 0;
  late Timer timer;

  //variables for the method getBatteryState()
  BatteryState batteryState = BatteryState.full;
  late StreamSubscription streamSubscription;

  //variables for the method calculatePVGeneration()
  //As an example, let’s say you have 250-watt solar panels
  // and live in a place where you get 5 hours of sunlight per day.
  // What’s that 75 percent for?
  // That’s to account for all those variables we've been going over.
  int nbSolarPanel = 8;
  int wattSolarPanel = 350;
  int hrsSunlightDay = 5;

  //double percentPVGeneration = 0.0;

  //variable for consumption
  Random rnd = Random();
  int min = 13, max = 23;

  @override
  void initState() {
    super.initState();

    //add4
    getData();

    getBatteryState();

    Timer.periodic(const Duration(microseconds: 20), (timer) {
      getBatteryPercentage();
    });

    // Timer.periodic(const Duration(microseconds: 20), (timer) {
    //   getPercentagePVGeneration();
    // });
  }

  void getBatteryPercentage() async {
    final level = await battery.batteryLevel;
    percentage = level;

    setState(() {});
  }

  void getBatteryState() {
    streamSubscription = battery.onBatteryStateChanged.listen((state) {
      batteryState = state as BatteryState;

      setState(() {});
    });
  }

  String calculatePVGeneration() {
    double solarPanelOutputWatt =
        nbSolarPanel * wattSolarPanel * hrsSunlightDay * 0.75;
    double solarPanelOutputKWatt = solarPanelOutputWatt / 1000;

    return solarPanelOutputKWatt.toStringAsFixed(2);
  }

  double getPercentagePVGeneration() {
    double solarPanelOutputWatt =
        nbSolarPanel * wattSolarPanel * hrsSunlightDay * 0.75;
    double solarPanelOutputKWatt = solarPanelOutputWatt / 1000;

    //average 10 KW
    double percentPVGeneration = solarPanelOutputKWatt / 19;

    // setState(() {});
    return percentPVGeneration;
  }

  String getRandomConsumption() {
    //double r = rnd.nextDouble() + rnd.nextInt(max - min) + min;
    double r = 5789 / 365;
    return r.toStringAsFixed(2);
  }

  double getPercentageConsumption() {
    double r = 5789 / 365;
    double avg = 6907 / 365;
    double percentConsumption = r / avg;

    // setState(() {});
    return percentConsumption;
  }

  Widget batteryBuild(BatteryState state) {
    switch (state) {
      case BatteryState.full:
        return const SizedBox(
          width: 35,
          height: 50,
          child: (Icon(
            Icons.battery_full,
            size: 40,
            color: Colors.green,
          )),
        );

      case BatteryState.charging:
        return const SizedBox(
          width: 35,
          height: 50,
          child: (Icon(
            Icons.battery_charging_full,
            size: 40,
            color: Colors.blue,
          )),
        );

      case BatteryState.discharging:
      default:
        return const SizedBox(
          width: 35,
          height: 50,
          child: (Icon(
            Icons.battery_alert,
            size: 40,
            color: Colors.red,
          )),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        // Override the default Back button
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_left_sharp),
          label: const Text('Back'),
          style: ElevatedButton.styleFrom(
              elevation: 0, primary: Colors.transparent),
        ),

        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          padding: const EdgeInsets.only(left: 20.5),
          child: SizedBox(
              width: 350,
              height: 300,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                              8.0) //                 <--- border radius here
                          ),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black87,
                            Colors.black54,
                            Colors.black45
                          ]),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        child: const Text(
                          '       PV\nGeneration',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(3.0, 40.0, 0.0, 3.0),
                        child: Row(children: [
                          batteryBuild(batteryState),
                          Text(
                            '$percentage%',
                            style: TextStyle(
                                fontSize: 20,
                                color: percentage >= 20
                                    ? Colors.white
                                    : Colors.red),
                          ),
                        ]),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.fromLTRB(14.0, 10.0, 10.0, 10.0),
                        child: const Text(
                          'Consumption',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  Row(children: [
                    Container(
                      margin:
                          const EdgeInsets.fromLTRB(10.0, 100.0, 10.0, 10.0),
                      child: CircularPercentIndicator(
                        radius: 55,
                        lineWidth: 16,
                        //percent: percentPVGeneration,
                        percent: getPercentagePVGeneration(),
                        progressColor: Colors.deepPurple,
                        backgroundColor: Colors.deepPurple.shade100,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          calculatePVGeneration() + '\n KW',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.fromLTRB(100.0, 100.0, 10.0, 10.0),
                      child: CircularPercentIndicator(
                        radius: 55,
                        lineWidth: 16,
                        //percent: percentPVGeneration,
                        percent: getPercentageConsumption(),
                        progressColor: Colors.blueAccent.shade400,
                        backgroundColor: Colors.blueAccent.shade100,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          getRandomConsumption() + '\n KW',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ]),
                  Row(children: [
                    Container(
                      margin:
                          const EdgeInsets.fromLTRB(120.0, 170.0, 10.0, 0.0),
                      child: Column(
                        children: [
                          Image.asset('assets/images/battery backup mode.png',
                              height: 100, width: 100),
                          const Text(
                            'Backup mode',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  ])
                ],
              )),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20.5, top: 10.0),
          child: const Text(
            'Consumption and production estimation',
            style: TextStyle(
                color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            padding: const EdgeInsets.only(left: 20.5),
            child: SizedBox(
              width: 350,
              height: 280,
              child: Stack(children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                            8.0) //                 <--- border radius here
                        ),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black87,
                          Colors.black54,
                          Colors.black45
                        ]),
                  ),
                ),
                Column(children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text('Day',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text('Weather',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text('Expected\nProduction',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text('Expected\nConsumption',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                      ]),
                ]),
                const Padding(
                  padding: EdgeInsets.only(top: 36),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 93),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 153),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 212),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                Column(children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 45),
                  ),
                  FourDays(fourDay!)
                ]),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 172),
                    ),
                    Column(children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 60),
                      ),
                      Text('15.73',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      Text('14.31',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      Text('13.92',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      Text('15.02',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ])
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 270),
                    ),
                    Column(children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 60),
                      ),
                      Text('16.36',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      Text('14.25',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      Text('15.88',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      Text('15.76',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ])
                  ],
                )
              ]),
            ))
      ]),
    );
  }
}
