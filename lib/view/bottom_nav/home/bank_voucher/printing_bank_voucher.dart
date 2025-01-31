import 'dart:developer';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:flutter/material.dart';
import 'package:qadria/model/get/detail_models/bank_voucher_detail.dart';
import 'package:qadria/model/post/post_bank_voucher_model.dart';
import 'package:qadria/model/post/post_cash_voucher_model.dart';
import 'package:qadria/res/colors.dart';

class PrintingBankVoucher extends StatefulWidget {
  const PrintingBankVoucher({
    super.key,
    required this.voucher,
  });
  final BankVoucherDetailModel voucher;

  @override
  _PrintingBankVoucherState createState() => _PrintingBankVoucherState();
}

class _PrintingBankVoucherState extends State<PrintingBankVoucher> {
  bool connected = false;
  String? connectedDeviceMac; // Store MAC of the connected device
  List<String> availableBluetoothDevices = [];
  final currencyFormat = NumberFormat("#,##0", "en_US");

  bool isPrinting = false;
  bool isBluetoothOn = false;

  @override
  void initState() {
    super.initState();
    checkBluetoothState();
    checkBluetoothisConnected();
  }

  void checkBluetoothState() async {
    isBluetoothOn = await FlutterBluePlus.isOn;
    if (isBluetoothOn) {
      getBluetooth(); // Automatically fetch Bluetooth devices on init
    }
    setState(() {});
  }

  Future<void> getBluetooth() async {
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    setState(() {
      availableBluetoothDevices = bluetooths?.cast<String>() ?? [];
    });

    // Check if any device is already connected
    final String? currentDevice =
        await BluetoothThermalPrinter.connectionStatus;
    print("Current Device: $currentDevice");
    if (currentDevice != null) {
      print("Current Device2: $currentDevice");
      if (currentDevice == "true") {
        print("Current Device3: $currentDevice");
        setState(() {
          connected = true;
        });
      } else {
        print("Current Device4: $currentDevice");
        setState(() {
          connected = false;
        });
      }
    }
  }

  void checkBluetoothisConnected() async {
    print(FlutterBluePlus.connectedDevices);
  }

  Future<void> setConnect(String mac) async {
    log("Connecting to $mac");
    final String? result = await BluetoothThermalPrinter.connect(mac);
    log("Connection result: $result");
    setState(() {
      connected = result == "true";
      connectedDeviceMac = connected ? mac : null; // Track connected device
    });

    log("Connected: $connected");

    Fluttertoast.showToast(
      msg: connected ? "Connected to $mac" : "Connection Failed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: connected ? Colors.green : Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> printTicket() async {
    if (!connected) {
      Fluttertoast.showToast(
        msg: "Printer not connected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      isPrinting = true;
    });

    // Configure the printer profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    // Create the receipt content
    List<int> bytes = [];

    bytes += generator.text(
      'STOUT ENTERPRISE',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        bold: true,
      ),
    );
    bytes += generator.text("\n");
    bytes += generator.text(
      'INVOICE RECEIPT',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.hr();
    bytes += generator.text(
      'Slip No: ${widget.voucher.name}',
      styles: const PosStyles(bold: true),
    );
    bytes += generator.text(
      'Type: ${widget.voucher.type}',
      styles: const PosStyles(),
    );
    bytes += generator.text(
      'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.voucher.date))}',
    );
    bytes += generator.text(
      'Party: ${widget.voucher.party}',
    );
    bytes += generator.hr();
    bytes += generator.text(
      'Amount: ${currencyFormat.format(widget.voucher.amount)} PKR',
      styles: const PosStyles(bold: true, height: PosTextSize.size2),
    );
    bytes += generator.hr();
    bytes += generator.text(
      'Thank you for choosing us!',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.cut();

    // Send the bytes to the printer
    final String? result = await BluetoothThermalPrinter.writeBytes(bytes);

    if (result == "true") {
      Fluttertoast.showToast(
        msg: "Printing completed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed to print",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    setState(() {
      isPrinting = false;
    });
  }

  Future<void> turnOnBluetooth() async {
    try {
      await FlutterBluePlus.turnOn();
      checkBluetoothState();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to turn on Bluetooth",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Print Bank Voucher",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isBluetoothOn
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // !connected
                      //     ? const Text(
                      //         "No Device is Connected",
                      //         style: TextStyle(
                      //             fontSize: 18, fontWeight: FontWeight.bold),
                      //       )
                      //     : const Text("Device is Connected",
                      //         style: TextStyle(
                      //             fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: availableBluetoothDevices.isNotEmpty &&
                                connected == false
                            ? ListView.builder(
                                itemCount: availableBluetoothDevices.length,
                                itemBuilder: (context, index) {
                                  String device =
                                      availableBluetoothDevices[index];
                                  List<String> details = device.split("#");
                                  String name = details[0];
                                  String mac = details[1];

                                  bool isDeviceConnected =
                                      mac == connectedDeviceMac;

                                  return Card(
                                    color: isDeviceConnected
                                        ? Colors.lightGreen[100]
                                        : Colors.white,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: ListTile(
                                      onTap: () => setConnect(mac),
                                      // onTap: null,
                                      leading: Icon(
                                        isDeviceConnected
                                            ? Icons.bluetooth_connected
                                            : Icons.bluetooth,
                                        color: isDeviceConnected
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      title: Text(name),
                                      subtitle: Text(mac),
                                      trailing: Text(
                                        isDeviceConnected
                                            ? "Connected"
                                            : "Tap to Connect",
                                        style: TextStyle(
                                          color: isDeviceConnected
                                              ? Colors.green
                                              : Colors.grey,
                                          fontWeight: isDeviceConnected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            // child: connected
                            //     ? const Center(
                            //         child: Text(
                            //           "Device connected",
                            //           style: TextStyle(
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //       )
                            : !connected
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Center(
                                        child: Text(
                                          "No devices found. Please open Bluetooth settings",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (OpenSettingsPlus.shared
                                              is OpenSettingsPlusAndroid) {
                                            // Handle Android-specific bluetooth settings
                                            (OpenSettingsPlus.shared
                                                    as OpenSettingsPlusAndroid)
                                                .bluetooth();
                                          } else if (OpenSettingsPlus.shared
                                              is OpenSettingsPlusIOS) {
                                            // Handle iOS-specific bluetooth settings
                                            (OpenSettingsPlus.shared
                                                    as OpenSettingsPlusIOS)
                                                .bluetooth();
                                          } else {
                                            throw Exception(
                                                'Platform not supported');
                                          }
                                        },
                                        child: const Text(
                                            'Open Bluetooth Settings'),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: Text(
                                      "Device connected",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                      ),
                      const SizedBox(height: 30),
                      // connected && isBluetoothOn
                      // ?
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.color,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          onPressed: printTicket,
                          child: const Text(
                            "Print Ticket",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                      // : const SizedBox.shrink(),
                    ],
                  ),
                ),
                if (isPrinting)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Bluetooth is turned off",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: turnOnBluetooth,
                    child: const Text("Turn on Bluetooth"),
                  ),
                ],
              ),
            ),
    );
  }
}
