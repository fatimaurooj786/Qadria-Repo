import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/view/bottom_nav/activity_summary/widgets/barchart_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:qadria/model/get/summary_model.dart';
import 'package:qadria/res/utils/currecy_formatter.dart';
import 'package:qadria/view_models/activity_summart_controller/activity_summart_controller.dart';

class ActivitySummaryScreen extends StatefulWidget {
  const ActivitySummaryScreen({super.key});

  @override
  State<ActivitySummaryScreen> createState() => _ActivitySummaryScreenState();
}

class _ActivitySummaryScreenState extends State<ActivitySummaryScreen> {
  final controller = Get.put(ActivitySummartController());

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Summary"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.activitySummary.value == null) {
          return const Center(
            child: Text(
              'No activity summary available',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        final summary = controller.activitySummary.value!;
        final rawData = summary.data?.rawData ?? [];

        // Transform data for the bar chart

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          // child: SyncfusionBarChart(
          //   rawData: rawData,
          // ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDatePicker(
                      label: "From Date",
                      selectedDate: controller.fromDate.value,
                      onDateSelected: (newDate) =>
                          controller.updateFromDate(newDate),
                    ),
                    _buildDatePicker(
                      label: "To Date",
                      selectedDate: controller.toDate.value,
                      onDateSelected: (newDate) =>
                          controller.updateToDate(newDate),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Sales and Purchase Cards
              _buildSummaryCards(summary),

              const SizedBox(height: 16),
              const Divider(),
              // Bar Chart
              const Text(
                "Bank Accounts",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              SyncfusionBarChart(rawData: rawData),

              const SizedBox(height: 16),

              // Display Bank Details
              // _buildBankDetails(rawData),

              _buildBalanceCards(summary),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBalanceCards(SummaryModel summary) {
    final openingBalance = summary.data?.openingBalance?[0].value ?? 0.0;
    final closingBalance = summary.data?.closingBalance?[0].value ?? 0.0;

    return Column(
      children: [
        _buildSingleBalanceCard(
          title: "Opening Balance",
          amount: openingBalance,
          gradientColors: [Colors.blue, Colors.lightBlueAccent],
        ),
        const SizedBox(height: 16),
        _buildSingleBalanceCard(
          title: "Closing Balance",
          amount: closingBalance,
          gradientColors: [Colors.purple, Colors.deepPurpleAccent],
        ),
      ],
    );
  }

  Widget _buildSingleBalanceCard({
    required String title,
    required double amount,
    required List<Color> gradientColors,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        height: 120, // Ensures all cards have the same height
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormatter.format(amount),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetails(List<RawData> rawData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bank Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...rawData.map((data) {
          final bankName = data.bankAccount?[0] ?? 'Unknown';
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bank: $bankName",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem("Opening", data.opening),
                      _buildDetailItem("Closing", data.closing),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem("Debit", data.debit),
                      _buildDetailItem("Credit", data.credit),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: label == "From Date"
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
          // textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              DateFormat('yyyy-MM-dd').format(selectedDate),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

// Utility widget for displaying details
  Widget _buildDetailItem(String label, double? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          currencyFormatter.format(value ?? 0),
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  // Widget to build summary cards
  Widget _buildSummaryCards(SummaryModel summary) {
    double totalSales = 0, salesReturn = 0, salesTotal = 0;
    double totalPurchase = 0, purchaseReturn = 0, purchaseTotal = 0;

    summary.data?.totals?.forEach((total) {
      switch (total.label) {
        case "Total Sales":
          totalSales = total.value ?? 0;
          break;
        case "Sales Return":
          salesReturn = total.value ?? 0;
          break;
        case "Sales Total":
          salesTotal = total.value ?? 0;
          break;
        case "Total Purchase":
          totalPurchase = total.value ?? 0;
          break;
        case "Purchase Return":
          purchaseReturn = total.value ?? 0;
          break;
        case "Purchase Total":
          purchaseTotal = total.value ?? 0;
          break;
      }
    });

    return Column(
      children: [
        _buildSummaryCard(
          context,
          title: "Sales",
          totalValue: currencyFormatter.format(totalSales),
          totalLabel: "Total Sales",
          returnValue: currencyFormatter.format(salesReturn),
          labelTotal: "Total",
          valueTotal: currencyFormatter.format(salesTotal),
          gradientColors: [MyColors.color, const Color.fromARGB(255, 18, 5, 205)],
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          context,
          title: "Purchase",
          totalValue: currencyFormatter.format(totalPurchase),
          totalLabel: "Total Purchase",
          returnValue: currencyFormatter.format(purchaseReturn),
          labelTotal: "Total",
          valueTotal: currencyFormatter.format(purchaseTotal),
          gradientColors: [Colors.teal, Colors.green],
        ),
      ],
    );
  }

  // Summary card builder
  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String totalValue,
    required String totalLabel,
    required String returnValue,
    required String labelTotal,
    required String valueTotal,
    required List<Color> gradientColors,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(totalLabel,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(totalValue,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Return",
                        style: TextStyle(fontSize: 12, color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(returnValue,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Text(labelTotal,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(valueTotal,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
