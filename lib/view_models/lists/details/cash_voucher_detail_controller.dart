import 'dart:developer';

import 'package:get/get.dart';
import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/model/get/detail_models/cash_voucher_detail_model.dart';
import 'package:qadria/model/get/detail_models/delivery_notes_detail.dart';
import 'package:qadria/model/get/purchase_invoice_model.dart';
import 'package:qadria/repository/cash_voucher_repository/cash_voucher_repository.dart';
import 'package:qadria/repository/lists_repository/cash_voucher_list_repo.dart';
import 'package:qadria/repository/lists_repository/delivery_note_list_repo.dart';
import 'package:qadria/repository/lists_repository/details/delivery_note_detail_repo.dart';
import 'package:qadria/repository/lists_repository/purchase_invoice_repository.dart';

class CashVoucherDetailController extends GetxController {
  Rx<CashVoucherDetailModel?> cashVocuher = Rx<CashVoucherDetailModel?>(null);
  RxBool isLoading = true.obs;
  final name = Get.arguments;

  @override
  void onInit() {
    fetchCashVoucher();
    super.onInit();
  }

  fetchCashVoucher() async {
    log("Name------------------>$name");
    isLoading(true);
    try {
      final CashVoucherDetailModel? cashVoucher =
          await CashVoucherListRepo().getCashVoucherListDetail(name);
      cashVocuher.value = cashVoucher;
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
