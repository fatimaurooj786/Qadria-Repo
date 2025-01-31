import 'dart:developer';
import 'package:get/get.dart';
import '../db_handler/db_handler.dart';
import '../model/post/post_cash_voucher_model.dart';
import '../model/post/post_bank_voucher_model.dart';

class LocalDbController extends GetxController {
  final cashVouchers = <CashVoucherModel>[].obs;
  final bankVouchers = <BankVoucherModel>[].obs;
  final isLoading = false.obs; // Observable for loading state

  // Load cash vouchers with loading indicator
  void loadCashVouchers() async {
    isLoading.value = true;
    try {
      cashVouchers.clear();
      cashVouchers.value = await DatabaseProvider.instance.getCashVouchers();
      log('Cash vouchers loaded');
    } catch (e) {
      log('Error loading cash vouchers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Load bank vouchers with loading indicator
  void loadBankVouchers() async {
    isLoading.value = true;
    try {
      bankVouchers.clear();
      bankVouchers.value = await DatabaseProvider.instance.getBankVouchers();
      log('Bank vouchers loaded');
    } catch (e) {
      log('Error loading bank vouchers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete cash voucher with loading indicator
  void deleteCashVoucher(int id) async {
    isLoading.value = true;
    try {
      await DatabaseProvider.instance.deleteCashVoucher(id);
      cashVouchers.removeWhere((voucher) => voucher.id == id);
      log('Cash voucher deleted');
    } catch (e) {
      log('Error deleting cash voucher: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete bank voucher with loading indicator
  void deleteBankVoucher(int id) async {
    isLoading.value = true;
    try {
      await DatabaseProvider.instance.deleteBankVoucher(id);
      bankVouchers.removeWhere((voucher) => voucher.id == id);
      log('Bank voucher deleted');
    } catch (e) {
      log('Error deleting bank voucher: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
