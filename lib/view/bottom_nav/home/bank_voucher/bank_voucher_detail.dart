import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qadria/model/get/detail_models/bank_voucher_detail.dart';
import 'package:qadria/res/utils/currecy_formatter.dart';

import 'package:qadria/view/bottom_nav/home/bank_voucher/printing_bank_voucher.dart';
import 'package:qadria/view_models/lists/details/bank_voucher_detail_controller.dart';
import '../../../../model/post/post_bank_voucher_model.dart';
import '../../../../res/my_images.dart';

class BankVoucherDetailScreen extends StatefulWidget {
  const BankVoucherDetailScreen({super.key});

  @override
  State<BankVoucherDetailScreen> createState() =>
      _BankVoucherDetailScreenState();
}

class _BankVoucherDetailScreenState extends State<BankVoucherDetailScreen> {
  final controller = Get.put(BankVoucherDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bank Voucher Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final BankVoucherDetailModel voucher =
                controller.cashVocuher.value!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(MyImages.logo,
                      width: Get.width * 0.49, height: Get.height * 0.12),
                  const SizedBox(height: 20),
                  _buildDetailRow(title: 'Slip No', value: '${voucher.name}'),
                  _buildDetailRow(title: 'Type', value: voucher.type),
                  _buildDetailRow(
                      title: 'Date',
                      value: DateFormat('yyyy-MM-dd')
                          .format(DateTime.parse(voucher.date))),
                  _buildDetailRow(title: 'Party', value: voucher.party),
                  _buildDetailRow(title: 'Bank', value: voucher.companyBank),
                  // _buildDetailRow(title: 'Company Account COA', value: voucher.companyAccountCoa),
                  // _buildDetailRow(title: 'Bank Name', value: voucher.bankName),
                  // _buildDetailRow(title: 'City', value: voucher.city),
                  // _buildDetailRow(title: 'Cheque No', value: voucher.chequeNo),
                  // _buildDetailRow(title: 'Cheque Date', value: DateFormat('yyyy-MM-dd').format(voucher.chequeDate)),
                  _buildDetailRow(
                    title: 'Amount',
                    value: currencyFormatter.format(voucher.amount),
                  ),
                ],
              ),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Uint8List pdfBytes = await _generatePdf();
          // await _printPdf(pdfBytes);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PrintingBankVoucher(
                voucher: controller.cashVocuher.value!,
              ),
            ),
          );
        },
        child: const Icon(Icons.print),
      ),
    );
  }

  Widget _buildDetailRow({required String title, required String value}) {
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
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
