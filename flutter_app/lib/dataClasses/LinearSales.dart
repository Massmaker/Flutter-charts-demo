/// Sample linear data type.
class LinearSales {
  final int year;
  int sales;

  LinearSales(this.year, this.sales);

  void addToSales(int value) {
    sales += value;
  }
}