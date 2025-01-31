import 'dart:developer';
import 'package:get/get.dart';
import 'package:qadria/model/get/sales_invoice_model.dart';
import 'package:qadria/model/get/detail_models/sales_invoice_detail.dart'; // Import sales invoice detail model
import 'package:qadria/repository/filters_repo/customer_repo.dart';
import 'package:qadria/repository/filters_repo/status_repo.dart';
import 'package:qadria/repository/lists_repository/sales_invoice_repository.dart';
import 'package:qadria/repository/lists_repository/details/sales_invoice_detail_repo.dart';

class SalesInvoiceListController extends GetxController {
  RxList<SalesInvoice> salesInvoices = <SalesInvoice>[].obs;
  RxBool isLoading = false.obs;
  RxBool isFiltersLoading = false.obs;
  RxList<String> customerList = <String>[].obs;
  RxList<String> statusList = <String>[].obs;
  int limitStart = 0;
  int limit = 20;
  RxString selectedCustomer = ''.obs;
  RxString selectedStatus = ''.obs;
  RxString selectedDate = ''.obs;

  // For displaying the selected sales invoice detail
  Rx<SalesInvoiceDetail?> selectedInvoiceDetail = Rx<SalesInvoiceDetail?>(null);

  @override
  void onInit() {
    initMethods();
    super.onInit();
  }

  initMethods() async {
    await fetchCustomers();
    await fetchStatus();
    await fetchSalesInvoices();
  }

  fetchSalesInvoices({String? status, String? customer, String? date}) async {
    isLoading(true);
    try {
      final List<SalesInvoice> salesInvoicesList =
          await SalesInvoiceRepo().getSalesInvoices(
        limitStart: limitStart,
        limit: limit,
        status: status,
        customer: customer,
        date: date,
      );
      if (salesInvoicesList.isNotEmpty) {
        limitStart += salesInvoicesList.length; // Update limitStart for the next fetch
        salesInvoices.addAll(salesInvoicesList); // Append new items
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
    salesInvoices.clear();
    fetchSalesInvoices(
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
    salesInvoices.clear();
    fetchSalesInvoices();
  }

  // Method to view sales invoice detail
  Future<void> viewSalesInvoiceDetail(SalesInvoice invoice) async {
    try {
      // Fetch the detail data for the selected invoice
      final SalesInvoiceDetail? salesInvoiceDetail =
          await SalesInvoiceDetailRepo().getSalesInvoiceDetail(invoice.name);

      // Set the selected invoice detail
      selectedInvoiceDetail.value = salesInvoiceDetail;

      // Navigate to the detail screen, passing the necessary information
      Get.toNamed('/sales_invoice_detail', arguments: salesInvoiceDetail);
    } catch (e) {
      log("Error fetching sales invoice details: $e");
    }
  }
}
