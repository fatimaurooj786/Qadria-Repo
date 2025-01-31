import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../res/my_images.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get data passed from the list view
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final name = arguments['name'];
    final type = arguments['type'];
    final partyType = arguments['partyType'];
    final party = arguments['party'];
    final amount = arguments['amount'];
    final date = arguments['date'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Align(
              alignment: Alignment.center, // Align the image to the center or modify as needed
              child: Image.asset(
                MyImages.logo,
                width: Get.width * 0.49,
                height: Get.height * 0.12,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(title: "Name", value: name),
            _buildDetailRow(title: "Date", value: date),
            _buildDetailRow(title: "Type", value: type),
            _buildDetailRow(title: "Party Type", value: partyType),
            _buildDetailRow(title: "Party", value: party),
            _buildDetailRow(title: "Amount", value: amount.toString(), isAmount: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    bool isAmount = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
