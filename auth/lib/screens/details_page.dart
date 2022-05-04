import 'package:flutter/material.dart';
import '../model_data/weather_data.dart';

class DetailPage extends StatelessWidget {
  final List<Weather> fourDay;
  DetailPage(this.fourDay);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030317),
      body: Column(
        children: [FourDays(fourDay)],
      ),
    );
  }
}

class FourDays extends StatelessWidget {
  final List<Weather> fourDay;
  FourDays(this.fourDay);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: fourDay.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 5, bottom: 5, top: 0),
                child: Row(
                  children: [
                    Text(
                      //Day
                      fourDay[index].day!,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: SizedBox(
                        width: 135,
                        child: Wrap(
                          children: [
                            Image(
                              //Set the image
                              image: AssetImage(fourDay[index].image!),
                              width: 40,
                              height: 35,
                            ),

                            //spacing
                            const SizedBox(width: 10),

                            Text(
                              //name of the image
                              fourDay[index].name!,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),

                            //spacing
                            const SizedBox(
                              width: 20,
                            ),

                            Text(
                              //max temp
                              "+" + fourDay[index].max.toString() + "\u00B0",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),

                            //spacing
                            const SizedBox(
                              width: 5,
                            ),

                            Text(
                              //min temp
                              "+" + fourDay[index].min.toString() + "\u00B0",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          }),
    );
  }
}
