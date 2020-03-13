
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/dataClasses/LinearSalesRadial.dart';
import 'package:intl/intl.dart';
import 'dataClasses/ClicksPerYear.dart';
import 'dataClasses/LinearSales.dart';
import 'package:flutterapp/MockDataGenerator.dart';
import 'ChartType.dart';
import 'package:charts_flutter/src/text_element.dart' as textElement;
import 'package:charts_flutter/src/text_style.dart' as style;

import 'CurvedLineChartSample.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentTime = DateFormat('dd/MM/yyyy').format(DateTime.now());

  ChartType chartType = ChartType.barChart;
  var isCurvedChartFilled = true;
  var isVertical = true;
  var isStacked = false;

  var animateChart = true;

  var lineChartText = '';

  Map<String, ClicksPerYear> barChartData;
  Map<String, List<LinearSales>> curveChartData;
  List<LinearSales> scatterPlotChartData;
  final maxMeasure = 300;

  @override
  void initState() {
    barChartData = MockDataGenerator.mockBarChartData();
    curveChartData = MockDataGenerator.mockLineChartData();
    scatterPlotChartData = MockDataGenerator.mockBubbleChartData();

    isVertical = true;
    isStacked = false;
    animateChart = true;

    chartType = ChartType.barChart;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///Detect Device`s orientation
    final mediaQueryData = MediaQuery.of(context);
    var orientation = mediaQueryData.orientation;
    var isHorizontal = (orientation == Orientation.landscape);
    var screenHeight = mediaQueryData.size.height;
    var screenWidth = mediaQueryData.size.width;
    //print('Is Horizontal: $isHorizontal');

    var chartHeight = isHorizontal ? screenHeight * 0.75 : screenHeight / 3.0;

    ///Chart Data
    var series = [
      new Series(
          domainFn: (ClicksPerYear clickData, _) => clickData.year,
          measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
          colorFn: (ClicksPerYear clickData, _) => clickData.color,
          id: 'Clicks',
          data: barChartData.values.toList()),
    ];

    var groupedBarChartSeries = [
      new Series<LinearSales, String>(
        id: 'Desktop',
        domainFn: (LinearSales sales, _) => sales.year.toString(),
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeDesktopData'],
      ),
      new Series<LinearSales, String>(
        id: 'Tablet',
        domainFn: (LinearSales sales, _) => sales.year.toString(),
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeTabletData'],
        fillPatternFn: (LinearSales sales, _) => FillPatternType.forwardHatch,
      ),
      new Series<LinearSales, String>(
        id: 'Mobile',
        domainFn: (LinearSales sales, _) => sales.year.toString(),
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeMobileData'],
      )
    ];

    var lineChartSeries = [
      new Series<LinearSales, int>(
        id: 'Desktop',
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        // areaColorFn specifies that the area skirt will be light blue.
        areaColorFn: (_, __) => MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeDesktopData'],
      ),
      new Series<LinearSales, int>(
        id: 'Tablet',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        areaColorFn: (_, __) => MaterialPalette.red.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeTabletData'],
      ),
      new Series<LinearSales, int>(
        id: 'Mobile',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) => MaterialPalette.green.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: curveChartData['myFakeMobileData'],
      ),
      new Series<LinearSales, int>(
        id: 'Mobile2',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => MaterialPalette.deepOrange.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) => MaterialPalette.deepOrange.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales * 1.1,
        data: curveChartData['myFakeMobileDataSecond'],
      ),
    ];

    var scatterPlotChartSeries = [
      new Series<LinearSalesRadial, int>(
        id: 'Sales',
        domainFn: (LinearSalesRadial sales, _) => sales.year,
        measureFn: (LinearSalesRadial sales, _) => sales.sales,
        data: scatterPlotChartData,
        // Providing a color function is optional.
        colorFn: (LinearSalesRadial sales, _) {
          // Bucket the measure column value into 3 distinct colors.
          final bucket = sales.sales / maxMeasure;

          if (bucket < 1 / 3) {
            return MaterialPalette.blue.shadeDefault;
          } else if (bucket < 2 / 3) {
            return MaterialPalette.red.shadeDefault;
          } else {
            return MaterialPalette.green.shadeDefault;
          }
        },
        // Providing a radius function is optional.
        radiusPxFn: (LinearSalesRadial sales, _) => sales.radius,
      )
    ];

    /// Charts
    var verticalBarChart = new BarChart(
      series,
      animate: animateChart,
      vertical: true,
    );

    var horizontalBarChart = new BarChart(
      series,
      animate: animateChart,
      vertical: false,
    );

    var groupedVerticalBarChart = new BarChart(
      groupedBarChartSeries,
      animate: animateChart,
      vertical: true,
      barGroupingType: BarGroupingType.grouped,
      behaviors: [
        SeriesLegend(),
      ],
    );

    var groupedHorizontalBarChart = new BarChart(groupedBarChartSeries,
        animate: animateChart,
        vertical: false,
        barGroupingType: BarGroupingType.grouped);

    ScatterPlotChart scatterPlotChart() {
      return new ScatterPlotChart(
        scatterPlotChartSeries,
        animate: animateChart,
      );
    }

    LineChart lineChart() {
      return new LineChart(lineChartSeries,
          behaviors: [
            LinePointHighlighter(
              symbolRenderer:
                  CircleSymbolRenderer(), //CustomCircleSymbolRenderer(),
            ),
          ],
          selectionModels: [
            SelectionModelConfig(changedListener: (SelectionModel model) {
              if (model.hasDatumSelection) {
                var value = model.selectedSeries[0]
                    .measureFn(model.selectedDatum[0].index);

                print('$value');

                lineChartText = '$value';
              }
            })
          ],
          defaultRenderer: LineRendererConfig(
              includeArea: isCurvedChartFilled, stacked: isStacked),
          animate: animateChart);
    }

    PieChart pieChartConfigured({bool donut = false}) {
      //print("Donut: $donut");

      var renderer = donut
          ? new ArcRendererConfig(
              arcWidth: isHorizontal ? (chartHeight / 5.5).floor() : 60,

              ///this value wants to be of Int
              arcRendererDecorators: [ArcLabelDecorator()])
          : null;

      var behaviours = donut
          ? null
          : [
              new DatumLegend(
                // Positions for "start" and "end" will be left and right respectively
                // for widgets with a build context that has directionality ltr.
                // For rtl, "start" and "end" will be right and left respectively.
                // Since this example has directionality of ltr, the legend is
                // positioned on the right side of the chart.
                position: BehaviorPosition.end,
                // By default, if the position of the chart is on the left or right of
                // the chart, [horizontalFirst] is set to false. This means that the
                // legend entries will grow as new rows first instead of a new column.
                horizontalFirst: false,
                // This defines the padding around each legend entry.
                cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                // Set [showMeasures] to true to display measures in series legend.
                showMeasures: true,
                // Configure the measure value to be shown by default in the legend.
                legendDefaultMeasure: LegendDefaultMeasure.firstValue,
                // Optionally provide a measure formatter to format the measure value.
                // If none is specified the value is formatted as a decimal.
                measureFormatter: (num value) {
                  return value == null ? '-' : '${value}k';
                },
              ),
            ];

      //print('Renderer: ${renderer}');

      return new PieChart(
        series,
        animate: animateChart,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: renderer,
        // Add the legend behavior to the chart to turn on legends.
        // This example shows how to optionally show measure and provide a custom
        // formatter.
        behaviors: behaviours,
      );
    }

    PieChart pieChart() {
      return pieChartConfigured();
    }

    PieChart donutChart() {
      return pieChartConfigured(donut: true);
    }

    ///return a Text widget with a text needed
    Text getTextForGroupingButton() {
      var str = 'not used';

      if (chartType == ChartType.lineChart) {
        str = isStacked ? 'unstack' : 'stack';
      } else if (chartType == ChartType.barChart) {
        str = isStacked ? 'ungroup' : 'group';
      }
      return Text(str);
    }

    Text getFillStrokeTextForLineChart() {
      if (chartType == ChartType.lineChart) {
        return Text(isCurvedChartFilled ? 'remove fill' : 'add fill');
      }

      return Text('not used');
    }

    Icon getBarChartOrientationIcon() {
      if (isVertical) {
        return Icon(Icons.reorder);
      }
      return Icon(Icons.equalizer);
    }

    ///---

    Widget getChart() {

      switch (chartType) {
        case ChartType.bubbleChart:
          return scatterPlotChart();

        case ChartType.pieChart:
          return pieChart();

        case ChartType.lineChart:
          return lineChart();

        case ChartType.barChart:
          if (isStacked) {
            if (isVertical) {
              return groupedVerticalBarChart;
            }
            return groupedHorizontalBarChart;
          } else if (isVertical) {
            return verticalBarChart;
          }
          return horizontalBarChart;

        case ChartType.donutChart:
          animateChart = false;
          return donutChart();
        case ChartType.bezierCurveChart:
          return CurvedLineChartSample();
        default:
          return verticalBarChart;
      }
    }

    var chartWidget = new Padding(
      padding: new EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: new SizedBox(height: chartHeight, child: getChart()),
    );

    Scaffold horizontalLayout() {
      return new Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: screenWidth * 0.6,
                child: chartWidget,
                //color:Colors.lightGreen, //debug
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                key: Key('Buttons column'),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        //child:Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RaisedButton.icon(
                              icon: Icon(Icons.border_outer),
                              label: getFillStrokeTextForLineChart(),
                              onPressed: onLineChartFillSwitch,
                            ),
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
                            ),
                          ],
                        ),
                      ),
                      //),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Container(
                          //width:screenWidth * 0.15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RaisedButton.icon(
                                onPressed: randomizeData,
                                color: Colors.orange,
                                textColor: Colors.white,
                                icon: Icon(Icons.refresh),
                                label: Text('randomise'),
                              ),
                              RaisedButton.icon(
                                onPressed: handleIncrementButtonPress,
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                icon: Icon(Icons.add),
                                label: Text('addValue'),
                              ),
                              RaisedButton.icon(
                                onPressed: handleAddDataButtonPress,
                                color: Colors.redAccent,
                                textColor: Colors.white,
                                icon: Icon(Icons.add),
                                label: Text('addData'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.donut_large),
                color: Colors.orange,
                highlightColor: Colors.blueAccent,
                splashColor: Colors.red,
                iconSize: 44,
                tooltip: 'Pie Chart',
                onPressed: onToggleDonutChart,
              ),
              IconButton(
                icon: Icon(Icons.pie_chart),
                color: Colors.orange,
                highlightColor: Colors.blueAccent,
                splashColor: Colors.red,
                iconSize: 44,
                tooltip: 'Pie Chart',
                onPressed: onTogglePieChart,
              ),
              IconButton(
                icon: Icon(Icons.show_chart),
                color: Colors.deepOrange,
                iconSize: 44,
                tooltip: 'Curve Chart',
                onPressed: onToggleCurveChart,
              ),
              IconButton(
                icon: Icon(Icons.view_week),
                color: Colors.blueAccent,
                iconSize: 44,
                tooltip: 'Bar Chart',
                onPressed: onToggleBarChart,
              ),
              IconButton(
                icon: Icon(Icons.bubble_chart),
                color: Colors.lightGreen,
                iconSize: 44,
                tooltip: 'Bubble chart',
                onPressed: onToggleBubbleChart,
              ),
              IconButton(
                icon: Icon(Icons.rounded_corner),
                iconSize: 44,
                color: Colors.pinkAccent,
                tooltip: 'Smooth Curve chart',
                onPressed: onToggleBezierCurveChart,
              )
            ],
          ),
        ),
      );
    }

    Scaffold verticalLayout() {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          child: Column(
            children: <Widget>[
              IconButton(
                color: Colors.orange,
//              highlightColor: Colors.blueAccent,
//              splashColor: Colors.red,
                icon: Icon(Icons.refresh),
                iconSize: 44,
                onPressed: randomizeData,
              ),
              chartWidget,
              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.2,
                //color: Colors.yellow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        RaisedButton.icon(
                          icon: Icon(Icons.border_outer),
                          label: getFillStrokeTextForLineChart(),
                          onPressed: onLineChartFillSwitch,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                icon: Icon(Icons.add),
                label: Text('addData'),
                backgroundColor: Colors.red,
                onPressed: handleAddDataButtonPress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                icon: Icon(Icons.add),
                label: Text('increment line'),
                onPressed: handleIncrementButtonPress,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.donut_large),
                color: Colors.orange,
                highlightColor: Colors.blueAccent,
                splashColor: Colors.red,
                iconSize: 44,
                tooltip: 'Pie Chart',
                onPressed: onToggleDonutChart,
              ),
              IconButton(
                icon: Icon(Icons.pie_chart),
                color: Colors.orange,
                highlightColor: Colors.blueAccent,
                splashColor: Colors.red,
                iconSize: 44,
                tooltip: 'Pie Chart',
                onPressed: onTogglePieChart,
              ),
              IconButton(
                icon: Icon(Icons.show_chart),
                color: Colors.deepOrange,
                iconSize: 44,
                tooltip: 'Curve Chart',
                onPressed: onToggleCurveChart,
              ),
              IconButton(
                icon: Icon(Icons.view_week),
                color: Colors.blueAccent,
                iconSize: 44,
                tooltip: 'Bar Chart',
                onPressed: onToggleBarChart,
              ),
              IconButton(
                icon: Icon(Icons.bubble_chart),
                color: Colors.lightGreen,
                iconSize: 44,
                tooltip: 'Bubble chart',
                onPressed: onToggleBubbleChart,
              ),
              IconButton(
                icon: Icon(Icons.multiline_chart),
                iconSize: 44,
                color: Colors.pinkAccent,
                tooltip: 'Smooth Curve chart',
                onPressed: onToggleBezierCurveChart,
              )
            ],
          ),
        ),
      );
    }

    return isHorizontal ? horizontalLayout() : verticalLayout();
  }

  void handleIncrementButtonPress() {
    if (chartType == ChartType.lineChart) {
      //line chart data change ... :
      var firstSale = curveChartData['myFakeDesktopData'][1]; //unsafe

      setState(() {
        animateChart = false;
        firstSale?.addToSales(20);
      });
      return;
    }

    //bar chart and pie chart data change
    setState(() {
      animateChart = true;
      DateTime now = DateTime.now();
      currentTime = DateFormat('dd/MM/yyyy').format(now);
      barChartData[currentTime].incrementClick();
    });
  }

  void handleAddDataButtonPress() {
    if (chartType != ChartType.lineChart) {
      ///bar chart data change
      setState(() {
        if (barChartData['2021'] != null) {
          barChartData.putIfAbsent(
              '2022', () => ClicksPerYear('2022', 35, Colors.brown));
        }

        barChartData.putIfAbsent(
            '2021', () => ClicksPerYear('2021', 42, Colors.teal));
      });
      return;
    }
  }

  void onChangeOrientation() {
    if (chartType == ChartType.barChart) {
      setState(() {
        isVertical = !isVertical;
      });
    }
  }

  void onChangeStacked() {
    setState(() {
      animateChart = true;
      isStacked = !isStacked;
    });
  }

  void onLineChartFillSwitch() {
    if (chartType != ChartType.lineChart) {
      return;
    }

    setState(() {
      animateChart = false;
      isCurvedChartFilled = !isCurvedChartFilled;
    });
  }

  void onToggleCurveChart() {
    setState(() {
      chartType = ChartType.lineChart;
    });
  }

  void onTogglePieChart() {
    setState(() {
      chartType = ChartType.pieChart;
    });
  }

  void onToggleDonutChart() {
    setState(() {
      chartType = ChartType.donutChart;
    });
  }

  void onToggleBarChart() {
    setState(() {
      chartType = ChartType.barChart;
    });
  }

  void onToggleBubbleChart() {
    setState(() {
      animateChart = true;
      chartType = ChartType.bubbleChart;
    });
  }

  void onToggleBezierCurveChart() {
    setState(() {
      animateChart = true;
      chartType = ChartType.bezierCurveChart;
    });
  }

  void randomizeData() {
    setState(() {
      barChartData = MockDataGenerator.mockBarChartData();
      curveChartData = MockDataGenerator.mockLineChartData();
      scatterPlotChartData = MockDataGenerator.mockBubbleChartData();
    });
  }
}

//class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
//
//  String _text;
//
//  CustomCircleSymbolRenderer({String text}) {
//    this._text = text;
//  }
//
//  @override
//  void paint(
//      ChartCanvas canvas,
//      Rectangle<num> bounds,
//      {List<int> dashPattern,
//        Color fillColor,
//        FillPatternType fillPattern,
//        Color strokeColor, double strokeWidthPx}) {
//
//    super.paint(canvas,
//        bounds,
//        dashPattern: dashPattern,
//        fillColor: fillColor,
//        fillPattern: fillPattern,
//        strokeColor: strokeColor,
//        strokeWidthPx: strokeWidthPx);
//
//    canvas.drawRect(
//        Rectangle(
//            bounds.left - 5,
//            bounds.top - 30,
//            bounds.width + 20,
//            bounds.height + 20),
//        fill: Color.white
//    );
//
//    var textStyle = style.TextStyle();
//    textStyle.color = Color.black;
//    textStyle.fontSize = 15;
//
//    canvas.drawText(
//        textElement.TextElement(_text, style: textStyle),
//        (bounds.left).round(),
//        (bounds.top - 28).round(),
//    );
//  }
//}
