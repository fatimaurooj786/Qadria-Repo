import 'dart:developer';

import 'package:get/get.dart';

import 'package:qadria/model/get/purchase_reciept_model.dart';
import 'package:qadria/model/get/receiveable_leddger.dart';
import 'package:qadria/repository/filters_repo/city_repo.dart';

import 'package:qadria/repository/lists_repository/purchase_receipt_list_repo.dart';
import 'package:qadria/repository/lists_repository/recievable_ledgger_repo.dart';

class LedgerItemController extends GetxController {
  RxList<LedgerItem> ledgerItems = <LedgerItem>[].obs;
  RxBool isLoading = true.obs;
  RxBool isFiltersLoading = false.obs;
  RxList<String> citiesList = <String>[].obs;
  RxString selectedCity = ''.obs;

  @override
  void onInit() {
    initMethods();
    super.onInit();
  }

  initMethods() async {
    await fetchCities();
    await fetchLedgers();
  }

  fetchLedgers({String? city}) async {
    isLoading(true);
    try {
      final List<LedgerItem> purchaseReceiptsList =
          await RecievableLedggerRepo().getRecieveableLeddger(
        city: city,
      );
      log(purchaseReceiptsList.length.toString());
      ledgerItems.assignAll(purchaseReceiptsList);
    } catch (e) {
      print("Error fetching ledgers: $e");
    } finally {
      isLoading(false);
    }
  }

  fetchCities() async {
    isFiltersLoading(true);
    try {
      List<String> cities = await CityRepo().getCities();
      if (cities.isNotEmpty) {
        citiesList.addAll(cities);
        log('cities List: ${citiesList.length}');
      }
    } catch (e) {
      log("Error fetching status: $e");
    } finally {
      isFiltersLoading(false);
    }
  }

  updateCitiySelected(String city) {
    selectedCity(city);
  }

  /// Apply the selected filters
  void applyFilters(String city) {
    log("Applying Filters - city: $city");
    ledgerItems.clear();
    fetchLedgers(
      city: selectedCity.value == '' ? null : selectedCity.value,
    );
    selectedCity('');
  }

  clearFilters() {
    selectedCity('');
    ledgerItems.clear();
    fetchLedgers();
  }
}
