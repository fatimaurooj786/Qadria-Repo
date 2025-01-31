import 'dart:developer';
import 'package:get/get.dart';
import '../../data/response/status.dart';
import '../../model/get/bank_account_model.dart';
import '../../repository/home_repository/bank_account_repository.dart';
import '../../res/utils/utils.dart';

class BankAccountController extends GetxController {

  final _api = BackAccountRepo();
  RxList<BankAccountModel> bankAccountList = <BankAccountModel>[].obs;

  final rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  void itemsList(List<BankAccountModel> values) {
    bankAccountList.addAll(values);
    // Call the method to set the default value when the bank account list is fetched
    updateCompanyAccountCoa();
  }

  void setError(String value) => error.value = value;

  void fetchBankAccount() {
    bankAccountList.clear();
    _api.getBankAccount().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      itemsList(value);
    }).catchError((error) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
      Utils.errorSnackBar(error.toString());
      log(error.toString());
    });
  }

  static String companyAccount = '';

  void updateCompanyAccountCoa() {
    if (bankAccountList.isNotEmpty) {
      // Set companyAccountCoa to the account of the first element
      companyAccount = bankAccountList[0].account;
      log(companyAccount);
    }
  }
}
