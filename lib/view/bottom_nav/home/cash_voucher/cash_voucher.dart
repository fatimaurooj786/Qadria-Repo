import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../data/response/status.dart';
import '../../../../model/post/post_cash_voucher_model.dart';
import '../../../../res/colors.dart';
import '../../../../res/components/my_button.dart';
import '../../../../res/components/my_text_field.dart';
import '../../../../res/constants.dart';
import '../../../../res/styles.dart';
import '../../../../res/utils/utils.dart';
import '../../../../view_models/cash_voucher_controller/cash_voucher_controller.dart';
import '../../../../view_models/home/customer_controller.dart';
import '../widgets/attachment_picker.dart';
import '../widgets/custom_drop_down.dart';

class CashVoucher extends StatefulWidget {
  const CashVoucher({super.key});

  @override
  State<CashVoucher> createState() => _CashVoucherState();
}

class _CashVoucherState extends State<CashVoucher> {
  String _selectedOption = 'Receive';
  String _selectedOption2 = 'Customer';
  late DateTime _selectedDate;
  XFile? selectedBillFile;
  late String initialOptionMain = '';

  final amountController = TextEditingController();
  final amountFocusNode = FocusNode();
  final CustomerController customerController = Get.put(CustomerController());
  final CashVoucherController cashVoucherController =
      Get.put(CashVoucherController());

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    amountController.clear();
    amountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final decoration2 = decoration.copyWith(color: Theme.of(context).cardColor);
    return Scaffold(
      backgroundColor: MyColors.scaffoldSColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cash Voucher',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: padding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.01),
              Text(
                'Voucher Type',
                style: headerStyle,
              ),
              CustomDropdown(
                value: _selectedOption,
                options: const ['Receive'], // Add more options if needed
                onChanged: (newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                  });
                },
              ),
              space2,
              AttachmentPicker(
                "Picture of Voucher",
                onFileSelected: (XFile? data) {
                  setState(() {
                    selectedBillFile = data;
                  });
                },
                selectedFile: selectedBillFile,
              ),
              space2,
              Text(
                'Voucher Date',
                style: headerStyle,
              ),
              space,
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  height: Get.height * 0.06,
                  padding: const EdgeInsets.all(12),
                  decoration: decoration2,
                  child: Row(
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd').format(_selectedDate),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: MyColors.color,
                      ),
                    ],
                  ),
                ),
              ),
              space2,
              Container(
                padding: padding,
                decoration: decoration2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    space2,
                    Text(
                      'Party Type',
                      style: headerStyle,
                    ),
                    CustomDropdown(
                      value: _selectedOption2,
                      options: const ['Customer'],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedOption2 = newValue!;
                        });
                      },
                    ),
                    space2,
                    Text(
                      'Party',
                      style: headerStyle,
                    ),
                    Obx(() {
                      if (customerController.rxRequestStatus.value ==
                          Status.LOADING) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (customerController.rxRequestStatus.value ==
                          Status.ERROR) {
                        return Center(
                            child: Text(customerController.error.value));
                      } else {
                        List<String> customerNames = customerController
                            .customerList
                            .map((customer) => customer.name)
                            .toList();
                        if (initialOptionMain.isEmpty) {
                          initialOptionMain = customerNames.isNotEmpty
                              ? customerNames[0]
                              : 'Select a customer';
                        }
                        return CustomDropdown(
                          value: initialOptionMain,
                          options: customerNames,
                          onChanged: (newValue) {
                            setState(() {
                              initialOptionMain = newValue!;
                            });
                          },
                        );
                      }
                    }),
                  ],
                ),
              ),
              space2,
              MyTextField(
                controller: amountController,
                hintText: 'Enter amount',
                obscureText: false,
                focusNode: amountFocusNode,
                keyboardType: TextInputType.number,
              ),
              space2,
              // Save button below amount text field
              MyButton(
                onTap: () async {
                  int? amount;
                  if (amountController.text.isNotEmpty) {
                    amount = int.tryParse(amountController.text);
                    if (amount == null) {
                      Utils.errorSnackBar('Please enter a valid amount');
                      return;
                    }
                  } else {
                    Utils.errorSnackBar('Please enter an amount');
                    return;
                  }

                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(_selectedDate);
                  CashVoucherModel voucher = CashVoucherModel(
                    type: _selectedOption,
                    date: _selectedDate,
                    partyType: _selectedOption2,
                    party: initialOptionMain,
                    amount: amount,
                  );

                  cashVoucherController.postCashVoucher(
                    date: formattedDate,
                    party: initialOptionMain,
                    amount: amount,
                    voucher: voucher,
                    billImage: selectedBillFile,
                    context: context,
                  );
                },
                text: 'Save',
                isLoading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import '../../../../data/response/status.dart';
// import '../../../../model/post/post_cash_voucher_model.dart';
// import '../../../../res/colors.dart';
// import '../../../../res/components/my_button.dart';
// import '../../../../res/components/my_text_field.dart';
// import '../../../../res/constants.dart';
// import '../../../../res/styles.dart';
// import '../../../../res/utils/utils.dart';
// import '../../../../view_models/cash_voucher_controller/cash_voucher_controller.dart';
// import '../../../../view_models/home/customer_controller.dart';
// import '../widgets/attachment_picker.dart';
// import '../widgets/custom_drop_down.dart';

// class CashVoucher extends StatefulWidget {
//   const CashVoucher({super.key});

//   @override
//   State<CashVoucher> createState() => _CashVoucherState();
// }

// class _CashVoucherState extends State<CashVoucher> {
//   String _selectedOption = 'Receive';
//   String _selectedOption2 = 'Customer';
//   late DateTime _selectedDate;
//   XFile? selectedBillFile;
//   late String initialOptionMain = '';

//   final amountController = TextEditingController();
//   final amountFocusNode = FocusNode();
//   final CustomerController customerController = Get.put(CustomerController());
//   final CashVoucherController cashVoucherController =
//       Get.put(CashVoucherController());

//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = DateTime.now();
//   }

//   @override
//   void dispose() {
//     amountController.clear();
//     amountController.dispose();
//     amountFocusNode.dispose();
//     super.dispose();
//   }

//   void _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final decoration2 = decoration.copyWith(color: Theme.of(context).cardColor);
//     return Scaffold(
//       backgroundColor: MyColors.scaffoldSColor,
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Cash voucher'),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: padding,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: Get.height * 0.06),
//                   Text(
//                     'Voucher Type',
//                     style: headerStyle,
//                   ),
//                   CustomDropdown(
//                     value: _selectedOption,
//                     options: const ['Receive'], // Add more options if needed
//                     onChanged: (newValue) {
//                       setState(() {
//                         _selectedOption = newValue!;
//                       });
//                     },
//                   ),
//                   space2,
//                   AttachmentPicker(
//                     "Picture of Voucher",
//                     onFileSelected: (XFile? data) {
//                       setState(() {
//                         selectedBillFile = data;
//                       });
//                     },
//                     selectedFile: selectedBillFile,
//                   ),
//                   space2,
//                   Text(
//                     'Voucher Date',
//                     style: headerStyle,
//                   ),
//                   space,
//                   InkWell(
//                     onTap: () => _selectDate(context),
//                     child: Container(
//                       height: Get.height * 0.06,
//                       padding: const EdgeInsets.all(12),
//                       decoration: decoration2,
//                       child: Row(
//                         children: [
//                           Text(
//                             DateFormat('yyyy-MM-dd').format(_selectedDate),
//                             style: const TextStyle(color: Colors.black),
//                           ),
//                           const Spacer(),
//                           const Icon(
//                             Icons.calendar_month_outlined,
//                             color: MyColors.color,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   space2,
//                   Container(
//                     padding: padding,
//                     decoration: decoration2,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         space2,
//                         Text(
//                           'Party Type',
//                           style: headerStyle,
//                         ),
//                         CustomDropdown(
//                           value: _selectedOption2,
//                           options: const ['Customer'],
//                           // Add more options if needed
//                           onChanged: (newValue) {
//                             setState(() {
//                               _selectedOption2 = newValue!;
//                             });
//                           },
//                         ),
//                         space2,
//                         Text(
//                           'Party',
//                           style: headerStyle,
//                         ),
//                         Obx(() {
//                           if (customerController.rxRequestStatus.value ==
//                               Status.LOADING) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           } else if (customerController.rxRequestStatus.value ==
//                               Status.ERROR) {
//                             return Center(
//                                 child: Text(customerController.error.value));
//                           } else {
//                             List<String> customerNames = customerController
//                                 .customerList
//                                 .map((customer) => customer.name)
//                                 .toList();
//                             if (initialOptionMain.isEmpty) {
//                               initialOptionMain = customerNames.isNotEmpty
//                                   ? customerNames[0]
//                                   : 'Select a customer';
//                             }
//                             return CustomDropdown(
//                               value: initialOptionMain,
//                               options: customerNames,
//                               onChanged: (newValue) {
//                                 setState(() {
//                                   initialOptionMain = newValue!;
//                                 });
//                               },
//                             );
//                           }
//                         }),
//                       ],
//                     ),
//                   ),
//                   space2,
//                   MyTextField(
//                     controller: amountController,
//                     hintText: 'Enter amount',
//                     obscureText: false,
//                     focusNode: amountFocusNode,
//                     keyboardType: TextInputType.number,
//                   ),
//                   space2,
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: MyButton(
//                 onTap: () async {
//                   int? amount;
//                   if (amountController.text.isNotEmpty) {
//                     amount = int.tryParse(amountController.text);
//                     if (amount == null) {
//                       Utils.errorSnackBar('Please enter a valid amount');
//                       return;
//                     }
//                   } else {
//                     Utils.errorSnackBar('Please enter an amount');
//                     return;
//                   }

//                   String formattedDate =
//                       DateFormat('yyyy-MM-dd').format(_selectedDate);
//                   CashVoucherModel voucher = CashVoucherModel(
//                     type: _selectedOption,
//                     date: _selectedDate,
//                     partyType: _selectedOption2,
//                     party: initialOptionMain,
//                     amount: amount,
//                   );

//                   cashVoucherController.postCashVoucher(
//                     date: formattedDate,
//                     party: initialOptionMain,
//                     amount: amount,
//                     voucher: voucher,
//                     billImage: selectedBillFile,
//                     context: context,
//                   );
//                 },
//                 text: 'Save',
//                 isLoading: false,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
