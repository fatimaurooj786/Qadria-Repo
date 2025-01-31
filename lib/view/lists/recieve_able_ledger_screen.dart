import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadria/model/get/receiveable_leddger.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/components/custom_drop_down_search.dart';
import 'package:qadria/res/utils/currecy_formatter.dart';
import 'package:qadria/view_models/lists/ledger_item_controller.dart';

class RecieveAbleLedgerScreen extends StatefulWidget {
  const RecieveAbleLedgerScreen({super.key});

  @override
  State<RecieveAbleLedgerScreen> createState() =>
      _RecieveAbleLedgerScreenState();
}

class _RecieveAbleLedgerScreenState extends State<RecieveAbleLedgerScreen> {
  final controller = Get.put(LedgerItemController());
  String selectedCity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recieveable Ledgers'),
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
                                CustomDropDownSearch(
                                  selectedItem1: selectedCity,
                                  searchLabelText: "Search City",
                                  labelText: "City",
                                  values: controller.citiesList,
                                  onChanged: (value) {
                                    selectedCity = value!;
                                    controller.updateCitiySelected(value);
                                  },
                                ),

                                const SizedBox(height: 5),

                                const Divider(), // Optional separator for better visual distinction
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Call a method to apply filters and close the dialog
                                      controller.applyFilters(
                                        selectedCity,
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
                        selectedCity = '';
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
              }
              if (controller.ledgerItems.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.35),
                  child: const Center(
                    child: Text(
                      'No recieveable ledgers available',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }
              final ledgers = controller.ledgerItems;
              return Expanded(
                child: ListView.builder(
                  itemCount: ledgers.length,
                  itemBuilder: (context, index) {
                    final ledger = ledgers[index];

                    return InfoCard(
                      location: ledger.city,
                      title: ledger.customerName,
                      personName: ledger.customerName,
                      date: ledger.promise,
                      price: currencyFormatter.format(ledger.remaining),
                      ledgerItem: ledger,
                    );
                  },
                ),
              );
            }),
          ],
        ));
  }
}

class InfoCard extends StatefulWidget {
  final String location;
  final String title;
  final String personName;
  final String date;
  final String price;
  final LedgerItem ledgerItem;

  const InfoCard({
    super.key,
    required this.location,
    required this.title,
    required this.personName,
    required this.date,
    required this.price,
    required this.ledgerItem, // passing LedgerItem to the card
  });

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8), // Reduced margin for a smaller card
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: MyColors.color,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15), // Reduced border radius
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, right: 12, left: 12, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location and Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.orange, size: 20), // Smaller icon size
                      const SizedBox(width: 8),
                      Text(
                        widget.date,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87), // Smaller font size
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.location_on, color: Colors.red, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    widget.location,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title Row
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6), // Reduced padding
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20), // Reduced border radius
                      color: MyColors.color,
                    ),
                    child: Text(
                      widget.price,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: MyColors.color,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ),

              // Expandable content
              if (_isExpanded) ...[
                Text(
                  "Opening Balance: ${currencyFormatter.format(widget.ledgerItem.openingBalance)}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                    "Sales: ${currencyFormatter.format(widget.ledgerItem.totalAmount)}"),
                const SizedBox(height: 6),
                Text(
                    "Purchase: ${currencyFormatter.format(widget.ledgerItem.totalPurchase)}"),
                const SizedBox(height: 6),
                Text(
                    "Received: ${currencyFormatter.format(widget.ledgerItem.totalPaid)}"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
