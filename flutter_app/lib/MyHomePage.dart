import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'dataClasses/ClicksPerYear.dart';
import 'dataClasses/LinearSales.dart';
import 'package:flutterapp/MockDataGenerator.dart';

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
  var isPieChart = false;
  var animateChart = true;

  Map<String, ClicksPerYear> barChartData;
  Map<String, List<LinearSales>> curveChartData;

  @override
  void initState() {
    barChartData = MockDataGenerator.mockBarChartData();

    curveChartData = MockDataGenerator.mockLineChartData();

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

    var groupedHorizontalBarChart = new charts.BarChart(groupedBarChartSeries,
        animate: animateChart,
        vertical: false,
        barGroupingType: charts.BarGroupingType.grouped);

    charts.LineChart lineChart() {
      return new charts.LineChart(lineChartSeries,
          defaultRenderer: new charts.LineRendererConfig(
              includeArea: isCurvedChartFilled, stacked: isStacked),
          animate: animateChart);
    }

    charts.PieChart pieChart() {
      return charts.PieChart(
        series,
        animate: animateChart,
        // Add the legend behavior to the chart to turn on legends.
        // This example shows how to optionally show measure and provide a custom
        // formatter.
        behaviors: [
          new charts.DatumLegend(
            // Positions for "start" and "end" will be left and right respectively
            // for widgets with a build context that has directionality ltr.
            // For rtl, "start" and "end" will be right and left respectively.
            // Since this example has directionality of ltr, the legend is
            // positioned on the right side of the chart.
            position: charts.BehaviorPosition.end,
            // By default, if the position of the chart is on the left or right of
            // the chart, [horizontalFirst] is set to false. This means that the
            // legend entries will grow as new rows first instead of a new column.
            horizontalFirst: false,
            // This defines the padding around each legend entry.
            cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
            // Set [showMeasures] to true to display measures in series legend.
            showMeasures: true,
            // Configure the measure value to be shown by default in the legend.
            legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
            // Optionally provide a measure formatter to format the measure value.
            // If none is specified the value is formatted as a decimal.
            measureFormatter: (num value) {
              return value == null ? '-' : '${value}k';
            },
          ),
        ],
      );
    }

    ///return a Text widget with a text needed
    Text getTextForGroupingButton() {

      var str = '';

      if(isPieChart) {
        return Text('not used');
      }

      if (isCurvedLines) {
        str = isStacked ? 'unstack' : 'stack';
      }
      else {
        str = isStacked ? 'ungroup' : 'group';
      }

      return Text(str);
    }

    Text getFillStrokeTextForLineChart() {
      if (!isCurvedLines) {
        return Text('not used');
      }


      return Text(isCurvedChartFilled ? 'remove fill' : 'add fill');
    }

    Icon getBarChartOrientationIcon() {
      if(isVertical) {
        return Icon(Icons.reorder);
      }
      return Icon(Icons.equalizer);
    }

    ///---

    Widget getChart() {
      if (isPieChart) {
        return pieChart();
      }

      if (isCurvedLines) {
        return lineChart();
      }

      if (isStacked) {
        if (isVertical) {
          return groupedVerticalBarChart;
        }
        return groupedHorizontalBarChart;
      } else {
        if (isVertical) {
          return verticalBarChart;
        }
        return horizontalBarChart;
      }
    }

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

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
          children: <Widget>[
            chartWidget,
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.4,
              //color: Colors.yellow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            color: Colors.orange,
                            highlightColor: Colors.blueAccent,
                            splashColor: Colors.red,
                            icon: Icon(Icons.pie_chart),
                            onPressed: onTogglePiechart,
                          ),
                          IconButton(
                            icon:Icon(Icons.show_chart),
                            onPressed: onCurveSwitch,
                            color: Colors.deepOrange,
                          ),
                          IconButton(
                            icon:Icon(Icons.view_week),
                            color:Colors.blueAccent,
                            onPressed: onToggleBarChart,
                          ),

                        ],
                      ),
                      IconButton(
                        color: Colors.orange,
                        highlightColor: Colors.blueAccent,
                        splashColor: Colors.red,
                        icon: Icon(Icons.refresh),
                        onPressed: randomizeData,
                      ),
                      RaisedButton.icon(
                        icon: Icon(Icons.border_outer),
                        onPressed: onLineChartFillSwitch,
                        label: getFillStrokeTextForLineChart(),
                      ),


                    ],
                  ),
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RaisedButton.icon(
                        onPressed: onChangeStacked,
                        color: Colors.green,
                        textColor: Colors.white,
                        icon: Icon(Icons.view_week),
                        label: getTextForGroupingButton(),
                      ),
                      RaisedButton.icon(
                        onPressed: onChangeOrientation,
                        color: Colors.brown,
                        textColor: Colors.white,
                        icon: getBarChartOrientationIcon(),
                        label: Text('orient'),
                      )
                    ],
                  ),
                ],
              ),
            )
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
      isPieChart = false;
      isCurvedLines = false;
      isVertical = !isVertical;
    });
  }

  void onChangeStacked() {
    setState(() {
      animateChart = true;
      isStacked = !isStacked;
    });
  }

  void onCurveSwitch() {
    setState(() {
      isPieChart = false;
      isCurvedLines = true;
    });
  }

  void onLineChartFillSwitch() {
    if (!isCurvedLines) {
      return;
    }

    setState(() {
      isCurvedChartFilled = !isCurvedChartFilled;
    });
  }

  void onTogglePiechart() {
    setState(() {
      isPieChart = !isPieChart;
    });
  }

  void onToggleBarChart() {
    setState(() {
      isCurvedLines = false;
      isPieChart = false;
    });
  }

  void randomizeData() {
    setState(() {
      barChartData = MockDataGenerator.mockBarChartData();
      curveChartData = MockDataGenerator.mockLineChartData();
    });

  }
}
