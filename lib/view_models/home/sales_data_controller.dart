import 'package:get/get.dart';
import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/model/get/purchase_invoice_model.dart';
import 'package:qadria/model/get/sales_data_model.dart';
import 'package:qadria/repository/home_repository/sales_data_repo.dart';
import 'package:qadria/repository/lists_repository/delivery_note_list_repo.dart';
import 'package:qadria/repository/lists_repository/purchase_invoice_repository.dart';

class SalesDataController extends GetxController {
  RxList<SalesData> salesData = <SalesData>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchSalesData();
    super.onInit();
  }

  fetchSalesData() async {
    isLoading(true);
    try {
      final List<SalesData> salesDataList =
          await SalesDataRepo().getSalesData();
      salesData.assignAll(salesDataList);
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
