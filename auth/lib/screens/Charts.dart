import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Charts extends StatefulWidget {
  //final Widget child;

  const Charts({Key? key}) : super(key: key);

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  late List<charts.Series<EnergySource, String>> seriesPieData;
  late List<charts.Series<EnergySource2, String>> seriesBarData;
  //late List<charts.Series<Savings, String>> seriesLineData;
  late List<charts.Series<Savings2, int>> seriesLineData;

  generateData() {
    var data1 = [
      EnergySource2('February', 388.6),
      EnergySource2('March', 323.595),
      EnergySource2('April', 90.741)
    ];

    var data2 = [
      EnergySource2('February', 149.41),
      EnergySource2('March', 198.81),
      EnergySource2('April', 62.727),
    ];

    var data3 = [
      EnergySource2('February', 76.38),
      EnergySource2('March', 124.08),
      EnergySource2('April', 32.683),
    ];

    var data4 = [
      EnergySource2('February', 55.61),
      EnergySource2('March', 58.515),
      EnergySource2('April', 16.849),
    ];

    seriesBarData.add(
      charts.Series(
        domainFn: (EnergySource2 es2, _) => es2.month, // axe des x
        measureFn: (EnergySource2 es2, _) => es2.quantity, // axe des y
        id: 'Sun',
        data: data2,
        fillPatternFn: (_, __) =>
            charts.FillPatternType.solid, // .forwardHatch (hachure)
        fillColorFn: (EnergySource2 es2, _) =>
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 236, 225, 20)),
      ),
    );

    seriesBarData.add(
      charts.Series(
        domainFn: (EnergySource2 es2, _) => es2.month,
        measureFn: (EnergySource2 es2, _) => es2.quantity,
        id: 'Battery',
        data: data3,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (EnergySource2 es2, _) =>
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 46, 193, 56)),
      ),
    );

    seriesBarData.add(
      charts.Series(
        domainFn: (EnergySource2 es2, _) => es2.month,
        measureFn: (EnergySource2 es2, _) => es2.quantity,
        id: 'EdL',
        data: data4,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (EnergySource2 es2, _) =>
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 0, 153, 255)),
      ),
    );

    seriesBarData.add(
      charts.Series(
        domainFn: (EnergySource2 es2, _) => es2.month,
        measureFn: (EnergySource2 es2, _) => es2.quantity,
        id: 'Power Generator',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (EnergySource2 es2, _) =>
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 255, 17, 17)),
      ),
    );

    var pieData = [
      EnergySource('Power Generator', 44.7, Color.fromARGB(255, 255, 27, 19)),
      EnergySource('Sun', 30.9, Color.fromARGB(255, 245, 245, 59)),
      EnergySource('Battery', 16.1, Color.fromARGB(255, 26, 210, 106)),
      EnergySource('EdL', 8.3, Color.fromARGB(255, 26, 155, 210)),
    ];

    seriesPieData.add(charts.Series(
        id: 'Monthly Consumption',
        data: pieData,
        domainFn: (EnergySource energySource, _) => energySource.name,
        measureFn: (EnergySource energySource, _) => energySource.value,
        colorFn: (EnergySource energySource, _) =>
            charts.ColorUtil.fromDartColor(energySource.color),
        labelAccessorFn: (EnergySource energySource, _) =>
            '${energySource.value}'));

    /*
    var savingsData1 = [
      Savings('December', 35),
      Savings('January', 46),
      Savings('February', 45),
      Savings('March', 50),
      Savings('April', 51),
    ];

    var savingsData2 = [
      Savings('December', 20),
      Savings('January', 24),
      Savings('February', 25),
      Savings('March', 40),
      Savings('April', 45),
    ];
    
    */

    var savingsData1 = [
      Savings2(0, 35),
      Savings2(1, 46),
      Savings2(2, 45),
      Savings2(3, 50),
      Savings2(4, 51),
      Savings2(5, 60)
    ];

    var savingsData2 = [
      Savings2(0, 20),
      Savings2(1, 24),
      Savings2(2, 25),
      Savings2(3, 40),
      Savings2(4, 45),
      Savings2(5, 60)
    ];
    
    
    seriesLineData.add(
      charts.Series(
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 29, 105, 219)),
        id: 'Savings',
        data: savingsData1,
        domainFn: (Savings2 savings, _) => savings.year,
        measureFn: (Savings2 savings, _) => savings.consumption,
      ),
    );

    seriesLineData.add(
      charts.Series(
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 172, 19, 228)),
        id: 'Savings',
        data: savingsData2,
        domainFn: (Savings2 savings, _) => savings.year,
        measureFn: (Savings2 savings, _) => savings.consumption,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    seriesPieData = <charts.Series<EnergySource, String>>[];
    // seriesPieData = <charts.Series<EnergySource, String>>[];
    seriesBarData = <charts.Series<EnergySource2, String>>[];
    //seriesLineData = <charts.Series<Savings, String>>[];
    seriesLineData = <charts.Series<Savings2, int>>[];
    generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 3, //3
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xff1976d2),
                //backgroundColor: Color(0xff308e1c),
                bottom: TabBar(
                  indicatorColor: Color(0xff9962D0),
                  tabs: [
                    Tab(icon: Icon(FontAwesomeIcons.solidChartBar)),
                    Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                    Tab(icon: Icon(FontAwesomeIcons.chartLine)),
                  ],
                ),
                title: Text('Statistics'),
                centerTitle: true,
              ),
              body: TabBarView(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text('Energy consumption (in KWh)',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: charts.BarChart(
                              seriesBarData,
                              animate: true,
                              barGroupingType: charts.BarGroupingType.grouped,
                              //behaviors: [new charts.SeriesLegend()],
                              animationDuration: Duration(seconds: 5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                        child: Center(
                            child: Column(
                      children: <Widget>[
                        Text('Monthly Consumption',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Expanded(
                            child: charts.PieChart(seriesPieData,
                                animate: true,
                                animationDuration: Duration(seconds: 5),
                                behaviors: [
                                  charts.DatumLegend(
                                      outsideJustification: charts
                                          .OutsideJustification.endDrawArea,
                                      horizontalFirst: false,
                                      desiredMaxRows: 2,
                                      cellPadding: new EdgeInsets.only(
                                          right: 4.0, bottom: 4.0),
                                      entryTextStyle: charts.TextStyleSpec(
                                          color: charts.MaterialPalette.purple
                                              .shadeDefault,
                                          fontFamily: 'Georgia',
                                          fontSize: 11))
                                ],
                                defaultRenderer: charts.ArcRendererConfig(
                                    arcWidth: 100,
                                    arcRendererDecorators: [
                                      charts.ArcLabelDecorator(
                                          labelPosition:
                                              charts.ArcLabelPosition.inside)
                                    ])))
                      ],
                    )))),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                        child: Center(
                            child: Column(children: <Widget>[
                      Text('Savings for the past 5 months',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold)),
                      Expanded(
                          child: charts.LineChart(
                        seriesLineData,
                        defaultRenderer: new charts.LineRendererConfig(
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

class EnergySource {
  String name;
  double value;
  Color color;

  EnergySource(this.name, this.value, this.color);
}

class EnergySource2 {
  String month;
  //String month;
  //int year;
  double quantity;

  EnergySource2(this.month, this.quantity);
}

class Savings2 {
  //String month;
  int year;
  int consumption;

  //Savings(this.month, this.consumption);
  Savings2(this.year, this.consumption);
}
