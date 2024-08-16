import 'package:expense_tracker/chart/chart.dart';
import 'package:expense_tracker/expenses/models/expense.dart';
import 'package:expense_tracker/expenses/provider/expense.dart';
import 'package:expense_tracker/expenses/widgets/without_form/expense_list/expense_list.dart';
import 'package:expense_tracker/expenses/widgets/without_form/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Expenses extends ConsumerStatefulWidget {
  const Expenses({super.key});

  @override
  ConsumerState<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends ConsumerState<Expenses> {
  void _openAddExpenseOverLay() {
    //..modal Sheet
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(
            onAddExpense: addExpense,
          );
        });
  }

  void addExpense(Expense expense) {
    setState(() {
      ref.read(expenseProvider.notifier).addExpense(
          expense.title, expense.amount, expense.category, expense.date);
    });
  }

  // void removeExpense(Expense expense) {
  //   final expenseIndex = _registeredExpense.indexOf(expense);
  //   setState(() {
  //     _registeredExpense.remove(expense);
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       duration: const Duration(seconds: 3),
  //       content: const Text('Expense deleted'),
  //       action: SnackBarAction(
  //           label: 'Undo',
  //           onPressed: () {
  //             setState(() {
  //               _registeredExpense.insert(expenseIndex, expense);
  //             });
  //           }),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expenseProvider);

    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No Expenses found, Start adding some'),
    );

    if (expenses.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: expenses,
        // onRemoveExpense: removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverLay,
              icon: const Icon(
                Icons.add,
              ),
            )
          ],
          title: const Text(
            'Expense Tracker App',
          )),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: expenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: expenses),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
