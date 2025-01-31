class SalesInvoice {
  final String name;
  final String customer;
  
  final String postingDate;
  final String status;
  final double grandTotal;

  SalesInvoice({
    required this.name,
    required this.customer,
    
    required this.postingDate,
    required this.status,
    required this.grandTotal,
  });

  // Factory constructor to create a SalesInvoice from a JSON map
  factory SalesInvoice.fromJson(Map<String, dynamic> json) {
    return SalesInvoice(
      name: json['name'],
      customer: json['customer'],
     
      postingDate: json['posting_date'],
      status: json['status'],
      grandTotal: (json['grand_total'] as num).toDouble(),
    );
  }

  // Method to convert a SalesInvoice instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'customer': customer,
      
      'posting_date': postingDate,
      'status': status,
      'grand_total': grandTotal,
    };
  }
}