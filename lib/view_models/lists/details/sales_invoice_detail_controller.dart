import 'package:get/get.dart';
import 'package:qadria/model/get/detail_models/sales_invoice_detail.dart';
import 'package:qadria/repository/lists_repository/details/sales_invoice_detail_repo.dart';

class SalesInvoiceDetailController extends GetxController {
  Rx<SalesInvoiceDetail?> salesInvoices = Rx<SalesInvoiceDetail?>(null);
  RxBool isLoading = true.obs;
  final name = Get.arguments;

  // Add reactive variable for posting_date
  Rx<String?> postingDate = Rx<String?>(null);

  @override
  void onInit() {
    fetchSalesInvoices();
    super.onInit();
  }

  fetchSalesInvoices() async {
    isLoading(true);
    try {
      final SalesInvoiceDetail? salesInvoiceDetail =
          await SalesInvoiceDetailRepo().getSalesInvoiceDetail(name);

      // Update salesInvoices reactive variable
      salesInvoices.value = salesInvoiceDetail;

      // If salesInvoices is not null, update postingDate
      if (salesInvoiceDetail != null) {
        postingDate.value = salesInvoiceDetail.postingDate; // Assign the posting_date
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
