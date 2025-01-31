import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:qadria/res/colors.dart';

class ApiRequestScreen extends StatefulWidget {
  @override
  _ApiRequestScreenState createState() => _ApiRequestScreenState();
}

class _ApiRequestScreenState extends State<ApiRequestScreen> {
  String? _selectedType;
  String? _selectedBatch;
  String? _selectedBank;
  String? _selectedCompanyBankAccount;
  String _selectedPartyType = "Customer";
  String? _selectedTransferType;
  String? _referenceNo;
  DateTime? _referenceDate;
  DateTime? _date;
  File? _imageFile;
  double? _amount;
  String? _selectedParty;

  List<String> _batchOptions = [];
  List<String> _bankOptions = [];
  List<String> _partyOptions = [];
  List<String> _companyBankAccountOptions = [];

  final TextEditingController amountController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  // Controllers for date fields
  final TextEditingController referenceDateController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBatchOptions();
    _fetchBankOptions();
    _fetchPartyOptions();
    _fetchCompanyBankAccountOptions();
  }

  Future<void> _fetchPartyOptions() async {
    final String url = _selectedPartyType == 'Customer'
        ? 'http://qd.projectz.pk/api/resource/Customer'
        : 'http://qd.projectz.pk/api/resource/Supplier';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'token a12dd257880a838:995ef71858126ee',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List<dynamic>;
        log("PartyData: $data");
        setState(() {
          _partyOptions = data.map((e) => e['name'].toString()).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch party options.'),
          backgroundColor: Colors.red, // Error snackbar color
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching party options.'),
        backgroundColor: Colors.red, // Error snackbar color
      ));
    }
  }

  Future<void> _fetchBatchOptions() async {
    const String url = 'http://qd.projectz.pk/api/resource/Cheque Batch';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'token a12dd257880a838:995ef71858126ee',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List<dynamic>;
        setState(() {
          _batchOptions = data.map((e) => e['name'].toString()).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch batch options.'),
          backgroundColor: Colors.red, // Error snackbar color
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching batch options.'),
        backgroundColor: Colors.red, // Error snackbar color
      ));
    }
  }

  Future<void> _fetchBankOptions() async {
    const String url = 'http://qd.projectz.pk/api/resource/Bank';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'token a12dd257880a838:995ef71858126ee',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List<dynamic>;
        setState(() {
          _bankOptions = data.map((e) => e['name'].toString()).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch bank options.'),
          backgroundColor: Colors.red, // Error snackbar color
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching bank options.'),
        backgroundColor: Colors.red, // Error snackbar color
      ));
    }
  }

  Future<void> _fetchCompanyBankAccountOptions() async {
    const String url = 'http://qd.projectz.pk/api/resource/Bank Account';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'token a12dd257880a838:995ef71858126ee',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List<dynamic>;
        setState(() {
          _companyBankAccountOptions =
              data.map((e) => e['name'].toString()).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch company bank accounts.'),
          backgroundColor: Colors.red, // Error snackbar color
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching company bank accounts.'),
        backgroundColor: Colors.red, // Error snackbar color
      ));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date)
      setState(() {
        _date = picked;
        dateController.text =
            _date!.toLocal().toString().split(' ')[0]; // Format as 'YYYY-MM-DD'
      });
  }

  Future<void> _selectReferenceDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _referenceDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _referenceDate)
      setState(() {
        _referenceDate = picked;
        referenceDateController.text = _referenceDate!
            .toLocal()
            .toString()
            .split(' ')[0]; // Format as 'YYYY-MM-DD'
      });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _postData() async {
    final String url = 'http://qd.projectz.pk/api/resource/Daybook Bank';

    // Check if required fields are not null before sending the request
    if (_selectedType == null ||
        _selectedCompanyBankAccount == null ||
        _selectedTransferType == null ||
        _selectedBatch == null ||
        _selectedBank == null ||
        _amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all required fields.'),
        backgroundColor: Colors.red, // Error snackbar color
      ));
      return;
    }

    final Map<String, dynamic> requestData = {
      'type': _selectedType,
      'date': _date?.toIso8601String(),
      'reference_no': _referenceNo,
      'reference_date': _referenceDate?.toIso8601String(),
      'company_bank': _selectedCompanyBankAccount,
      'transfer_type': _selectedTransferType,
      'cheque_batch': _selectedBatch,
      'bank_name': _selectedBank,
      'party_type': _selectedPartyType,
      'party': _selectedParty,
      'amount': _amount,
      'attachment': _imageFile != null
          ? base64Encode(_imageFile!.readAsBytesSync())
          : null,
    };

    // Log the request data
    print("Request Data: $requestData");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'token a12dd257880a838:995ef71858126ee',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      // Log the response
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Data submitted successfully!',
            style: TextStyle(color: const Color.fromARGB(255, 15, 214, 8)),
          ),
          backgroundColor: Colors.transparent, // Success snackbar color
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Failed to submit data.',
            style: TextStyle(color: Colors.redAccent),
          ),
          backgroundColor: Colors.transparent, // Error snackbar color
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Error submitting data: $e',
          style: TextStyle(color: Colors.redAccent),
        ),
        backgroundColor: Colors.transparent, // Error snackbar color
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Voucher'),
        // AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Voucher Type Dropdown
            _buildDropdownField(
              'Voucher Type',
              ['Receive', 'Pay'],
              (newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
              selectedValue: _selectedType,
            ),

            SizedBox(height: 20),

            // Date Field with Calendar Icon
            _buildDateInputField('Date', _selectDate, dateController),

            SizedBox(height: 20),

            // Attachment Field
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attachment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000074),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _imageFile == null
                              ? 'Attach File'
                              : 'Attachment Selected',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.attach_file, color: Color(0xFF000074)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Company Bank Account Dropdown
            _buildDropdownField(
              'Company Bank Account',
              _companyBankAccountOptions,
              (newValue) {
                setState(() {
                  _selectedCompanyBankAccount = newValue;
                });
              },
              selectedValue: _selectedCompanyBankAccount,
            ),

            SizedBox(height: 20),

            // Party and Party Type fields inside one card
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Party Type Dropdown
                    _buildDropdownField(
                      'Party Type',
                      ['Customer', 'Supplier'],
                      (newValue) {
                        setState(() {
                          _selectedPartyType = newValue!;
                          _partyOptions
                              .clear(); // Clear the current party options
                          _selectedParty = null; // Reset selected party
                        });
                        _fetchPartyOptions();
                      },
                      selectedValue: _selectedPartyType,
                    ),

                    SizedBox(height: 20),

                    // Party Dropdown
                    _buildDropdownField(
                      'Party',
                      _partyOptions.isNotEmpty
                          ? _partyOptions
                          : ['No parties available'],
                      (newValue) {
                        setState(() {
                          _selectedParty = newValue;
                        });
                      },
                      selectedValue: _selectedParty,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Transfer Type Dropdown
            _buildDropdownField(
              'Transfer Type',
              ['Online', 'Cheque'],
              (newValue) {
                setState(() {
                  _selectedTransferType = newValue;
                });
              },
              selectedValue: _selectedTransferType,
            ),

            SizedBox(height: 20),

            // Bank Dropdown
            _buildDropdownField(
              'Bank Name',
              _bankOptions.isNotEmpty ? _bankOptions : ['No banks available'],
              (newValue) {
                setState(() {
                  _selectedBank = newValue;
                });
              },
              selectedValue: _selectedBank,
            ),

            SizedBox(height: 20),

            // Conditional Batch Dropdown
            if (_selectedTransferType == 'Cheque') ...[
              _buildDropdownField(
                'Batch No',
                _batchOptions.isNotEmpty
                    ? _batchOptions
                    : ['No batches available'],
                (newValue) {
                  setState(() {
                    _selectedBatch = newValue;
                  });
                },
                selectedValue: _selectedBatch,
              ),
              SizedBox(height: 20),
            ],

            // Reference No Field
            _buildTextInputField('Reference No', (value) {
              setState(() {
                _referenceNo = value;
              });
            }),

            SizedBox(height: 20),

            // Reference Date Field with Calendar Icon
            _buildDateInputField('Reference Date', _selectReferenceDate,
                referenceDateController),

            SizedBox(height: 20),

            // Amount Field
            _buildTextInputField('Amount', (value) {
              setState(() {
                _amount = double.tryParse(value);
              });
            }),

            SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: _postData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF000074), // Button background color
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white), // Button text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build dropdown field
  Widget _buildDropdownField(
    String label,
    List<String> options,
    ValueChanged<String?> onChanged, {
    String? selectedValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000074))),
        SizedBox(height: 8),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedValue ?? (options.isNotEmpty ? options.first : null),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Helper method to build date input field with calendar icon
  Widget _buildDateInputField(String label, Function(BuildContext) onTap,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000074))),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => onTap(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select $label',
                suffixIcon: Icon(Icons.calendar_today,
                    color: Color(0xFF000074)), // Calendar icon color
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build simple text input fields
  Widget _buildTextInputField(String label, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000074))),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter $label',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
