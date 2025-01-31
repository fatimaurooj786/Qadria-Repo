import 'package:get/get.dart';
import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/model/get/detail_models/delivery_notes_detail.dart';
import 'package:qadria/model/get/purchase_invoice_model.dart';
import 'package:qadria/repository/lists_repository/delivery_note_list_repo.dart';
import 'package:qadria/repository/lists_repository/details/delivery_note_detail_repo.dart';
import 'package:qadria/repository/lists_repository/purchase_invoice_repository.dart';

class DeliveryNoteDetailController extends GetxController {
  Rx<DeliveryNoteDetail?> deliveryNote = Rx<DeliveryNoteDetail?>(null);
  RxBool isLoading = true.obs;
  final name = Get.arguments;

  @override
  void onInit() {
    fetchDeliveryNote();
    super.onInit();
  }

  fetchDeliveryNote() async {
    isLoading(true);
    try {
      final DeliveryNoteDetail? deliveryNote =
          await DeliveryNoteDetailRepo().getDeliveryNoteDetail(name);
      this.deliveryNote.value = deliveryNote;
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
