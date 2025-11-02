import 'package:expense_tracker/utilis/Routes/route_names.dart';
import 'package:expense_tracker/utilis/components/my_barchart.dart';
import 'package:expense_tracker/view_model/auth_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    String fetchUserName = await viewModel.getUsername();
    setState(() {
      username = fetchUserName;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final view_model = Provider.of<ViewModel>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (loading)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text('welcome back'),
                      ],
                    ),
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 64),
              const Text(
                'Lets'
                ' Track Your\nExpenses',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MyBarchart(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.addExpense);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
