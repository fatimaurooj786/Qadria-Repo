import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/utils/currecy_formatter.dart'; // Assuming this is where currencyFormatter is located
import 'package:qadria/view_models/lists/details/purchase_receipt_detail_controller.dart';

class PurchaseReceiptDetailScreen extends StatefulWidget {
  const PurchaseReceiptDetailScreen({super.key});

  @override
  State<PurchaseReceiptDetailScreen> createState() =>
      _PurchaseReceiptDetailScreenState();
}

class _PurchaseReceiptDetailScreenState
    extends State<PurchaseReceiptDetailScreen> {
  final controller = Get.put(PurchaseReceiptDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Receipt Detail"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.purchaseReceipts.value == null) {
          return const Center(
            child: Text(
              'No purchase receipt available',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        final purchaseReceipt = controller.purchaseReceipts.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Purchase Receipt Detail Card
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
                        "Purchase Receipt Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.green),
                        title: const Text("Supplier"),
                        subtitle: Text(purchaseReceipt.supplier),
                      ),
                     
                      ListTile(
                        leading: const Icon(Icons.date_range, color: Colors.blue),
                        title: const Text("Posting Date"),
                        subtitle: Text(purchaseReceipt.postingDate), // Displaying postingDate
                      ),
                      ListTile(
                        leading: const Icon(Icons.production_quantity_limits,
                            color: Colors.indigo),
                        title: const Text("Total Quantity"),
                        subtitle: Text(purchaseReceipt.totalQty.toString()),
                      ),
                      ListTile(
                        leading: const Icon(Icons.monetization_on,
                            color: Colors.brown),
                        title: const Text("Grand Total"),
                        subtitle: Text(currencyFormatter
                            .format(purchaseReceipt.grandTotal)),
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
                      ...purchaseReceipt.items.map((item) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Rounded corners for a modern look
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal:
                                  16), // Increased margin for better spacing
                          elevation: 6, // Added shadow for depth
                          color: Colors.white, // White background for clarity
                          child: Padding(
                            padding: const EdgeInsets.all(
                                16.0), // More padding for spacious feel
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
                                    height: 8), // Added space after item name

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
                                    height: 8), // Spacing before amount

                                // Amount with bold and larger font for emphasis
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
