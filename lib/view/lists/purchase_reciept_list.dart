import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/components/custom_drop_down_search.dart';
import 'package:qadria/view/lists/details/purchase_receipt_detail_screen.dart';
import '../../view_models/lists/purchase_receipt_controller.dart';

class PurchaseReceiptList extends StatefulWidget {
  const PurchaseReceiptList({super.key});

  @override
  State<PurchaseReceiptList> createState() => _PurchaseReceiptListState();
}

class _PurchaseReceiptListState extends State<PurchaseReceiptList> {
  final controller = Get.put(PurchaseReceiptListController());
  final ScrollController _scrollController = ScrollController();
  String selectedSupplier = '';
  String selectedStatus = '';
  String selectedDate = '';
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (selectedSupplier == '' &&
            selectedStatus == '' &&
            selectedDate == '') {
          controller.fetchPurchaseReciepts(); // Load more items
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Purchase Receipts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.isFiltersLoading.value) {
              return const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()));
            }
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
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
                                      selectedItem1: selectedSupplier,
                                      searchLabelText: "Search Supplier",
                                      labelText: "Supplier",
                                      values: controller.supplierList,
                                      onChanged: (value) {
                                        selectedSupplier = value!;
                                        controller
                                            .updateCustomerSelected(value);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomDropDownSearch(
                                      selectedItem1: selectedStatus,
                                      searchLabelText: "Search Status",
                                      labelText: "Status",
                                      values: controller.statusList,
                                      icon: Icons.info,
                                      onChanged: (value) {
                                        selectedStatus = value!;
                                        controller.updateStatusSelected(value);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextField(
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Select Date',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.calendar_today,
                                            color: MyColors.color),
                                      ),
                                      controller: TextEditingController(
                                        text: controller.selectedDate.value,
                                      ),
                                      onTap: () async {
                                        final DateTime? picked =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2015, 8),
                                          lastDate: DateTime(2101),
                                        );
                                        if (picked != null) {
                                          selectedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(picked);
                                          controller.updateDateSelected(
                                            DateFormat('yyyy-MM-dd')
                                                .format(picked),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                );
                              }),

                              const SizedBox(height: 5),

                              const Divider(), // Optional separator for better visual distinction
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Call a method to apply filters and close the dialog
                                    controller.applyFilters(
                                      selectedSupplier,
                                      selectedStatus,
                                      controller.selectedDate.value,
                                    );

                                    Navigator.of(context)
                                        .pop(); // Close the dialog
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
                      selectedSupplier = '';
                      selectedStatus = '';
                      controller.clearFilters();
                    },
                    label: const Text("Clear Filters"),
                    icon: const Icon(Icons.clear),
                  )
                ],
              ),
            );
          }),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (controller.purchaseReceipts.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.35),
                  child: const Center(
                    child: Text(
                      'No purchase receipts available',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: controller.purchaseReceipts.length +
                      (controller.isLoading.value
                          ? 1
                          : 0), // Add a loading indicator
                  itemBuilder: (context, index) {
                    if (index == controller.purchaseReceipts.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final purchaseReceipt = controller.purchaseReceipts[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => const PurchaseReceiptDetailScreen(),
                            arguments: purchaseReceipt.name);
                      },
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.grey.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [const Color.fromARGB(255, 149, 175, 238), Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                  Icons.receipt, purchaseReceipt.name),
                              _buildInfoRow(
                                  Icons.person, purchaseReceipt.supplier),
                              _buildInfoRow(Icons.date_range,
                                  purchaseReceipt.postingDate),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    purchaseReceipt.grandTotal.toStringAsFixed(
                                        2), // Ensure this is numeric
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    purchaseReceipt.status,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(
                                          purchaseReceipt.status),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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

  /// A reusable widget for building info rows with icons.
  Widget _buildInfoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the color for the status text based on its value.
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return MyColors.color;
      case 'submitted':
        return MyColors.color;
      case 'overdue':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      case 'completed':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
