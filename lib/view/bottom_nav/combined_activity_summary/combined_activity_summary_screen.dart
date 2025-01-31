import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qadria/model/get/combined_summary_model.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/utils/currecy_formatter.dart';
import 'package:qadria/view_models/combined_activity_summary_controller/combined_activity_summary_controller.dart';

class CombinedActivitySummaryScreen extends StatefulWidget {
  const CombinedActivitySummaryScreen({super.key});

  @override
  State<CombinedActivitySummaryScreen> createState() =>
      _CombinedActivitySummaryScreenState();
}

class _CombinedActivitySummaryScreenState
    extends State<CombinedActivitySummaryScreen> {
  final controller = Get.put(CombinedActivitySummaryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Combined Activity Summary'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.combinedActivitySummary.value == null) {
          return const Center(
            child: Text("No data found"),
          );
        }
        final summaryModel = controller.combinedActivitySummary.value!;
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Card(
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                         MyColors.color,
                        Color.fromARGB(255, 232, 62, 11),
                       
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text("Total Balance \nQadria",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  currencyFormatter
                                      .format(summaryModel.qadriaTotalBalance),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text("Total Balance \nStout",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  currencyFormatter
                                      .format(summaryModel.stoutQadriaTotal),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8), // Optional spacing
            Expanded(
              // Makes the ListView.builder scrollable within the Column
              child: ListView.builder(
                itemCount: summaryModel.data!.length,
                itemBuilder: (context, index) {
                  final bankData = summaryModel.data![index];
                  if (bankData.closingQadria == 0 &&
                      bankData.closingStout == 0) {
                    return const SizedBox.shrink();
                  }
                  return BankCard(bankData: bankData);
                },
              ),
            ),
          ],
        );
      }),
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
}

class BankCard extends StatelessWidget {
  final BankData bankData;
  const BankCard({super.key, required this.bankData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              MyColors.color,
                        Color.fromARGB(255, 232, 62, 11),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ExpansionTile(
          showTrailingIcon: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                // Bank Name
                Text(
                  bankData.bankAccountQadria == ''
                      ? "Bank Name"
                      : bankData.bankAccountQadria!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Total amounts
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAmountColumn("Total Qadria",
                        currencyFormatter.format(bankData.closingQadria)),
                    _buildAmountColumn("Total Stout",
                        currencyFormatter.format(bankData.closingStout)),
                  ],
                ),
                const SizedBox(height: 12),
                // Overall Total
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Overall Total: ${currencyFormatter.format(bankData.closingQadria! + bankData.closingStout!)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // qadria section
                  Expanded(
                    child: _buildDetailsColumn(
                      title: "Left",
                      details: [
                        {
                          "label": "Opening Amount",
                          "value":
                              currencyFormatter.format(bankData.openingQadria!)
                        },
                        {
                          "label": "Deposit",
                          "value":
                              currencyFormatter.format(bankData.debitQadria!)
                        },
                        {
                          "label": "Credit",
                          "value":
                              currencyFormatter.format(bankData.creditQadria!)
                        },
                      ],
                    ),
                  ),
                  // Vertical Divider
                  Container(
                    width: 1,
                    height: 180,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  // stout section
                  Expanded(
                    child: _buildDetailsColumn(
                      title: "Right",
                      details: [
                        {
                          "label": "Opening Amount",
                          "value":
                              currencyFormatter.format(bankData.openingStout!)
                        },
                        {
                          "label": "Deposit",
                          "value":
                              currencyFormatter.format(bankData.debitStout!)
                        },
                        {
                          "label": "Credit",
                          "value":
                              currencyFormatter.format(bankData.creditStout!)
                        },
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        AutoSizeText(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsColumn(
      {required String title, required List<Map<String, String>> details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: details.map((detail) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                detail["label"]!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail["value"]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
