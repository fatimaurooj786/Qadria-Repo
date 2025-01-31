import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/components/custom_drop_down_search.dart';
import 'package:qadria/view/lists/details/purchase_invoice_detail_screen.dart';
import 'package:qadria/view_models/lists/purchase_invoice_list_controller.dart';

class PurchaseInvoiceList extends StatefulWidget {
  const PurchaseInvoiceList({super.key});

  @override
  State<PurchaseInvoiceList> createState() => _PurchaseInvoiceListState();
}

class _PurchaseInvoiceListState extends State<PurchaseInvoiceList> {
  final controller = Get.put(PurchaseInvoiceListController());
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'Rs ', // Currency symbol
    decimalDigits: 2, // Number of decimal places
  );
  String selectedSupplier = '';
  String selectedStatus = '';
  String selectedDate = '';

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (selectedSupplier == '' &&
            selectedStatus == '' &&
            selectedDate == '') {
          controller.fetchPurchaseInvoices(); // Load more items
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Purchase Invoices',
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
                                    selectedSupplier = '';
                                    selectedStatus = '';
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
            if (controller.isLoading.value &&
                controller.purchaseInvoices.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (controller.purchaseInvoices.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.35),
                  child: const Center(
                    child: Text(
                      'No purchase invoices available',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: controller.purchaseInvoices.length +
                      (controller.isLoading.value
                          ? 1
                          : 0), // Add a loading indicator
                  itemBuilder: (context, index) {
                    if (index == controller.purchaseInvoices.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final invoice = controller.purchaseInvoices[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => const PurchaseInvoiceDetailScreen(),
                            arguments: invoice.name);
                      },
                      child: PurchaseInvoiceCard(
                        status: invoice.status,
                        supplier: invoice.supplier,
                        date: invoice.postingDate,
                        price: currencyFormatter.format(invoice.grandTotal),
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

class PurchaseInvoiceCard extends StatelessWidget {
  final String status;
  final String supplier;
  final String date;
  final String price;

  const PurchaseInvoiceCard({
    super.key,
    required this.status,
    required this.supplier,
    required this.date,
    required this.price,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: MyColors.color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 5),

            // Person Name
            Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.green, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    supplier,
                    style: const TextStyle(
                      fontSize: 16,
                      // color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Date and Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: MyColors.color,
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
