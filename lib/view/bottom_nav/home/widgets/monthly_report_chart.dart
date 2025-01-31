import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qadria/model/get/sales_data_model.dart';
import 'package:qadria/res/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesChartWithDropdown extends StatefulWidget {
  final List<SalesData> salesData; // Use SalesData list here
  const SalesChartWithDropdown({super.key, required this.salesData});

  @override
  State<SalesChartWithDropdown> createState() => _SalesChartWithDropdownState();
}

class _SalesChartWithDropdownState extends State<SalesChartWithDropdown> {
  late TooltipBehavior _tooltip;
  late String selectedYear;
  late List<ChartData> chartData;

  // We no longer need the hardcoded salesData list.
  // This will now be passed from the parent widget.

  final Map<String, String> monthShortNames = {
    "January": "Jan",
    "February": "Feb",
    "March": "Mar",
    "April": "Apr",
    "May": "May",
    "June": "Jun",
    "July": "Jul",
    "August": "Aug",
    "September": "Sep",
    "October": "Oct",
    "November": "Nov",
    "December": "Dec",
  };

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(
      enable: true,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        final ChartData chartData = data;
        return Container(
          width: 150,
          color: Colors.black.withOpacity(0.7),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${chartData.x}: ', // Show the bank name
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              AutoSizeText(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                '${chartData.rawY}', // Show formatted opening value
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );

    // Extract unique years from the salesData passed from parent
    final years = widget.salesData
        .map(
            (e) => e.month.split("-")[0]) // Get the year from the 'month' field
        .toSet()
        .toList();

    selectedYear = years.first; // Default to the first year
    chartData = _filterDataByYear(selectedYear);
  }

  List<ChartData> _filterDataByYear(String year) {
    return widget.salesData
        .where((item) => item.month.startsWith(year)) // Filter by year
        .map((item) {
      final shortMonthName = monthShortNames[item.monthName] ?? "";
      final rawAmount = item.totalSales;
      final formattedAmount = formatAmount(rawAmount);
      return ChartData(shortMonthName, rawAmount, formattedAmount);
    }).toList();
  }

  String formatAmount(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B'; // Billion
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M'; // Million
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k'; // Thousand
    } else {
      return amount.toStringAsFixed(1); // Less than a thousand
    }
  }

  void _onYearChanged(String? newYear) {
    if (newYear != null) {
      setState(() {
        selectedYear = newYear;
        chartData = _filterDataByYear(selectedYear);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final years =
        widget.salesData.map((e) => e.month.split("-")[0]).toSet().toList();

    return Column(
      children: [
        // Dropdown for selecting year
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Select Year: ",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  )),
              SizedBox(
                width: 120,
                child: DropdownButton<String>(
                  value: selectedYear,
                  isExpanded: true,
                  items: years
                      .map((year) => DropdownMenuItem<String>(
                            value: year,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                year,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: _onYearChanged,
                  underline: Container(
                    height: 2,
                    color: Colors.transparent, // Remove default underline
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54, // Custom icon color
                  ),
                  dropdownColor:
                      const Color.fromARGB(255, 179, 179, 232), // Dropdown background color
                  selectedItemBuilder: (BuildContext context) {
                    return years.map<Widget>((String year) {
                      return Center(
                        child: Text(
                          year,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: SizedBox(
              height: 220,
              child: SfCartesianChart(
                backgroundColor: MyColors.color.withOpacity(0.1),
                borderWidth: 0,
                tooltipBehavior: _tooltip,
                primaryXAxis: const CategoryAxis(),
                primaryYAxis: NumericAxis(
                  labelFormat:
                      '{value}', // This ensures that the formatted Y value is used
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    final formattedY = formatAmount(details.value.toDouble());
                    return ChartAxisLabel(
                        formattedY, const TextStyle(color: Colors.black));
                  },
                ),
                series: <CartesianSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    color: MyColors.color.withOpacity(0.7),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(5)),
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.rawY,
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.rawY, this.formattedY);
  final String x; // Short month name
  final double rawY; // Raw numeric value
  final String formattedY; // Formatted amount
}
