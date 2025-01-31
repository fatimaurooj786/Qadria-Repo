import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qadria/model/get/summary_model.dart';
import 'package:qadria/res/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncfusionBarChart extends StatefulWidget {
  final List<RawData> rawData;

  const SyncfusionBarChart({super.key, required this.rawData});

  @override
  State<SyncfusionBarChart> createState() => _SyncfusionBarChartState();
}

class _SyncfusionBarChartState extends State<SyncfusionBarChart> {
  late List<ChartData> chartData;
  late TooltipBehavior _tooltip;
  final Map<String, int> bankNameCount =
      {}; // To track occurrences of each bank name

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(
      enable: true,
      tooltipPosition:
          TooltipPosition.auto, // You can change this to 'auto' or other types
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        final ChartData chartData = data;
        return Container(
          color: Colors.black.withOpacity(0.7),
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Bank: ${chartData.bn}', // Show the bank name
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Opening: ${chartData.opening}', // Show formatted opening value
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Credit: ${chartData.credit}', // Show formatted credit value
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Debit: ${chartData.debit}', // Show formatted debit value
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Closing: ${chartData.closing}', // Show formatted closing value
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
    _initializeChartData();
  }

  void _initializeChartData() {
    chartData = widget.rawData.map((data) {
      log('Bank name: ${data.bankAccount?[0].toString()} + ${data.nickname}');
      return ChartData(
        _getUniqueBankName(data.bankAccount?[0].toString() ?? 'Unknown'),
        data.opening ?? 0, // Opening value
        data.credit ?? 0, // Credit value
        data.debit ?? 0, // Debit value
        data.closing ?? 0, // Closing value
        data.bankAccount?[0].toString() ?? 'Unknown', // Bank name
        data.nickname, // Nickname
      );
    }).toList();
  }

  String _getUniqueBankName(String bankName) {
    log('Bank name: $bankName');
    final shortenedName = _shortenBankName(bankName);
    if (bankNameCount.containsKey(shortenedName)) {
      bankNameCount[shortenedName] = bankNameCount[shortenedName]! + 1;
      return '$shortenedName ${bankNameCount[shortenedName]}';
    } else {
      bankNameCount[shortenedName] = 1;
      return shortenedName;
    }
  }

  String _shortenBankName(String bankName) {
    final parts = bankName.split(' ');
    if (parts.isNotEmpty) {
      if (parts.length > 1) {
        return '${parts.first[0]}${parts.last[0]}';
      } else {
        return parts.first;
      }
    }
    return bankName.length > 5 ? bankName.substring(0, 5) : bankName;
  }

  String formatAmount(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k';
    } else {
      return amount.toStringAsFixed(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: MyColors.color.withOpacity(0.1),
        ),
        child: SfCartesianChart(
          borderWidth: 0,
          primaryXAxis: const CategoryAxis(
            labelRotation: -45,
            labelIntersectAction: AxisLabelIntersectAction.wrap,
            labelStyle: TextStyle(color: Colors.black, fontSize: 8),
          ),
          tooltipBehavior: _tooltip,
          primaryYAxis: NumericAxis(
            labelFormat: '{value}',
            axisLabelFormatter: (AxisLabelRenderDetails details) {
              final formattedY = formatAmount(details.value.toDouble());
              return ChartAxisLabel(
                  formattedY, const TextStyle(color: Colors.black));
            },
          ),
          series: <CartesianSeries<ChartData, String>>[
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              color: const Color.fromARGB(255, 40, 7, 226).withOpacity(0.7),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(5)),
              xValueMapper: (ChartData data, _) => data.nickname,
              yValueMapper: (ChartData data, _) =>
                  data.closing, // Default to closing value
              dataLabelSettings: const DataLabelSettings(isVisible: false),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String x;
  final String bn;
  final double opening;
  final double credit;
  final double debit;
  final double closing;
  final String nickname;

  ChartData(this.x, this.opening, this.credit, this.debit, this.closing,
      this.bn, this.nickname);
}
