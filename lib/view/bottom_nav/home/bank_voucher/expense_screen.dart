import 'package:flutter/material.dart';
import 'package:qadria/res/colors.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get data passed from the list view
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final name = arguments['name'];
    final type = arguments['type'];
    final total = arguments['total'];
    final date = arguments['date'];
    final cashEntries = arguments['cashEntries'];

    // Example color (replace with your actual color definition)
    final myColor = MyColors.color; // Change to your actual Mycolor.color

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Details"),
      ),
      body: SingleChildScrollView(  // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top-level card for the details (Name, Date, Type, Total)
            Card(
              elevation: 5,
              color: Colors.white, // Set the top card background to white
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(name),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(date),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Type",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(type),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(total.toString()), // Displaying total as a String
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Cash Entries Card (contains sub-cards for each entry)
            Card(
              elevation: 5,
              color: Colors.white, // Set the sub-cards background to white
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Displaying each cash entry inside a sub-card
                    ...cashEntries.map<Widget>((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          elevation: 5, // Adds shadow effect to the card
                          color: Colors.white, // Set the sub-cards background to white
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0), // 20 padding from left and right
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Bank icon with account name
                                Row(
                                  children: [
                                    Icon(Icons.account_balance, color: myColor), // Bank icon
                                    const SizedBox(width: 8),
                                    Flexible(  // Allowing the text to be flexible within available space
                                      child: Text(
                                        "Account: ${entry.account}",
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,  // In case the text is too long
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                
                                // Dollar icon with amount
                                Row(
                                  children: [
                                    Icon(Icons.attach_money, color: myColor), // Dollar icon
                                    const SizedBox(width: 8),
                                    Flexible(  // Allowing the text to be flexible within available space
                                      child: Text(
                                        "Amount: ${entry.amount}",  // Amount will be displayed as string
                                        style: const TextStyle(),
                                        overflow: TextOverflow.ellipsis,  // In case the text is too long
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                 
                                // Details icon with entry details
                                Row(
                                  children: [
                                    Icon(Icons.details, color: myColor), // Details icon
                                    const SizedBox(width: 8),
                                    Flexible(  // Allowing the text to be flexible within available space
                                      child: Text(
                                        "Details: ${entry.details}",
                                        overflow: TextOverflow.ellipsis,  // In case the text is too long
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
