import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Savings extends StatefulWidget {
  const Savings({ Key? key }) : super(key: key);

  @override
  State<Savings> createState() => _SavingsState();
}

class _SavingsState extends State<Savings> {

  late List<charts.Series<Sav, int>> seriesLineData;

  generateData() {

    var savingsData1 = [
      Sav(0, 35),
      Sav(1, 46),
      Sav(2, 45),
      Sav(3, 50),
      Sav(4, 51),
      Sav(5, 60)
    ];

    var savingsData2 = [
      Sav(0, 20),
      Sav(1, 24),
      Sav(2, 25),
      Sav(3, 40),
      Sav(4, 45),
      Sav(5, 60)
    ];

    seriesLineData.add(
      charts.Series(
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 29, 105, 219)),
        id: 'Savings',
        data: savingsData1,
        domainFn: (Sav savings, _) => savings.year,
        measureFn: (Sav savings, _) => savings.consumption,
      ),
    );

    seriesLineData.add(
      charts.Series(
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 172, 19, 228)),
        id: 'Savings',
        data: savingsData2,
        domainFn: (Sav savings, _) => savings.year,
        measureFn: (Sav savings, _) => savings.consumption,
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    seriesLineData = <charts.Series<Sav, int>>[];
    generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 1, //3
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xff1976d2),
                //backgroundColor: Color(0xff308e1c),
                // bottom: TabBar(
                //   indicatorColor: Color(0xff9962D0),
                //   tabs: [
                //     Tab(icon: Icon(FontAwesomeIcons.chartLine)),
                //   ],
                // ),
                title: Text('Savings for the past 5 months'),
                centerTitle: true,
              ),
              body: TabBarView(children: [
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                        child: Center(
                            child: Column(children: <Widget>[
                      // Text('Savings for the past 5 months',
                      //     style: TextStyle(
                      //         fontSize: 24.0, fontWeight: FontWeight.bold)),
                      Expanded(
                          child: charts.LineChart(
                        seriesLineData,
                        defaultRenderer: charts.LineRendererConfig(
                            includeArea: true, stacked: true),
                        animate: true,
                        animationDuration: Duration(seconds: 5),
                        behaviors: [
                          charts.ChartTitle('Months',
                              behaviorPosition: charts.BehaviorPosition.bottom,
                              titleOutsideJustification:
                                  charts.OutsideJustification.middleDrawArea),
                          charts.ChartTitle('Bill (\$)',
                              behaviorPosition: charts.BehaviorPosition.start,
                              titleOutsideJustification:
                                  charts.OutsideJustification.middleDrawArea),
                        ],
                      ))
                    ]))))
              ]),
            )));
  }

}

class Sav {
  //String month;
  int year;
  int consumption;

  //Savings(this.month, this.consumption);
  Sav(this.year, this.consumption);
}