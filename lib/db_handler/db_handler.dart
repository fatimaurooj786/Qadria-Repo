import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/post/post_bank_voucher_model.dart';
import '../model/post/post_cash_voucher_model.dart';

class DatabaseProvider {
  static const String CASH_VOUCHERS = 'cash_voucher';
  static const String BANK_VOUCHERS = 'bank_voucher';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_DATA = 'data';

  DatabaseProvider._(); // private constructor

  static final DatabaseProvider instance = DatabaseProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> clearCashVouchers() async {
    final db = await database;
    await db.delete(CASH_VOUCHERS);
    log('Data Cleared');
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'vouchers.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $CASH_VOUCHERS (
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_DATA TEXT NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE $BANK_VOUCHERS (
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_DATA TEXT NOT NULL
      )
      ''');
  }

  Future<int> insertCashVoucher(CashVoucherModel voucher) async {
    final db = await database;
    int id = await db.insert(
      CASH_VOUCHERS,
      {
        COLUMN_DATA: cashVoucherModelToJson(voucher),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    voucher.id = id; // Update the ID in the voucher object
    return id; // Return the ID of the inserted voucher
  }


  Future<int> insertBankVoucher(BankVoucherModel voucher) async {
    final db = await database;
    int id = await db.insert(
      BANK_VOUCHERS,
      {
        COLUMN_DATA: bankVoucherModelToJson(voucher),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    voucher.id = id; // Update the ID in the voucher object
    return id; // Return the ID of the inserted voucher
  }

  Future<List<CashVoucherModel>> getCashVouchers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(CASH_VOUCHERS);

    List<CashVoucherModel> vouchers = List.generate(maps.length, (i) {
      CashVoucherModel voucher = CashVoucherModel.fromJson(
        json.decode(maps[i][COLUMN_DATA]),
      );

      voucher.id = maps[i][COLUMN_ID];

      log("ID: ${voucher.id.toString()}"); // Log the ID explicitly
      log('Type: ${voucher.type}');
      log('Date: ${voucher.date}');
      log('Party Type: ${voucher.partyType}');
      log('Party: ${voucher.party}');
      log('Amount: ${voucher.amount}');
      log('==========================');

      return voucher;
    });

    return vouchers;
  }


  Future<List<BankVoucherModel>> getBankVouchers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(BANK_VOUCHERS);

    List<BankVoucherModel> vouchers = List.generate(maps.length, (i) {
      BankVoucherModel voucher = BankVoucherModel.fromJson(
        json.decode(maps[i][COLUMN_DATA]),
      );

      voucher.id = maps[i][COLUMN_ID];

      log("ID: ${voucher.id.toString()}"); // Log the ID explicitly
      log('Type: ${voucher.type}');
      log('Date: ${voucher.date}');
      log('Party Type: ${voucher.partyType}');
      log('Party: ${voucher.party}');
      log('Company Bank: ${voucher.companyBank}');
      log('Company Account COA: ${voucher.companyAccountCoa}');
      log('Bank Name: ${voucher.bankName}');
      log('City: ${voucher.city}');
      log('Cheque No: ${voucher.chequeNo}');
      log('Cheque Date: ${voucher.chequeDate}');
      log('Amount: ${voucher.amount}');
      log('==========================');

      return voucher;
    });

    return vouchers;
  }

  Future<void> updateCashVoucher(CashVoucherModel voucher, id) async {
    final db = await database;
    await db.update(
      CASH_VOUCHERS,
      {
        COLUMN_DATA: cashVoucherModelToJson(voucher),
      },
      where: '$COLUMN_ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateBankVoucher(BankVoucherModel voucher, id) async {
    final db = await database;
    await db.update(
      BANK_VOUCHERS,
      {
        COLUMN_DATA: bankVoucherModelToJson(voucher),
      },
      where: '$COLUMN_ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCashVoucher(int id) async {
    final db = await database;
    await db.delete(
      CASH_VOUCHERS,
      where: '$COLUMN_ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBankVoucher(int id) async {
    final db = await database;
    await db.delete(
      BANK_VOUCHERS,
      where: '$COLUMN_ID = ?',
      whereArgs: [id],
    );
  }
}
