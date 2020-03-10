import 'package:flutterapp/dataClasses/LinearSales.dart';
import 'package:flutterapp/dataClasses/ClicksPerYear.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class MockDataGenerator {

  static var currentTime = DateFormat('dd/MM/yyyy').format(DateTime.now());
  static const int minClicks = 2;
  static const int maxClicks = 45;
  static const int minSales = 10;
  static const int maxSales = 300;
  static var random = Random();


  /// generate random data for 2015-2017 years
  static  Map<String, ClicksPerYear> mockBarChartData() {

    var value2015 = minClicks + random.nextInt(maxClicks - minClicks);
    var value2016 = minClicks + random.nextInt(maxClicks - minClicks);
    var value2017 = minClicks + random.nextInt(maxClicks - minClicks);

    return {
      '2015': ClicksPerYear('2015', value2015, Colors.red),
      '2016': ClicksPerYear('2016', value2016, Colors.orange),
      '2017': ClicksPerYear('2017', value2017, Colors.yellow),
      '$currentTime': ClicksPerYear('$currentTime', 0, Colors.green),
    };
  }

  /// generate random data for fake sales data
  static Map<String, List<LinearSales>> mockLineChartData() {
    return
      {
        'myFakeDesktopData': [
          new LinearSales(0, minSales + random.nextInt(maxSales - minSales)),
          new LinearSales(1, minSales + random.nextInt(maxSales - minSales)),
          new LinearSales(2, minSales + random.nextInt(maxSales - minSales)),
          new LinearSales(3, minSales + random.nextInt(maxSales - minSales)),
        ],
        'myFakeTabletData': [
          new LinearSales(0, minSales + random.nextInt(maxSales - minSales)),
          new LinearSales(1, minSales + random.nextInt(maxSales - minSales)),
          new LinearSales(2, minSales + random.nextInt(maxSales - minSales)),
          new LinearSales(3, minSales + random.nextInt(maxSales - minSales)),
        ],
        'myFakeMobileData': [
          new LinearSales(0, minSales + random.nextInt(maxSales - minSales)),
          new LinearSales(1, minSales + random.nextInt(maxSales - minSales)),
          new LinearSales(2, 100),
          new LinearSales(3, 225),
        ],
        'myFakeMobileDataSecond': [
          new LinearSales(0, 15),
          new LinearSales(1, 75),
          new LinearSales(2, minSales + random.nextInt(maxSales - minSales)),
          new LinearSales(3, minSales + random.nextInt(maxSales - minSales)),
        ]
      };
  }

}
