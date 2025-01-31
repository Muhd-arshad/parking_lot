import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkinglot/constants/flushbar.dart';
import 'package:parkinglot/controller/home_controller.dart';
import 'package:parkinglot/view/auth_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeController>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Parking Lot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => const AuthScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: homeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5),
              itemCount: homeProvider.slots.length,
              itemBuilder: (ctx, index) {
                final slot = homeProvider.slots[index];
                return GestureDetector(
                  onTap: () async {
                    if (slot.isAvailable) {
                      homeProvider.reserveSlot(slot.slotNumber, user!.uid);
                    } else {
                      if (slot.reservedBy == user!.uid) {
                        double amount = homeProvider.calculateParkingFee(
                            slot.slotNumber, slot.entryTime);
                        await showCancellationDialog(
                          context,
                          amount,
                          slot.entryTime,
                          homeProvider.exitTime,
                          homeProvider,
                        );
                        homeProvider.releaseSlot(slot.slotNumber);
                      } else {
                        showFlushbar(context, 'Already booked');
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: slot.isAvailable ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Slot ${slot.slotNumber}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> showCancellationDialog(BuildContext context, double amount,
      DateTime? entryTime, DateTime? exitTime, HomeController homeProvider) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Parking Fee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Entry Time: ${homeProvider.timeFormat.format(entryTime!)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Exit Time: ${homeProvider.timeFormat.format(exitTime!)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Amount: \$${amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
