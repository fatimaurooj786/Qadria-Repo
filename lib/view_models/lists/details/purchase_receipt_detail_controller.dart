import 'package:get/get.dart';
import 'package:qadria/model/get/detail_models/purchase_receipts_detail.dart';
import 'package:qadria/repository/lists_repository/details/purchase_reciept_detail_repo.dart';

class PurchaseReceiptDetailController extends GetxController {
  Rx<PurchaseReceiptDetail?> purchaseReceipts = Rx<PurchaseReceiptDetail?>(null);
  RxBool isLoading = true.obs;
  final name = Get.arguments;

  @override
  void onInit() {
    fetchPurchaseReciept();
    super.onInit();
  }

  // Fetch Purchase Receipt detail
  fetchPurchaseReciept() async {
    isLoading(true);
    try {
      final PurchaseReceiptDetail? purchaseReceipt =
          await PurchaseRecieptDetailRepo().getPurchaseReceiptDetail(name);
      purchaseReceipts.value = purchaseReceipt;
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  // Helper method to access postingDate from purchaseReceipts
  String get postingDate {
    return purchaseReceipts.value?.postingDate ?? "N/A"; // Return 'N/A' if postingDate is null
  }
}
