import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qadria/model/get/detail_models/cash_voucher_detail_model.dart';
import 'package:qadria/res/utils/currecy_formatter.dart';
import 'package:qadria/view/bottom_nav/home/cash_voucher/printing_cash_voucher.dart';
import 'package:qadria/view_models/lists/details/cash_voucher_detail_controller.dart';
import '../../../../res/my_images.dart';

class CashVoucherDetailScreen extends StatefulWidget {
  const CashVoucherDetailScreen({
    super.key,
  });

  @override
  State<CashVoucherDetailScreen> createState() =>
      _CashVoucherDetailScreenState();
}

class _CashVoucherDetailScreenState extends State<CashVoucherDetailScreen> {
  final controller = Get.put(CashVoucherDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PrintingCashVoucher(
                voucher: controller.cashVocuher.value!,
              ),
            ),
          );
        },
        child: const Icon(Icons.print),
      ),
      appBar: AppBar(
        title: const Text(
          'Cash Voucher Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final CashVoucherDetailModel voucher = controller.cashVocuher.value!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(MyImages.logo,
                    width: Get.width * 0.49, height: Get.height * 0.12),
                const SizedBox(height: 20),
                _buildDetailRow(title: 'Slip no', value: voucher.name),
                _buildDetailRow(title: 'Type', value: voucher.partyType),
                _buildDetailRow(
                  title: 'Date',
                  value: DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(voucher.date)),
                ),
                _buildDetailRow(title: 'Party', value: voucher.party),
                _buildDetailRow(
                    title: voucher.type.toLowerCase() == "expense"
                        ? 'Expense Amount'
                        : 'Amount',
                    value: currencyFormatter.format(voucher.amount),
                    isAmount: true),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildDetailRow(
      {required String title, required String value, bool isAmount = false}) {
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
