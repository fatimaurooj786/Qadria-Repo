import 'package:get/get.dart';
import 'package:qadria/model/get/detail_models/purchase_invoice_detail.dart';
import 'package:qadria/model/get/purchase_invoice_model.dart';
import 'package:qadria/repository/lists_repository/details/purchase_invoice_detail_repo.dart';
import 'package:qadria/repository/lists_repository/purchase_invoice_repository.dart';

class PurchaseInvoiceDetailController extends GetxController {
  Rx<PurchaseInvoiceDetail?> purchaseInvoices =
      Rx<PurchaseInvoiceDetail?>(null);
  RxBool isLoading = true.obs;
  final name = Get.arguments;

  @override
  void onInit() {
    fetchPurchaseInvoice();
    super.onInit();
  }

  fetchPurchaseInvoice() async {
    isLoading(true);
    final PurchaseInvoiceDetail? purchaseInvoice =
        await PurchaseInvoiceDetailRepo().getPurchaseInvoiceDetail(name);
    purchaseInvoices.value = purchaseInvoice;
    isLoading(false);
  }
}
