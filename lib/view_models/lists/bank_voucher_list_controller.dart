import 'dart:developer';
import 'package:get/get.dart';
import 'package:qadria/model/get/bank_voucher_list.dart'; // Import the updated BankVoucherListModel
import 'package:qadria/repository/filters_repo/customer_repo.dart';
import 'package:qadria/repository/filters_repo/employee_repo.dart';
import 'package:qadria/repository/filters_repo/party_type_repo.dart';
import 'package:qadria/repository/filters_repo/supplier_repo.dart';
import 'package:qadria/repository/lists_repository/bank_voucher_list_repo.dart'; // Import the bank voucher repo

class BankVoucherListController extends GetxController {
  RxList<BankVoucherListModel> bankVoucherList = <BankVoucherListModel>[].obs;
  RxBool isLoading = false.obs;
  int limitStart = 0;
  int limit = 20;
  RxList<String> partyTypeList = <String>[].obs;
  RxList<String> selectedTypeList = <String>[].obs;
  RxString selectedPartyType = ''.obs;
  RxString selectedDate = ''.obs;
  RxString selectedParty = ''.obs;
  RxBool isFiltersLoading = false.obs;
  RxBool isPartyTypeLoading = false.obs;

  @override
  void onInit() {
    initMethods();
    super.onInit();
  }

  initMethods() async {
    await fetchPartyType();
    await fetchBankVouchers(); // Fetch Bank Vouchers initially
  }

  // Fetch Bank Vouchers with optional filters for party, date, and partyType
  fetchBankVouchers({
    String? date,
    String? selectedParty,
    String? selectedPartyType,
  }) async {
    isLoading(true);
    try {
      final List<BankVoucherListModel> bankVouchers = await BankVoucherListRepo().getBankVouchers(
        limitStart: limitStart,
        limit: limit,
        date: date,
        selectedParty: selectedParty,
        selectedPartyType: selectedPartyType,
      );
      if (bankVouchers.isNotEmpty) {
        limitStart += bankVouchers.length; // Update limitStart for next fetch
        bankVoucherList.addAll(bankVouchers); // Append new items to list
      }
    } catch (e) {
      log("Error fetching bank vouchers: $e");
    } finally {
      isLoading(false);
    }
  }

  // Fetching customer data for filters
  fetchCustomer() async {
    try {
      List<String> customer = await CustomerRepo().getCustomers();
      if (customer.isNotEmpty) {
        selectedTypeList.addAll(customer);
        log('Customer List: ${selectedTypeList.length}');
      }
    } catch (e) {
      log("Error fetching customer: $e");
    } finally {
      isPartyTypeLoading(false);
    }
  }

  // Fetching party types for filters
  fetchPartyType() async {
    isFiltersLoading(true);
    isLoading(true);
    try {
      List<String> partyTypes = await PartyTypeRepo().getPartyTypes();
      if (partyTypes.isNotEmpty) {
        partyTypeList.addAll(partyTypes);
        log('Party Type List: ${partyTypeList.length}');
      }
    } catch (e) {
      log("Error fetching party types: $e");
    } finally {
      isFiltersLoading(false);
    }
  }

  // Fetching suppliers for filters
  fetchSuppliers() async {
    try {
      List<String> suppliers = await SupplierRepo().getSuppliers();
      if (suppliers.isNotEmpty) {
        selectedTypeList.addAll(suppliers);
        log('Suppliers List: ${selectedTypeList.length}');
      }
    } catch (e) {
      log("Error fetching suppliers: $e");
    } finally {
      isPartyTypeLoading(false);
    }
  }

  // Fetching employees for filters
  fetchEmployee() async {
    try {
      List<String> employees = await EmployeeRepo().getEmployees();
      if (employees.isNotEmpty) {
        selectedTypeList.addAll(employees);
        log('Employee List: ${selectedTypeList.length}');
      }
    } catch (e) {
      log("Error fetching employees: $e");
    } finally {
      isPartyTypeLoading(false);
    }
  }

  // Update party type selection and clear relevant filters
  updatePartyTypeSelected(String partyType) {
    Future.delayed(const Duration(seconds: 1), () {
      selectedPartyType(partyType);
      selectedParty(''); // Clear selected party when party type changes
      isPartyTypeLoading(true);
      selectedTypeList.clear();

      // Fetch data based on party type
      if (partyType == 'Customer') {
        fetchCustomer();
      } else if (partyType == 'Supplier') {
        fetchSuppliers();
      } else if (partyType == 'Employee') {
        fetchEmployee();
      }
    });
  }

  // Update selected date
  updateDateSelected(String date) {
    selectedDate(date);
  }

  // Update selected party
  updateParty(String party) {
    selectedParty(party);
  }

  // Apply selected filters, including filters for subfields like cash_entries
  void applyFilters() {
    bankVoucherList.clear();
    fetchBankVouchers(
      selectedParty: selectedParty.value.isEmpty ? null : selectedParty.value,
      selectedPartyType: selectedPartyType.value.isEmpty ? null : selectedPartyType.value,
      date: selectedDate.value.isEmpty ? null : selectedDate.value,
    );
    selectedParty('');
    selectedPartyType('');
    selectedDate('');
  }

  // Clear all filters and reset the list
  clearFilters() {
    selectedParty('');
    selectedPartyType('');
    selectedDate('');
    bankVoucherList.clear();
    fetchBankVouchers();
  }

  // Example: Method to process cashEntries (if needed)
  void processCashEntries() {
    for (var voucher in bankVoucherList) {
      for (var cashEntry in voucher.cashEntries) {
        // Example: You can perform actions like printing, filtering, or any processing on cashEntries
        log("Processing Cash Entry: ${cashEntry.account} - ${cashEntry.amount}");
      }
    }
  }
}
