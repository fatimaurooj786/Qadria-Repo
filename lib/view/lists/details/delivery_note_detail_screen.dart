import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/utils/currecy_formatter.dart';
import 'package:qadria/view_models/lists/details/delivery_note_detail_controller.dart';

class DeliveryNoteDetailScreen extends StatefulWidget {
  const DeliveryNoteDetailScreen({super.key});

  @override
  State<DeliveryNoteDetailScreen> createState() =>
      _DeliveryNoteDetailScreenState();
}

class _DeliveryNoteDetailScreenState extends State<DeliveryNoteDetailScreen> {
  final controller = Get.put(DeliveryNoteDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText("Delivery Note Detail"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.deliveryNote.value == null) {
          return const Center(
            child: AutoSizeText(
              'No delivery notes available',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        final deliveryNote = controller.deliveryNote.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Delivery Note Detail Card
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
                        "Delivery Note Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.green),
                        title: const AutoSizeText("Customer"),
                        subtitle: AutoSizeText(deliveryNote.customer),
                      ),
                      ListTile(
                        leading: const Icon(Icons.store, color: Colors.blue),
                        title: const AutoSizeText("Dealer"),
                        subtitle: AutoSizeText(deliveryNote.customDealer),
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.location_city, color: Colors.red),
                        title: const AutoSizeText("Dealer City"),
                        subtitle: AutoSizeText(deliveryNote.customDealerCity),
                      ),
                      ListTile(
                        leading: const Icon(Icons.production_quantity_limits,
                            color: Colors.indigo),
                        title: const AutoSizeText("Total Quantity"),
                        subtitle:
                            AutoSizeText(deliveryNote.totalQty.toString()),
                      ),
                      ListTile(
                        leading: const Icon(Icons.monetization_on,
                            color: Colors.brown),
                        title: const AutoSizeText("Grand Total"),
                        subtitle: AutoSizeText(
                            currencyFormatter.format(deliveryNote.grandTotal)),
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
                      ...deliveryNote.items.map((item) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Slightly larger border radius for smoother edges
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal:
                                  12), // Increased margins for better spacing
                          elevation: 4, // Adding shadow for depth
                          color: Colors.white, // White background for clarity
                          child: Padding(
                            padding: const EdgeInsets.all(
                                16.0), // More padding for a spacious feel
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Item name
                                AutoSizeText(
                                  item.itemName,
                                  style: const TextStyle(
                                    fontSize:
                                        18, // Larger font size for better visibility
                                    fontWeight: FontWeight
                                        .w600, // Slightly lighter weight for elegance
                                    color: Colors
                                        .black87, // Subtle black color for the title
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        8), // More space between title and data

                                // Quantity and Rate in one row with icons
                                Row(
                                  children: [
                                    const Icon(Icons.inventory_2,
                                        size: 18,
                                        color:
                                            Colors.blue), // Icon for quantity
                                    const SizedBox(width: 4),
                                    AutoSizeText(
                                      "Qty: ${item.qty}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.blueGrey),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height:
                                        8), // More space between title and data

                                Row(
                                  children: [
                                    const Icon(Icons.attach_money,
                                        size: 18,
                                        color: Colors.green), // Icon for rate
                                    const SizedBox(width: 4),
                                    AutoSizeText(
                                      "Rate: ${currencyFormatter.format(item.rate)}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.green),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height: 8), // Spacing between rows

                                // Discount and UOM in one row with icons
                                Row(
                                  children: [
                                    const Icon(Icons.discount,
                                        size: 18,
                                        color: MyColors.color), // Discount icon
                                    const SizedBox(width: 4),
                                    AutoSizeText(
                                      "Discount: ${currencyFormatter.format(item.discountAmount)}",
                                      style: const TextStyle(
                                          fontSize: 14, color: MyColors.color),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height:
                                        8), // Spacing between discount and UOM
                                Row(
                                  children: [
                                    const Icon(Icons.shopping_cart,
                                        size: 18,
                                        color: Colors.purple), // UOM icon
                                    const SizedBox(width: 4),
                                    AutoSizeText(
                                      "UOM: ${item.uom}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.purple),
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
