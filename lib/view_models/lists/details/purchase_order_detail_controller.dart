import 'package:get/get.dart';
import 'package:qadria/model/get/detail_models/purchase_order_detail.dart';
import 'package:qadria/repository/lists_repository/details/purchase_order_detail_repo.dart';

class PurchaseOrderDetailController extends GetxController {
  // Reactive variable to hold the purchase order details, including transactionDate
  Rx<PurchaseOrderDetail?> purchaseOrders = Rx<PurchaseOrderDetail?>(null);
  RxBool isLoading = true.obs;

  // The name parameter is passed via arguments
  final name = Get.arguments;

  @override
  void onInit() {
    fetchPurchaseOrder();
    super.onInit();
  }

  // Fetch purchase order details from the repository
  fetchPurchaseOrder() async {
    isLoading(true);
    try {
      final PurchaseOrderDetail? purchaseOrder =
          await PurchaseOrderDetailRepo().getPurchaseOrderDetail(name);
      
      // Assign the fetched purchase order details to the reactive variable
      purchaseOrders.value = purchaseOrder;
      
      // You can access the transactionDate like this:
      if (purchaseOrder != null) {
        print('Transaction Date: ${purchaseOrder.transactionDate}');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
