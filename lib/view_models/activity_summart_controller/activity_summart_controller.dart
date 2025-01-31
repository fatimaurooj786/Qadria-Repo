import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qadria/model/get/summary_model.dart';
import 'package:qadria/repository/summary_repository/summary_repository.dart';

class ActivitySummartController extends GetxController {
  var isLoading = true.obs;
  Rx<SummaryModel?> activitySummary = Rx<SummaryModel?>(null);
  var fromDate = DateTime.now().subtract(const Duration(days: 15)).obs;
  var toDate = DateTime.now().obs;

  String get formattedFromDate =>
      DateFormat('yyyy-MM-dd').format(fromDate.value);
  String get formattedToDate => DateFormat('yyyy-MM-dd').format(toDate.value);

  @override
  void onInit() {
    fetchActivitySummary();
    super.onInit();
  }

  void fetchActivitySummary() async {
    try {
      isLoading(true);
      final response = await SummaryRepository()
          .getActivitySummary(formattedFromDate, formattedToDate);
      log("Activity Summary: $response");
      activitySummary.value = response;
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void updateFromDate(DateTime newDate) {
    fromDate.value = newDate;
    fetchActivitySummary();
  }

  void updateToDate(DateTime newDate) {
    toDate.value = newDate;
    // Ensure fromDate remains earlier than toDate
    if (fromDate.value.isAfter(toDate.value)) {
      fromDate.value = toDate.value.subtract(const Duration(days: 30));
    }
    fetchActivitySummary();
  }
}
