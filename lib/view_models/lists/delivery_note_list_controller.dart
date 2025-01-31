import 'dart:developer';

import 'package:get/get.dart';
import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/repository/filters_repo/customer_repo.dart';
import 'package:qadria/repository/filters_repo/status_repo.dart';
import 'package:qadria/repository/lists_repository/delivery_note_list_repo.dart';

class DeliveryNoteListController extends GetxController {
  RxList<DeliveryNote> deliveryNotes = <DeliveryNote>[].obs;

  RxBool isLoading = false.obs;
  RxBool isFiltersLoading = false.obs;
  RxList<String> customerList = <String>[].obs;

  RxList<String> statusList = <String>[].obs;
  int limitStart = 0;
  int limit = 20;
  RxString selectedCustomer = ''.obs;
  RxString selectedStatus = ''.obs;
  RxString selectedDate = ''.obs;

  @override
  void onInit() {
    initMethods();
    super.onInit();
  }

  initMethods() async {
    await fetchCustomers();
    await fetchStatus();
    await fetchDeliveryNotes();
  }

  fetchDeliveryNotes({String? status, String? customer, String? date}) async {
    isLoading(true);
    try {
      final List<DeliveryNote> delivery =
          await DeliveryNoteListRepo().getDeliveryNotes(
        limitStart: limitStart,
        limit: limit,
        status: status,
        customer: customer,
        date: date,
      );
      if (delivery.isNotEmpty) {
        limitStart += delivery.length; // Update limitStart for the next fetch
        deliveryNotes.addAll(delivery); // Append new items
      }
    } catch (e) {
      log("Error fetching delivery notes: $e");
    } finally {
      isLoading(false);
    }
  }

  fetchCustomers() async {
    isLoading(true);
    isFiltersLoading(true);

    try {
      List<String> customers = await CustomerRepo().getCustomers();
      if (customers.isNotEmpty) {
        customerList.addAll(customers);
        log('Customer List: ${customerList.length}');
      }
    } catch (e) {
      log("Error fetching customers: $e");
    } finally {
      isFiltersLoading(false);
    }
  }

  fetchStatus() async {
    try {
      List<String> status = await StatusRepo().getStatus();
      if (status.isNotEmpty) {
        statusList.addAll(status);
        log('Status List: ${statusList.length}');
      }
    } catch (e) {
      log("Error fetching status: $e");
    } finally {
      isFiltersLoading(false);
    }
  }

  updateCustomerSelected(String customer) {
    selectedCustomer(customer);
  }

  updateStatusSelected(String status) {
    selectedStatus(status);
  }

  updateDateSelected(String date) {
    selectedDate(date);
  }

  /// Apply the selected filters
  void applyFilters(String customer, String status, String date) {
    log("Applying Filters - Customer: $customer, Status: $status, Date: $date");
    deliveryNotes.clear();
    fetchDeliveryNotes(
      customer: customer.isEmpty ? null : customer,
      status: status.isEmpty ? null : status,
      date: date.isEmpty ? null : date,
    );
    selectedCustomer('');
    selectedStatus('');
    selectedDate('');
  }

  clearFilters() {
    selectedCustomer('');
    selectedStatus('');
    selectedDate('');
    deliveryNotes.clear();
    fetchDeliveryNotes();
  }
}
