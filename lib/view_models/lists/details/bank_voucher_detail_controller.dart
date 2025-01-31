import 'dart:developer';

import 'package:get/get.dart';
import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/model/get/detail_models/bank_voucher_detail.dart';
import 'package:qadria/model/get/detail_models/cash_voucher_detail_model.dart';
import 'package:qadria/model/get/detail_models/delivery_notes_detail.dart';
import 'package:qadria/model/get/purchase_invoice_model.dart';
import 'package:qadria/repository/bank_voucher_repository/bank_voucher_repository.dart';
import 'package:qadria/repository/cash_voucher_repository/cash_voucher_repository.dart';
import 'package:qadria/repository/lists_repository/bank_voucher_list_repo.dart';
import 'package:qadria/repository/lists_repository/delivery_note_list_repo.dart';
import 'package:qadria/repository/lists_repository/details/delivery_note_detail_repo.dart';
import 'package:qadria/repository/lists_repository/purchase_invoice_repository.dart';
import 'package:qadria/view/bottom_nav/home/bank_voucher/bank_voucher.dart';

class BankVoucherDetailController extends GetxController {
  Rx<BankVoucherDetailModel?> cashVocuher = Rx<BankVoucherDetailModel?>(null);
  RxBool isLoading = true.obs;
  final name = Get.arguments;

  @override
  void onInit() {
    fetchBankVoucher();
    super.onInit();
  }

  fetchBankVoucher() async {
    log("Name------------------>$name");
    isLoading(true);
    try {
      final BankVoucherDetailModel? cashVoucher =
          await BankVoucherListRepo().getBankVoucherDetail(name);
      cashVocuher.value = cashVoucher;
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
