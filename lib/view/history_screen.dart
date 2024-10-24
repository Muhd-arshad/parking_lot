import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkinglot/controller/history_controller.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryController>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking History'),
      ),
      body: FutureBuilder(
        future: historyProvider.fetchParkingHistory(user!.uid),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching history'));
          } else {
            return historyProvider.parkingHistory.isEmpty
                ? const Center(child: Text('No parking history available.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: historyProvider.parkingHistory.length,
                    itemBuilder: (ctx, index) {
                      final record = historyProvider.parkingHistory[index];
                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Slot: ${record.slotNumber}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Entry: ${historyProvider.timeFormat.format(record.entryTime)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Exit: ${historyProvider.timeFormat.format(record.exitTime)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Amount: \$${record.amount}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }
}
