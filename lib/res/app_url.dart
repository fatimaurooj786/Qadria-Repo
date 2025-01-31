class AppUrl {
  static var baseUrl = 'http://qd.projectz.pk/api/';

  static var login = 'method/login';

  static var resource = 'resource';

  static const method = "method";

  static var customer = '$resource/Customer';

  static var bankAccount = '$resource/Bank Account';

  static var bankVoucher = '$method/Daybook Bank';

  static var cashVoucher = '$method/Expense Entries';

  static const fileUploadApi = "$method/upload_file";

  static var salesInvoiceList = '$resource/Sales Invoice';

  static var salesOrderList = '$resource/Sales Order';

  static var purchaseInvoiceList = '$resource/Purchase Invoice';

  static var deliveryNote = '$resource/Delivery Note';

  static var purchaseReceipt = '$resource/Purchase Receipt';

  static var purchaseOrder = '$resource/Purchase Order';

  static var monthlySales = '$method/monthly_sales';

  static var activitySummary = '$method/activity_summary';

  static var combinedActivitySummary = '$method/combined_activity_report';

  static var recievebaleLeddger = '$method/receivable_ledger';

  static var partyType = '$resource/DocType';

  static var supplier = '$resource/Supplier';

  static var employee = '$resource/Employee';

  static var city = '$method/City';

  static var status = '$resource/Status';

  static var partyBalance = '$method/party_balance';

  //sales_approval
  static var salesApproval = '$method/sales_approval';
}
