import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/utilis/utilis.dart';
import 'package:expense_tracker/view_model/expense_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double? amount;
  late final datePicked;

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view_model = Provider.of<ExpenseViewModel>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Add Expense', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 100),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.attach_money_rounded),
                    hintText: 'Amount',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 215, 215, 215),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    //make sure some amount is entered
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount';
                    }
                    amount = double.tryParse(value);
                    //make sure amount is > 0
                    if (amount == null || amount! <= 0) {
                      return 'Please enter a valid amount';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.label_outline_rounded),
                    hintText: 'Category',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 215, 215, 215),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    //make sure category is entered
                    if (value == null || value.isEmpty) {
                      return 'Please enter the category';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  readOnly: true,
                  controller: _dateController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.date_range),
                    hintText: 'Pick a date',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 215, 215, 215),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  onTap: () async {
                    datePicked = await showDatePicker(
                      helpText: 'Pick a date',
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (datePicked != null) {
                      _dateController.text =
                          '${datePicked.day} /${datePicked.month} /${datePicked.year}';
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      //make sure data is entered
                      return 'Please pick a date';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    String expenseid = Uuid().v4();
                    if (_formKey.currentState!.validate()) {
                      final data = Expense(
                        id: expenseid,
                        amount: amount!,
                        category: _categoryController.text,
                        date: datePicked,
                      );
                      view_model.addExpense(data);

                      Utilis.showCompleteMessage(
                        'Expense Added Successfully',
                        Colors.green,
                        Icons.check,
                        context,
                      );

                      _amountController.clear();
                      _categoryController.clear();
                      _dateController.clear();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 135,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(child: Text('Add Expense')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
