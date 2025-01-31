import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadria/model/get/sales_order_model.dart';
import 'package:qadria/repository/filters_repo/customer_repo.dart';
import 'package:qadria/repository/filters_repo/status_repo.dart';
import 'package:qadria/repository/lists_repository/sales_order_repository.dart';

class SalesOrderListController extends GetxController {
  RxList<SaleOrder> salesOrders = <SaleOrder>[].obs;
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
    await fetchSalesOrders();
  }

  fetchSalesOrders({String? status, String? customer, String? date}) async {
    // log("Fetching Sales Orders with status: $status and customer: $customer");
    // if (isLoading.value) return; // Prevent multiple calls at the same time
    isLoading(true);

    try {
      final List<SaleOrder> salesOders = await SalesOrderRepo().getSalesOrders(
        limitStart: limitStart,
        limit: limit,
        status: status,
        customer: customer,
        date: date,
      );
      if (salesOders.isNotEmpty) {
        limitStart += salesOders.length; // Update limitStart for the next fetch
        salesOrders.addAll(salesOders); // Append new items
      }
    } catch (e) {
      print(e);
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
    selectedCustomer(customer);
  }

  updateStatusSelected(String status) {
    selectedStatus(status);
  }

  updateDateSelected(String date) {
    selectedDate(date);
  }

  void applyFilters(String customer, String status, String date) {
    log("Applying Filters - Customer: $customer, Status: $status, Date: $date");
    salesOrders.clear();
    fetchSalesOrders(
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
    salesOrders.clear();
    fetchSalesOrders();
  }
}
