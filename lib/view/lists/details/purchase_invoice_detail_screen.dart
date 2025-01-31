import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/utils/currecy_formatter.dart';
import 'package:qadria/view_models/lists/details/purchase_invoice_detail_controller.dart';

class PurchaseInvoiceDetailScreen extends StatefulWidget {
  const PurchaseInvoiceDetailScreen({super.key});

  @override
  State<PurchaseInvoiceDetailScreen> createState() =>
      _PurchaseInvoiceDetailScreenState();
}

class _PurchaseInvoiceDetailScreenState
    extends State<PurchaseInvoiceDetailScreen> {
  final controller = Get.put(PurchaseInvoiceDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Invoice Detail"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.purchaseInvoices.value == null) {
          return const Center(
            child: Text(
              'No purchase invoices available',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        final invoice = controller.purchaseInvoices.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Purchase Invoice Detail Card
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
                        "Purchase Invoice Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.green),
                        title: const Text("Supplier"),
                        subtitle: Text(invoice.supplier),
                      ),
                      
                      ListTile(
                        leading:
                            const Icon(Icons.date_range, color: Colors.purple),
                        title: const Text("Due Date"),
                        subtitle:
                            Text(invoice.dueDate.toString().split(" ")[0]),
                      ),
                      ListTile(
                        leading: const Icon(Icons.production_quantity_limits,
                            color: Colors.indigo),
                        title: const Text("Total Quantity"),
                        subtitle: Text(invoice.totalQty.toString()),
                      ),
                      ListTile(
                        leading: const Icon(Icons.monetization_on,
                            color: Colors.brown),
                        title: const Text("Grand Total"),
                        subtitle:
                            Text(currencyFormatter.format(invoice.grandTotal)),
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
                      ...invoice.items.map((item) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Increased border radius for a smoother and modern look
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal:
                                  16), // Larger margin for better spacing
                          elevation: 6, // Added shadow to create depth
                          color: Colors.white, // White background for clarity
                          child: Padding(
                            padding: const EdgeInsets.all(
                                16.0), // More padding for a spacious feel
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Item name with bold and larger font for emphasis
                                Text(
                                  item.itemName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(
                                    height: 8), // Added space after item name

                                // Quantity and Rate with icons for better clarity
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

                                // Discount Amount with an icon for visual clarity
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.local_offer,
                                        size: 18,
                                        color:
                                            MyColors.color), // Icon for discount
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
