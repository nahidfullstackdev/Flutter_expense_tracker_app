import 'package:expense_tracker/expenses/models/expense.dart';
import 'package:expense_tracker/expenses/widgets/without_form/expense_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;
  // final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error,
          margin: Theme.of(context).cardTheme.margin,
        ),
        key: ValueKey(
          expenses[index],
        ),
        // onDismissed: (direction) => onRemoveExpense(
        //   expenses[index],
        // ),
        child: ExpenseItem(
          expenses[index],
        ),
      ),
    );
  }
}
