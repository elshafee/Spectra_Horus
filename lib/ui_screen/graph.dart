import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spectra_horus/ui_screen/light_image.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:transition/transition.dart';

class Histest extends StatefulWidget {
  List<double> list = [];
  int? length;

  Histest({required this.list, required this.length, Key? key})
      : super(key: key);

  @override
  _HistestState createState() => _HistestState();
}

class _HistestState extends State<Histest> {
  List<TableRow> esm = [];

  List<SalesData> char = <SalesData>[
    SalesData(1, 5.250),
  ];
  List<SalesData> cha = <SalesData>[];
  List<double> _list = [];
  int? _length = 0;
  bool load = true;
  final List<SalesData> chartData = <SalesData>[
    SalesData(1, 23),
    SalesData(2, 35),
    SalesData(3, 19)
  ];

  @override
  void initState() {
    super.initState();
    _length = widget.length;
    _list = widget.list;

    esm.insert(
      0,
      TableRow(
        children: [
          Column(children: [
            Text(
              'Row Number',
              style: GoogleFonts.courgette(
                fontSize: 20.0,
                color: Colors.indigo[800],
              ),
            )
          ]),
          Column(
            children: [
              Text(
                'Value',
                style: GoogleFonts.courgette(
                  fontSize: 20.0,
                  color: Colors.indigo[800],
                ),
              )
            ],
          ),
        ],
      ),
    );
    _list.forEachIndexed((index, element) {
      esm.insert(
          index + 1,
          TableRow(children: [
            Column(children: [
              Text(
                '$index',
                style: GoogleFonts.courgette(
                  fontSize: 20.0,
                  color: Colors.indigo[800],
                ),
              )
            ]),
            Column(children: [
              Text(
                '${element.round()}',
                style: GoogleFonts.courgette(
                  fontSize: 20.0,
                  color: Colors.indigo[800],
                ),
              )
            ]),
          ]));
      chartData.insert(
        index,
        SalesData(
          index.toDouble(),
          element,
        ),
      );
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        load = false;
        // char = cha;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("graph"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Center(
            child: load
                ? const CircularProgressIndicator()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width * 0.99,
                    child: SfCartesianChart(
                      series: <ChartSeries>[
                        HistogramSeries<SalesData, double>(
                            trackColor: Colors.red,
                            xAxisName: 'Row Numper',
                            yAxisName: 'Avarage',
                            dataSource: chartData,
                            showNormalDistributionCurve: true,
                            curveColor: const Color.fromRGBO(192, 108, 132, 1),
                            curveWidth: 2,
                            binInterval: 20,
                            yValueMapper: (SalesData sales, _) => sales.y)
                      ],
                    ),
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Totla Result',
              style: GoogleFonts.courgette(
                fontSize: 35.0,
                color: Colors.indigo[800],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(120.0),
              border: TableBorder.all(
                  color: Colors.indigo, style: BorderStyle.solid, width: 2),
              children: esm,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(right: 0, left: 0),
          child: AnimatedContainer(
            height: 70,
            duration: const Duration(seconds: 1),
            curve: Curves.ease,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.indigo[800],
              border: Border.all(
                color: Colors.indigo,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      child: Text(
                        'Take a new sample',
                        style: GoogleFonts.courgette(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      color: const Color.fromRGBO(108, 99, 255, 0.9),
                      splashColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          Transition(
                            child: LightPro(
                              img: [],
                              count: 0,
                            ),
                            transitionEffect: TransitionEffect.FADE,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.x, this.y);
  final double x;
  final double y;
}
