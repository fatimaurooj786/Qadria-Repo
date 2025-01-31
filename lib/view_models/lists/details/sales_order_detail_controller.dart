import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qadria/model/get/detail_models/sales_order_detail.dart';
import 'package:qadria/model/get/sales_order_model.dart';
import 'package:qadria/repository/lists_repository/details/sales_order_detail_repo.dart';
import 'package:qadria/repository/lists_repository/sales_order_repository.dart';

class SalesOrderDetailController extends GetxController {
  Rx<SalesOrderDetail?> salesOrders = Rx<SalesOrderDetail?>(null);
  RxBool isLoading = true.obs;
  final name = Get.arguments;
  RxString email = ''.obs;
  RxBool isApproving = false.obs;

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email.value = prefs.getString('email') ?? '';
  }

  @override
  void onInit() {
    initMethods();
    super.onInit();
  }

  initMethods() async {
    await getEmail();
    await fetchSalesOrder();
  }

  fetchSalesOrder() async {
    isLoading(true);
    final SalesOrderDetail? salesOrder = await SalesOrderDetailRepo()
        .getSalesOrderDetail(orderId: name, email: email.value);
    salesOrders.value = salesOrder;
    isLoading(false);
  }

  Future<String> postApproval() async {
    isApproving(true);
    final response = await SalesOrderDetailRepo()
        .approvalOrder(orderId: name, email: email.value);

    isApproving(false);
    return response;
  }
}
