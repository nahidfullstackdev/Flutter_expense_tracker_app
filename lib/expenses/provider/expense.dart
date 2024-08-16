import 'package:expense_tracker/expenses/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath =
      await sql.getDatabasesPath(); //create a directory to create a database..
  final expenseDb = await sql.openDatabase(
    // create a database with specific by name , here is 'places.db'..
    path.join(dbPath, 'expense.db'),
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE user_expense(id TEXT PRIMARY KEY, title TEXT, amount REAL, category TEXT, date TEXT)');
    },
    version: 1,
  );

  return expenseDb;
}

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  ExpenseNotifier() : super(const []);

  //...Loadinng data from SQL Database...................
  Future<void> loadExpenses() async {
    final db = await _getDatabase();

    final data = await db.query('user_expense');
    final expenses = data
        .map((row) => Expense(
            id: row['id'] as String,
            title: row['title'] as String,
            amount: row['amount'] as double,
            category: row['category'] as Category,
            date: row['date'] as DateTime))
        .toList();

    state = expenses;

    // Place(
    //           id: row['id'] as String,
    //           title: row['title'] as String,
    //           image: File(row['image'] as String),
    //           location: UserLocation(
    //               latitude: row['lat'] as double,
    //               longitude: row['lng'] as double,
    //               address: row['address'] as String),
    //         ),
  }
  //................................................................//

  void addExpense(
      String title, double amount, Category category, DateTime date) async {
    final newExpenses =
        Expense(title: title, amount: amount, category: category, date: date);

//........................................................................................//
//..Storing all data in SQL Database by Sqflite Package......

    final db = await _getDatabase();

    db.insert('user_expense', {
      'id': newExpenses.id,
      'title': newExpenses.title,
      'amount': newExpenses.amount,
      'category': newExpenses.category,
      'date': newExpenses.date,
    });

    state = [newExpenses, ...state];
  }
}

final expenseProvider = StateNotifierProvider<ExpenseNotifier, List<Expense>>(
    (ref) => ExpenseNotifier());
