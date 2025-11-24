import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllExpenses extends StatefulWidget {
  const AllExpenses({super.key});

  @override
  State<AllExpenses> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllExpenses> {
  @override
  Widget build(BuildContext context) {
    CollectionReference _collection = FirebaseFirestore.instance.collection(
      'Expense',
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 32,
          bottom: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transactions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _collection.snapshots(),
              builder: (context, snapshot) {
                bool waiting =
                    snapshot.connectionState == ConnectionState.waiting;
                bool hasData = snapshot.hasData;
                if (waiting) {
                  return const Center(child: const CircularProgressIndicator());
                } else if (!hasData || snapshot.data!.docs.isEmpty) {
                  return const Text(
                    'No expenses to fetch!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  );
                }
                final expenses = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data =
                          expenses[index].data() as Map<String, dynamic>;
                      final Timestamp timestamp = data['date'];
                      final date = timestamp.toDate();
                      final formattedDate = DateFormat('MM/dd').format(date);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),

                          child: ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromARGB(255, 247, 246, 246),
                              ),
                              child: Icon(
                                size: 35,
                                Icons.attach_money_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            title: Text(
                              data['category'].toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              '-\$${data['amount']}'.toString(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,

                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Text(formattedDate.toString()),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
