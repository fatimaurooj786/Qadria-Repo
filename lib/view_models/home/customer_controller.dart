import 'dart:developer';
import 'package:get/get.dart';
import '../../data/response/status.dart';
import '../../model/get/customer_model.dart';
import '../../repository/home_repository/customer_repository.dart';
import '../../res/utils/utils.dart';

class CustomerController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();

  }

  final _api = CustomerRepo();
  RxList<CustomerModel> customerList = <CustomerModel>[].obs;

  final rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  void itemsList(List<CustomerModel> values) {
    customerList.addAll(values);
  }

  void setError(String value) => error.value = value;

  void fetchCustomers() {
    customerList.clear();
    _api.getCustomer().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      itemsList(value);
    }).catchError((error) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
      Utils.errorSnackBar(error.toString());
      log(error.toString());
    });
  }
}
