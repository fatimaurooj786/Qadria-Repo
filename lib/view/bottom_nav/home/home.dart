import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadria/res/colors.dart';
import 'package:qadria/res/components/my_slider.dart';
import 'package:qadria/res/constants.dart';
import 'package:qadria/res/my_images.dart';
import 'package:qadria/res/utils/size_box_extension.dart';
import 'package:qadria/view/bottom_nav/home/widgets/menu_button.dart';
import 'package:qadria/view/bottom_nav/home/widgets/monthly_report_chart.dart';
import 'package:qadria/view/lists/delivery_note_list.dart';
import 'package:qadria/view/lists/purchase_invoice_list.dart';
import 'package:qadria/view/lists/purchase_oder_list.dart';
import 'package:qadria/view/lists/purchase_reciept_list.dart';
import 'package:qadria/view/lists/recieve_able_ledger_screen.dart';
import 'package:qadria/view/lists/sales_invoice_list.dart';
import 'package:qadria/view/lists/sales_order_list.dart';

import 'package:qadria/view/bottom_nav/home/widgets/menu_button.dart';
import 'package:qadria/view_models/home/sales_data_controller.dart';
import 'bank_voucher/bank_voucher.dart';
import 'bank_voucher/bank_voucher_list.dart';
import 'cash_voucher/cash_voucher.dart';
import 'cash_voucher/cash_voucher_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(SalesDataController());

  final List<String> carouselImages = [
    "https://avatars.mds.yandex.net/i?id=66227af4862e3d34b0cdc88e44757dd51d8f376b-3766334-images-thumbs&n=13",
    "https://avatars.mds.yandex.net/i?id=38ec94c41ae11bbde769143b635dbd025ca8736e-4578267-images-thumbs&n=13",
    "https://avatars.mds.yandex.net/i?id=d64a1999326ffcdc09ba1a172463f994ca80c7aa-9741045-images-thumbs&n=13",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldSColor,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel Slider
            // MySlider(carouselImages: carouselImages),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: SizedBox(
                  height: 350,
                  width: 350,
                  child: Center(child: CircularProgressIndicator()),
                ));
              }
              if (controller.salesData.isEmpty) {
                return const Center(
                    child: SizedBox(
                        height: 350,
                        width: 350,
                        child: Center(
                            child: Text("No sales data available",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)))));
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        5.kH,
                        const Text("Monthly Sales Report",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SalesChartWithDropdown(
                          salesData: controller.salesData,
                        ),
                      ],
                    )),
              );
            }),
            // GridView for Menu Buttons
            Padding(
              padding: padding,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Display 2 buttons in a row
                  crossAxisSpacing: 20, // Space between columns
                  mainAxisSpacing: 20, // Space between rows
                ),
                itemCount: menuItems.length, // Number of items in the grid
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return MenuButton(
                    onTap: item.onTap,
                    icon: item.icon,
                    buttonText: item.buttonText,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final VoidCallback onTap;
  final IconData icon;
  final String buttonText;

  MenuItem({
    required this.onTap,
    required this.icon,
    required this.buttonText,
  });
}

final List<MenuItem> menuItems = [
  MenuItem(
    onTap: () => Get.to(() => const CashVoucher()),
    icon: Icons.account_balance_wallet,
    buttonText: 'Cash Voucher',
  ),
  MenuItem(
    onTap: () => Get.to(() => const CashVoucherList()),
    icon: Icons.list_alt,
    buttonText: 'Cash Vouchers',
  ),
  MenuItem(
    onTap: () => Get.to(() =>  ApiRequestScreen()),
    icon: Icons.account_balance,
    buttonText: 'Bank Voucher',
  ),
  MenuItem(
    onTap: () => Get.to(() => const BankVoucherList()),
    icon: Icons.list,
    buttonText: 'Bank Vouchers',
  ),
  MenuItem(
    onTap: () => Get.to(() => const SalesOrderList()),
    icon: Icons.list_alt,
    buttonText: 'Sales Orders',
  ),
  MenuItem(
    onTap: () => Get.to(() => const DeliveryNoteList()),
    icon: Icons.local_shipping,
    buttonText: 'Delivery Notes',
  ),
  MenuItem(
    onTap: () => Get.to(() => const SalesInvoiceList()),
    icon: Icons.receipt,
    buttonText: 'Sales Invoices',
  ),
  MenuItem(
    onTap: () => Get.to(() => const PurchaseOrderList()),
    icon: Icons.shopping_cart,
    buttonText: 'Purchase Orders',
  ),
  MenuItem(
    onTap: () => Get.to(() => const PurchaseReceiptList()),
    icon: Icons.archive,
    buttonText: 'Purchase Receipts',
  ),
  MenuItem(
    onTap: () => Get.to(() => const PurchaseInvoiceList()),
    icon: Icons.receipt_long,
    buttonText: 'Purchase Invoices',
  ),

  //recieveable ledger
  MenuItem(
    onTap: () => Get.to(() => const RecieveAbleLedgerScreen()),
    icon: Icons.list_alt,
    buttonText: 'Recieveable Ledgers',
  ),
];
