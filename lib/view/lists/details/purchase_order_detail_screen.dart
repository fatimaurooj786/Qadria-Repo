import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/utils/currecy_formatter.dart';
import 'package:qadria/view_models/lists/details/purchase_order_detail_controller.dart';

class PurchaseOrderDetailScreen extends StatefulWidget {
  const PurchaseOrderDetailScreen({super.key});

  @override
  State<PurchaseOrderDetailScreen> createState() =>
      _PurchaseOrderDetailScreenState();
}

class _PurchaseOrderDetailScreenState extends State<PurchaseOrderDetailScreen> {
  final controller = Get.put(PurchaseOrderDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Order Detail"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.purchaseOrders.value == null) {
          return const Center(
            child: Text(
              'No purchase orders available',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        final order = controller.purchaseOrders.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Purchase Order Detail Card
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
                      const Text(
                        "Purchase Order Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.green),
                        title: const Text("Supplier"),
                        subtitle: Text(order.supplier),
                      ),
                      
                      ListTile(
                        leading: const Icon(Icons.date_range,
                            color: Colors.deepOrange),
                        title: const Text("Transaction Date"), // Added field
                        subtitle: Text(order.transactionDate == "N/A"
                            ? "N/A"
                            : order.transactionDate), // Display transaction date
                      ),
                      
                      ListTile(
                        leading: const Icon(Icons.production_quantity_limits,
                            color: Colors.indigo),
                        title: const Text("Total Quantity"),
                        subtitle: Text(order.totalQty.toString()),
                      ),
                      ListTile(
                        leading: const Icon(Icons.monetization_on,
                            color: Colors.brown),
                        title: const Text("Grand Total"),
                        subtitle:
                            Text(currencyFormatter.format(order.grandTotal)),
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
                      const Text(
                        "Items",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      ...order.items.map((item) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // More rounded corners for a modern look
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal:
                                  16), // Larger margin for better spacing
                          elevation: 6, // Adding shadow for depth
                          color: Colors.white, // Clean white background
                          child: Padding(
                            padding: const EdgeInsets.all(
                                16.0), // More padding for a spacious feel
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Item name with larger font and bold for emphasis
                                Text(
                                  item.itemName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors
                                        .black87, // Dark color for readability
                                  ),
                                ),
                                const SizedBox(
                                    height: 8), // Spacing after item name

                                // Quantity with icon and styling
                                Row(
                                  children: [
                                    const Icon(Icons.inventory_2,
                                        size: 18,
                                        color:
                                            Colors.blue), // Icon for quantity
                                    const SizedBox(width: 4),
                                    Text(
                                      "Qty: ${item.qty}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.blueGrey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money,
                                        size: 18,
                                        color: Colors.green), // Icon for rate
                                    const SizedBox(width: 4),
                                    Text(
                                      "Rate: ${currencyFormatter.format(item.rate)}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.green),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height: 8), // Spacing between rows

                                // Discount with icon and styling
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.local_offer,
                                        size: 18,
                                        color: MyColors.color), // Discount icon
                                    const SizedBox(width: 4),
                                    Text(
                                      "Discount: ${currencyFormatter.format(item.discountAmount)}",
                                      style: const TextStyle(
                                          fontSize: 14, color: MyColors.color),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height:
                                        8), // Spacing between amount and UOM

                                // Unit of Measure (UOM) with icon and styling
                                Row(
                                  children: [
                                    const Icon(Icons.shopping_cart,
                                        size: 18,
                                        color: Colors.purple), // UOM icon
                                    const SizedBox(width: 4),
                                    Text(
                                      "UOM: ${item.uom}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.purple),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 8), // Spacing before schedule date

                                // Schedule Date with formatting and icon
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 18,
                                        color: Colors.teal), // Calendar icon
                                    const SizedBox(width: 4),
                                    Text(
                                      "Schedule Date: ${item.scheduleDate != null ? item.scheduleDate.toString().split(" ")[0] : "N/A"}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.teal),
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
        );
      }),
    );
  }
}
