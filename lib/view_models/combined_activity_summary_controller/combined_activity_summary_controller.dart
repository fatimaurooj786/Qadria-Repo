import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qadria/model/get/combined_summary_model.dart';
import 'package:qadria/model/get/summary_model.dart';
import 'package:qadria/repository/combined_summary/combined_summary_repo.dart';
import 'package:qadria/repository/summary_repository/summary_repository.dart';

class CombinedActivitySummaryController extends GetxController {
  var isLoading = true.obs;
  Rx<CombinedSummaryModel?> combinedActivitySummary =
      Rx<CombinedSummaryModel?>(null);
  var fromDate = DateTime.now().subtract(const Duration(days: 15)).obs;
  var toDate = DateTime.now().obs;

  String get formattedFromDate =>
      DateFormat('yyyy-MM-dd').format(fromDate.value);
  String get formattedToDate => DateFormat('yyyy-MM-dd').format(toDate.value);

  @override
  void onInit() {
    fetchCombinedActivitySummary();
    super.onInit();
  }

  void fetchCombinedActivitySummary() async {
    try {
      isLoading(true);
      final response = await CombinedSummaryRepo()
          .getCombinedActivitySummary(formattedFromDate, formattedToDate);
      // log("Activity Summary: $response");
      combinedActivitySummary.value = response;
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void updateFromDate(DateTime newDate) {
    fromDate.value = newDate;
    fetchCombinedActivitySummary();
  }

  void updateToDate(DateTime newDate) {
    toDate.value = newDate;
    // Ensure fromDate remains earlier than toDate
    if (fromDate.value.isAfter(toDate.value)) {
      fromDate.value = toDate.value.subtract(const Duration(days: 30));
    }
    fetchCombinedActivitySummary();
  }
}
