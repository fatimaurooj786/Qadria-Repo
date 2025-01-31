import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/utils/currecy_formatter.dart';
import 'package:qadria/res/utils/utils.dart';
import 'package:qadria/view_models/lists/details/sales_order_detail_controller.dart';

class SalesOrderDetailScreen extends StatefulWidget {
  const SalesOrderDetailScreen({super.key});

  @override
  State<SalesOrderDetailScreen> createState() => _SalesOrderDetailScreenState();
}

class _SalesOrderDetailScreenState extends State<SalesOrderDetailScreen> {
  final controller = Get.put(SalesOrderDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText("Sales Order Detail"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.salesOrders.value == null) {
          return const Center(
            child: AutoSizeText("No data found"),
          );
        }

        final salesOrder = controller.salesOrders.value!;
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Sales Order Detail Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AutoSizeText(
                            "Sales Order Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.tag, color: Colors.blue),
                            title: const AutoSizeText("Order Name"),
                            subtitle: AutoSizeText(salesOrder.details.name),
                          ),
                          ListTile(
                            leading:
                                const Icon(Icons.person, color: Colors.green),
                            title: const AutoSizeText("Customer"),
                            subtitle: AutoSizeText(salesOrder.details.customer),
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_city,
                                color: MyColors.color),
                            title: const AutoSizeText("Dealer"),
                            subtitle:
                                AutoSizeText(salesOrder.details.customDealer),
                          ),
                          ListTile(
                            leading: const Icon(Icons.date_range,
                                color: Colors.purple),
                            title: const AutoSizeText("Transaction Date"),
                            subtitle: AutoSizeText(salesOrder
                                .details.transactionDate
                                .toString()
                                .split(" ")[0]),
                          ),
                          ListTile(
                            leading:
                                const Icon(Icons.approval, color: Colors.teal),
                            title: const AutoSizeText("Approval Status"),
                            subtitle: AutoSizeText(
                                salesOrder.details.customApprovalStatus),
                          ),
                          ListTile(
                            leading: const Icon(Icons.calendar_today,
                                color: Colors.red),
                            title: const AutoSizeText("Delivery Date"),
                            subtitle: AutoSizeText(salesOrder
                                .details.deliveryDate
                                .toString()
                                .split(" ")[0]),
                          ),
                          ListTile(
                            leading: const Icon(
                                Icons.production_quantity_limits,
                                color: Colors.indigo),
                            title: const AutoSizeText("Total Quantity"),
                            subtitle: AutoSizeText(
                                salesOrder.details.totalQty.toString()),
                          ),
                          ListTile(
                            leading: const Icon(Icons.monetization_on,
                                color: Colors.brown),
                            title: const AutoSizeText("Grand Total"),
                            subtitle: AutoSizeText(currencyFormatter
                                .format(salesOrder.details.grandTotal)),
                          ),
                          ListTile(
                            leading: const Icon(Icons.monetization_on,
                                color: Colors.brown),
                            title: const AutoSizeText("Party Balance"),
                            subtitle: AutoSizeText(currencyFormatter
                                .format(salesOrder.partyBalance.partyBalance)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Items Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AutoSizeText(
                            "Items",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          ...salesOrder.details.items.map((item) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Increased border radius for smoother edges
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal:
                                      12), // Larger margin for spacious feel
                              elevation: 6, // Added shadow for depth
                              color:
                                  Colors.white, // White background for clarity
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    16.0), // More padding around content
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Item Name - Bold and larger for emphasis
                                    AutoSizeText(
                                      item.itemName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Extra space between item name and other data

                                    // Quantity and Rate with Icons for better visual appeal
                                    Row(
                                      children: [
                                        const Icon(Icons.inventory_2,
                                            size: 18,
                                            color: Colors
                                                .blue), // Icon for Quantity
                                        const SizedBox(width: 4),
                                        AutoSizeText(
                                          "Qty: ${item.qty}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.blueGrey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.attach_money,
                                            size: 18,
                                            color:
                                                Colors.green), // Icon for Rate
                                        const SizedBox(width: 4),
                                        AutoSizeText(
                                          "Rate: ${currencyFormatter.format(item.rate)}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: 8), // Spacing between rows

                                    // Price List Rate and Discount Percentage with respective icons
                                    Row(
                                      children: [
                                        const Icon(Icons.list,
                                            size: 18,
                                            color: Colors
                                                .teal), // Icon for Price List Rate
                                        const SizedBox(width: 4),
                                        AutoSizeText(
                                          "List Rate: ${currencyFormatter.format(item.amount)}",
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.teal),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.local_offer,
                                            size: 18,
                                            color: MyColors.color), // Discount Percentage Icon
                                        const SizedBox(width: 4),
                                        AutoSizeText(
                                          "Discount: ${item.discountPercentage}%",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: MyColors.color),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: 8), // Spacing before next line

                                    // Discount Amount displayed with currency symbol
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.price_change,
                                            size: 18,
                                            color: Colors
                                                .purple), // Discount Amount icon
                                        const SizedBox(width: 4),
                                        AutoSizeText(
                                          "Discount Amount: ${currencyFormatter.format(item.discountAmount)}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.purple),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (salesOrder.approvalRights.canApprove)
              Positioned(
                  right: 80,
                  left: 80,
                  bottom: 0,
                  child: Obx(() {
                    if (controller.isApproving.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(MyColors.color)),
                        onPressed: () async {
                          showConfirmationDialog(
                              context: context,
                              title: "Approve Sales Order",
                              message:
                                  "Are you sure you want to approve this sales order?",
                              onConfirm: () async {
                                final response =
                                    await controller.postApproval();
                                log("Approval Response inn screen: $response");
                                if (response.toString().toLowerCase() ==
                                    'success') {
                                  Utils.successSnackBar('Order Approved');
                                  await controller.fetchSalesOrder();
                                } else {
                                  Utils.errorSnackBar(
                                      'Failed to approve order');
                                }
                              });
                        },
                        child: const Text(
                          "Approve",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ));
                  })),
          ],
        );
      }),
    );
  }

  void showConfirmationDialog(
      {required BuildContext context,
      required String title,
      required String message,
      required Future<Null> Function() onConfirm}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
