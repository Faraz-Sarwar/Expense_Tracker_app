import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/utilis/Routes/route_names.dart';
import 'package:expense_tracker/utilis/components/my_barchart.dart';
import 'package:expense_tracker/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), fetchUsername);
  }

  Future<void> fetchUsername() async {
    loading = true;
    final viewModel = context.read<ViewModel>();
    String fetchUserName = await viewModel.getUsername();
    setState(() {
      username = fetchUserName;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final view_model = Provider.of<ViewModel>(context);

    CollectionReference _collection = FirebaseFirestore.instance.collection(
      'Expense',
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 244, 244),
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
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
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
                const SizedBox(height: 30),
                const Text(
                  'Lets'
                  ' Track Your\nExpenses',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    height: 240,
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
                ),
                const SizedBox(height: 16),
                Container(
                  height: 85,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder(
                                stream: view_model.getTotalAmount(),
                                builder: (context, snapshot) {
                                  final amount = snapshot.data;
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    );
                                  } else {
                                    return Text(
                                      '\$$amount',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              ),
                              const Text('Total Expense'),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'This week',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Expenses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('View All')),
                  ],
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _collection.snapshots(),
                    builder: (context, snapshot) {
                      bool waiting =
                          snapshot.connectionState == ConnectionState.waiting;
                      bool hasData = snapshot.hasData;
                      if (waiting) {
                        return const Center(
                          child: const CircularProgressIndicator(),
                        );
                      } else if (!hasData || snapshot.data!.docs.isEmpty) {
                        return const Text(
                          'No expenses to fetch!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      final expenses = snapshot.data!.docs;
                      return ListView.builder(
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          final data =
                              expenses[index].data() as Map<String, dynamic>;
                          final Timestamp timestamp = data['date'];
                          final date = timestamp.toDate();
                          final formattedDate = DateFormat(
                            'MM/dd',
                          ).format(date);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: ListTile(
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    size: 35,
                                    Icons.attach_money_rounded,
                                    color: index % 2 == 1
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                  ),
                                ),
                                title: Text(
                                  data['category'].toString(),
                                  style: TextStyle(
                                    color: index % 2 == 1
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '\$${data['amount']}'.toString(),
                                  style: TextStyle(
                                    color: index % 2 == 1
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Text(
                                  formattedDate.toString(),
                                  style: TextStyle(
                                    color: index % 2 == 1
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
      ),
    );
  }
}
