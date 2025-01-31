import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qadria/repository/lists_repository/cash_voucher_list_repo.dart';
import 'package:qadria/res/utils/size_box_extension.dart';
import '../../data/network/network_api_services.dart';
import '../../db_handler/db_handler.dart';
import '../../model/post/post_cash_voucher_model.dart';
import 'package:dio/dio.dart';
import '../../repository/cash_voucher_repository/cash_voucher_repository.dart';
import '../../res/app_url.dart';
import '../../res/utils/utils.dart';
import '../../view/bottom_nav/home/cash_voucher/cash_voucher_detail.dart';

class CashVoucherController extends GetxController {
  final _api = CashVoucherListRepo();
  final _apiService = NetworkApiService();

  Future<String?> uploadFile({XFile? billImage}) async {
    if (billImage != null) {
      Map<String, dynamic> imageJson = {};
      imageJson['file'] = await MultipartFile.fromFile(billImage.path,
          filename: DateTime.now().millisecondsSinceEpoch.toString());
      dynamic response = await _apiService.getPostApiResponse(
          AppUrl.fileUploadApi, FormData.fromMap(imageJson));
      String? path = response.data['message']['file_url'].toString();
      return path;
    } else {
      return null;
    }
  }

  Future<void> postCashVoucher({
    required String date,
    required String party,
    required int amount,
    required CashVoucherModel voucher,
    required BuildContext context,
    XFile? billImage,
  }) async {
    Get.dialog(
      AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            20.kW,
            const Text("Posting Cash Voucher..."),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    String? attachmentPath = await uploadFile(billImage: billImage);
    _api
        .postCashVoucher(
      date: date,
      party: party,
      amount: amount,
      attachment: attachmentPath ?? "",
    )
        .then((value) {
      DatabaseProvider.instance.insertCashVoucher(voucher).then((_) {
        Utils.successSnackBar('Voucher saved successfully');
        Navigator.pop(context);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CashVoucherDetailScreen(voucher: voucher),
        //   ),
        // );
        Get.back(); // Dismiss the dialog
      });
    }).onError((error, stackTrace) {
      Utils.errorSnackBar(error.toString());
      Get.back(); // Dismiss the dialog
    });
  }
}
