import 'dart:developer';

import 'package:get/get.dart';

import 'package:qadria/model/get/purchase_reciept_model.dart';
import 'package:qadria/repository/filters_repo/status_repo.dart';
import 'package:qadria/repository/filters_repo/supplier_repo.dart';

import 'package:qadria/repository/lists_repository/purchase_receipt_list_repo.dart';

class PurchaseReceiptListController extends GetxController {
  RxList<PurchaseReceipt> purchaseReceipts = <PurchaseReceipt>[].obs;
  RxBool isLoading = false.obs;
  RxBool isFiltersLoading = false.obs;
  RxList<String> supplierList = <String>[].obs;

  RxList<String> statusList = <String>[].obs;
  int limitStart = 0;
  int limit = 20;
  RxString selectedSupplier = ''.obs;
  RxString selectedStatus = ''.obs;
  RxString selectedDate = ''.obs;

  @override
  void onInit() {
    initMethods();
    super.onInit();
  }

  initMethods() async {
    await fetchSuppliers();
    await fetchStatus();
    await fetchPurchaseReciepts();
  }

  fetchPurchaseReciepts(
      {String? status, String? supplier, String? date}) async {
    // if (isLoading.value) return; // Prevent multiple calls at the same time
    isLoading(true);
    try {
      final List<PurchaseReceipt> purchaseReceiptList =
          await PurchaseReceiptRepo().getPurchaseReceipt(
        limitStart: limitStart,
        limit: limit,
        status: status,
        supplier: supplier,
        date: date,
      );
      if (purchaseReceiptList.isNotEmpty) {
        limitStart +=
            purchaseReceiptList.length; // Update limitStart for the next fetch
        purchaseReceipts.addAll(purchaseReceiptList); // Append new items
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  fetchSuppliers() async {
    isLoading(true);
    isFiltersLoading(true);

    try {
      List<String> suppliers = await SupplierRepo().getSuppliers();
      if (suppliers.isNotEmpty) {
        supplierList.addAll(suppliers);
        log('supplier List: ${supplierList.length}');
      }
    } catch (e) {
      log("Error fetching suppliers: $e");
    }
  }

  fetchStatus() async {
    try {
      List<String> status = await StatusRepo().getStatus();
      if (status.isNotEmpty) {
        statusList.addAll(status);
        log('status List: ${statusList.length}');
      }
    } catch (e) {
      log("Error fetching status: $e");
    } finally {
      isFiltersLoading(false);
    }
  }

  updateCustomerSelected(String customer) {
    selectedSupplier(customer);
  }

  updateStatusSelected(String status) {
    selectedStatus(status);
  }

  updateDateSelected(String date) {
    selectedDate(date);
  }

  void applyFilters(String customer, String status, String date) {
    log("Applying Filters - Customer: $customer, Status: $status, Date: $date");
    purchaseReceipts.clear();
    fetchPurchaseReciepts(
      supplier: customer.isEmpty ? null : customer,
      status: status.isEmpty ? null : status,
      date: date.isEmpty ? null : date,
    );
    selectedSupplier('');
    selectedStatus('');
    selectedDate('');
  }

  clearFilters() {
    selectedSupplier('');
    selectedStatus('');
    selectedDate('');
    purchaseReceipts.clear();
    fetchPurchaseReciepts();
  }
}
