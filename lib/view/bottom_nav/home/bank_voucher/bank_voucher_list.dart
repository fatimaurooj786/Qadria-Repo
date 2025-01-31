import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qadria/model/get/bank_voucher_list.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/components/custom_drop_down_search.dart';
import 'package:qadria/view/bottom_nav/home/bank_voucher/Recieve_screen.dart';
import 'package:qadria/view/bottom_nav/home/cash_voucher/cash_voucher_detail.dart';
import 'package:qadria/view_models/lists/bank_voucher_list_controller.dart';
import 'expense_screen.dart';
import 'pay_screen.dart';
//import 'receive_screen.dart';

class BankVoucherList extends StatefulWidget {
  const BankVoucherList({super.key});

  @override
  State<BankVoucherList> createState() => _BankVoucherListState();
}

class _BankVoucherListState extends State<BankVoucherList> {
  final controller = Get.put(BankVoucherListController());
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'Rs ',
    decimalDigits: 2,
  );
  final ScrollController _scrollController = ScrollController();
  String selectedPartyType = '';
  String selectedParty = '';
  String selectedDate = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (selectedPartyType == '' && selectedParty == '' && selectedDate == '') {
          controller.fetchBankVouchers(); // Load more items if filters are not applied
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bank Vouchers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.isFiltersLoading.value) {
              return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            titlePadding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            title: const Text('Filters'),
                            children: [
                              Obx(() {
                                return Column(
                                  children: [
                                    CustomDropDownSearch(
                                      selectedItem1: selectedPartyType,
                                      searchLabelText: "Search Party Type",
                                      labelText: "Party Type",
                                      values: controller.partyTypeList,
                                      onChanged: (value) {
                                        selectedPartyType = value!;
                                        controller.updatePartyTypeSelected(value);
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    if (controller.isPartyTypeLoading.value)
                                      const Center(child: CircularProgressIndicator()),
                                    if (controller.selectedPartyType.value != '' &&
                                        !controller.isPartyTypeLoading.value)
                                      CustomDropDownSearch(
                                        searchLabelText: 'Search ${controller.selectedPartyType.value}',
                                        labelText: controller.selectedPartyType.value,
                                        values: controller.selectedTypeList,
                                        onChanged: (String? value) {
                                          selectedParty = value!;
                                          controller.updateParty(value);
                                        },
                                      ),
                                    const SizedBox(height: 5),
                                    TextField(
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Select Date',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.calendar_today, color: MyColors.color),
                                      ),
                                      controller: TextEditingController(text: controller.selectedDate.value),
                                      onTap: () async {
                                        final DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2015, 8),
                                          lastDate: DateTime(2101),
                                        );
                                        if (picked != null) {
                                          selectedDate = DateFormat('yyyy-MM-dd').format(picked);
                                          controller.updateDateSelected(DateFormat('yyyy-MM-dd').format(picked));
                                        }
                                      },
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 5),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.applyFilters();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Save'),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    label: const Text('Apply Filters'),
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      selectedParty = '';
                      selectedPartyType = '';
                      controller.clearFilters();
                    },
                    label: const Text("Clear Filters"),
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
            );
          }),
          Obx(() {
            if (controller.isLoading.value && controller.bankVoucherList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (controller.bankVoucherList.isEmpty) {
                return const Expanded(
                  child: Center(child: Text('No bank vouchers available', style: TextStyle(fontSize: 18))),
                );
              }
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: controller.bankVoucherList.length + (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.bankVoucherList.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final invoice = controller.bankVoucherList[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to appropriate screen based on type
                        if (invoice.type == 'Expense') {
                          Get.to(() => ExpenseScreen(), arguments: {
                            'name': invoice.name,
                            'type': invoice.type,
                            'partyType': invoice.partyType,
                            'party': invoice.party,
                            'amount': invoice.amount,
                            'total': invoice.total,
                            'date': invoice.date,
                            'cashEntries': invoice.cashEntries,
                          });
                        } else if (invoice.type == 'Pay') {
                          Get.to(() => PayScreen(), arguments: {
                            'name': invoice.name,
                            'type': invoice.type,
                            'partyType': invoice.partyType,
                            'party': invoice.party,
                            'amount': invoice.amount,
                            'total': invoice.total,
                            'date': invoice.date,
                            'cashEntries': invoice.cashEntries,
                          });
                        } else if (invoice.type == 'Receive') {
                          Get.to(() => ReceiveScreen(), arguments: {
                            'name': invoice.name,
                            'type': invoice.type,
                            'partyType': invoice.partyType,
                            'party': invoice.party,
                            'amount': invoice.amount,
                            'total': invoice.total,
                            'date': invoice.date,
                            'cashEntries': invoice.cashEntries,
                          });
                        }
                      },
                      child: CashVoucherCard(
                        name: invoice.name,
                        type: invoice.type,
                        partyType: invoice.partyType,
                        party: invoice.party,
                        amount: currencyFormatter.format(invoice.amount),
                        total: currencyFormatter.format(invoice.total),
                        date: invoice.date,
                        cashEntries: invoice.cashEntries,
                      ),
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}

class CashVoucherCard extends StatelessWidget {
  final String name;
  final String type;
  final String partyType;
  final String party;
  final String amount;
  final String total;
  final String date;
  final List<CashEntry> cashEntries; // Cash entries

  const CashVoucherCard({
    super.key,
    required this.name,
    required this.type,
    required this.partyType,
    required this.party,
    required this.amount,
    required this.total,
    required this.date,
    required this.cashEntries, // Include cash entries data
  });

  @override
  Widget build(BuildContext context) {
    bool isAmountZero = double.tryParse(amount.replaceAll(RegExp(r'[^0-9.]'), '')) == 0;
    bool isTotalZero = double.tryParse(total.replaceAll(RegExp(r'[^0-9.]'), '')) == 0;

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Type
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Party Type and Party (conditionally show based on null or empty)
            if (partyType.isNotEmpty && party.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.green, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partyType,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          party,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            // Amount, Total, and Date (same line)
            if (!isAmountZero || !isTotalZero) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date with icon on the left
                  Row(
                    children: [
                      // Padding added here to create space between icon and text
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0), // Add padding to the left side of the icon
                        child: const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Date: $date",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                  // Amount and Total on the right
                  if (!isAmountZero)
                    Text(
                      "Amount: $amount",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  if (!isTotalZero)
                    Text(
                      "Total: $total",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            // Cash Entries
            if (cashEntries.isNotEmpty) ...[
              const Text(
                "Cash Entries:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Column(
                children: cashEntries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.green, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Amount: ${entry.amount},",
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
