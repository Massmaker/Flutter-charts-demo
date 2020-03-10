import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'dataClasses/ClicksPerYear.dart';
import 'dataClasses/LinearSales.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentTime = DateFormat('dd/MM/yyyy').format(DateTime.now());

  var isCurvedLines = false;
  var isCurvedChartFilled = true;
  var isVertical = true;
  var isStacked = false;
  var animateChart = true;

  Map<String, ClicksPerYear> barChartData;
  Map<String, List<LinearSales>> curveChartData;

  @override
  void initState() {
    barChartData = {
      '2015': ClicksPerYear('2015', 10, Colors.red),
      '2016': ClicksPerYear('2016', 7, Colors.orange),
      '2017': ClicksPerYear('2017', 42, Colors.yellow),
      '$currentTime': ClicksPerYear('$currentTime', 0, Colors.green),
    };

    curveChartData = {
      'myFakeDesktopData': [
        new LinearSales(0, 5),
        new LinearSales(1, 75),
        new LinearSales(2, 100),
        new LinearSales(3, 75),
      ],
      'myFakeTabletData': [
        new LinearSales(0, 10),
        new LinearSales(1, 250),
        new LinearSales(2, 200),
        new LinearSales(3, 150),
      ],
      'myFakeMobileData': [
        new LinearSales(0, 15),
        new LinearSales(1, 75),
        new LinearSales(2, 100),
        new LinearSales(3, 225),
      ],
      'myFakeMobileDataSecond': [
        new LinearSales(0, 15),
        new LinearSales(1, 75),
        new LinearSales(2, 100),
        new LinearSales(3, 225),
      ]
    };

    isCurvedLines = false;
    isVertical = true;
    isStacked = false;
    animateChart = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///Bar Chart BottomUpwards
    var series = [
      new charts.Series(
          domainFn: (ClicksPerYear clickData, _) => clickData.year,
          measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
          colorFn: (ClicksPerYear clickData, _) => clickData.color,
          id: 'Clicks',
          data: barChartData.values.toList()),
    ];

    var groupedBarChartSeries = [
      new charts.Series<LinearSales, String>(
        id: 'Desktop',
        domainFn: (LinearSales sales, _) => sales.year.toString(),
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeDesktopData'],
      ),
      new charts.Series<LinearSales, String>(
        id: 'Tablet',
        domainFn: (LinearSales sales, _) => sales.year.toString(),
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeTabletData'],
        fillPatternFn: (LinearSales sales, _) =>
        charts.FillPatternType.forwardHatch,
      ),
      new charts.Series<LinearSales, String>(
        id: 'Mobile',
        domainFn: (LinearSales sales, _) => sales.year.toString(),
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeMobileData'],
      )
    ];

    var lineChartSeries = [
      new charts.Series<LinearSales, int>(
        id: 'Desktop',
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        // areaColorFn specifies that the area skirt will be light blue.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeDesktopData'],
      ),
      new charts.Series<LinearSales, int>(
        id: 'Tablet',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeTabletData'],
      ),
      new charts.Series<LinearSales, int>(
        id: 'Mobile',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeMobileData'],
      ),
      new charts.Series<LinearSales, int>(
        id: 'Mobile2',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.deepOrange.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales * 1.1,
        data: curveChartData['myFakeMobileDataSecond'],
      ),
    ];

    var verticalBarChart = new charts.BarChart(
      series,
      animate: animateChart,
      vertical: true,
    );

    var horizontalBarChart = new charts.BarChart(
      series,
      animate: animateChart,
      vertical: false,
    );

    var groupedVerticalBarChart = new charts.BarChart(
      groupedBarChartSeries,
      animate: animateChart,
      vertical: true,
      barGroupingType: charts.BarGroupingType.grouped,
    );

    var groupedHorizontalBarChart = new charts.BarChart(
        groupedBarChartSeries,
        animate: animateChart,
        vertical: false,
        barGroupingType: charts.BarGroupingType.grouped
    );

    charts.LineChart lineChart() {
      return new charts.LineChart(
          lineChartSeries,
          defaultRenderer: new charts.LineRendererConfig(
              includeArea: isCurvedChartFilled,
              stacked: isStacked),
          animate: animateChart);
    }

    ///---

    Widget getChart() {

      if (isCurvedLines) {
        return lineChart();
      }

      if (isStacked) {
        if (isVertical) {
          return groupedVerticalBarChart;
        }
        return groupedHorizontalBarChart;
      }
      else {
        if (isVertical) {
          return verticalBarChart;
        }
        return horizontalBarChart;
      }
    }

    var screenHeight = MediaQuery.of(context).size.height;

    var chartWidget = new Padding(
      padding: new EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: new SizedBox(height: screenHeight / 4.0, child: getChart()),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            chartWidget,
            Padding(
                padding: EdgeInsets.fromLTRB(2, 0, 16, 2),
                child: ButtonBar(
                  buttonHeight: 44.0,
                  children: <Widget>[
                    RaisedButton.icon(
                      icon: Icon(Icons.border_outer),
                      onPressed: onLineChartFillSwitch,
                      label: Text('fill'),
                    ),
                    RaisedButton.icon(
                      icon: Icon(Icons.show_chart),
                      onPressed: onCurveSwitch,
                      label: Text(''),
                    ),
                    RaisedButton.icon(
                      onPressed: onChangeStacked,
                      color: Colors.green,
                      textColor: Colors.white,
                      icon: Icon(Icons.view_week),
                      label: Text('stacks'),
                    ),
                    RaisedButton.icon(
                      onPressed: onChangeOrientation,
                      color: Colors.brown,
                      textColor: Colors.white,
                      icon: Icon(Icons.format_align_left),
                      label: Text('orient'),
                    )
                  ],
                )
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              backgroundColor: Colors.red,
              onPressed: handleAddDataButtonPress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: handleIncrementButtonPress,
              child: Icon(
                Icons.add,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleIncrementButtonPress() {
    if (isCurvedLines) {
      //curved chart data change ... :

      var firstSale = curveChartData['myFakeDesktopData'][1]; //unsafe

      var saleVolume = (firstSale?.sales ?? 20);
      setState(() {
        animateChart = false;
        firstSale?.addToSales(20);
      });
      return;
    }

    //bar chart data change

    setState(() {
      animateChart = true;
      DateTime now = DateTime.now();
      currentTime = DateFormat('dd/MM/yyyy').format(now);
      barChartData[currentTime].incrementClick();
    });
  }

  void handleAddDataButtonPress() {
    if (!isCurvedLines) {
      ///bar chart data change
      setState(() {

        barChartData.putIfAbsent(
            '2012', () => ClicksPerYear('2012', 42, Colors.teal));
      });
      return;
    }
  }

  void onChangeOrientation() {
    setState(() {
      isVertical = !isVertical;
    });
  }

  void onChangeStacked() {
    setState(() {
      isStacked = !isStacked;
    });
  }

  void onCurveSwitch() {
    setState(() {
      isCurvedLines = !isCurvedLines;
    });
  }

  void onLineChartFillSwitch() {
    setState(() {
      isCurvedChartFilled = !isCurvedChartFilled;
    });
  }
}
