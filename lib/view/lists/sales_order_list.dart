import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/components/custom_drop_down_search.dart';
import 'package:qadria/res/utils/currecy_formatter.dart';
import 'package:qadria/view/lists/details/sales_order_detail_screen.dart';
import 'package:qadria/view_models/lists/sales_order_list_controller.dart';
import 'package:intl/intl.dart';

class SalesOrderList extends StatefulWidget {
  const SalesOrderList({super.key});

  @override
  State<SalesOrderList> createState() => _SalesOrderListState();
}

class _SalesOrderListState extends State<SalesOrderList> {
  final controller = Get.put(SalesOrderListController());
  final ScrollController _scrollController = ScrollController();

  String selectedCustomer = '';
  String selectedStatus = '';
  String selectedDate = '';
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'Rs ',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (selectedCustomer == '' &&
            selectedStatus == '' &&
            selectedDate == '') {
          controller.fetchSalesOrders(); // Load more items
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Orders',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.isFiltersLoading.value) {
              return const SizedBox(
                  height: 150,
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
                                      selectedItem1: selectedCustomer,
                                      searchLabelText: "Search Customer",
                                      labelText: "Customer",
                                      values: controller.customerList,
                                      onChanged: (value) {
                                        selectedCustomer = value!;
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
                                      selectedCustomer,
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
                      selectedCustomer = '';
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
            // Show loading indicator if no orders and loading is true
            if (controller.salesOrders.isEmpty && controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.salesOrders.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: Get.height * 0.35),
                child: const Center(
                  child: Text(
                    'No sales orders available',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: controller.salesOrders.length +
                    (controller.isLoading.value
                        ? 1
                        : 0), // Add a loading indicator if necessary
                itemBuilder: (context, index) {
                  // Show loading indicator at the end if more data is loading
                  if (index == controller.salesOrders.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final salesOrder = controller.salesOrders[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => const SalesOrderDetailScreen(),
                          arguments: salesOrder.name);
                    },
                    child: InfoCard(
                      location: salesOrder.customDealerCity,
                      title: salesOrder.customDealer,
                      personName: salesOrder.customer,
                      date: salesOrder.transactionDate,
                      price: currencyFormatter.format(salesOrder.grandTotal),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String location;
  final String title;
  final String personName;
  final String date;
  final String price;

  const InfoCard({
    super.key,
    required this.location,
    required this.title,
    required this.personName,
    required this.date,
    required this.price,
  });

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
                const Spacer(),
                const Icon(Icons.location_on, color: Colors.red, size: 24),
                const SizedBox(width: 5),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Title
            Row(
              children: [
                const Icon(Icons.store, color: Colors.blue, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Person Name
            Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.green, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    personName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
