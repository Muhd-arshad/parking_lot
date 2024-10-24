import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkinglot/model/history_model.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<HistoryModel>> fetchParkingHistory(String userId) async {
    List<HistoryModel> parkingHistory = [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .get();

      parkingHistory = snapshot.docs.map(
        (doc) {
          return HistoryModel(
            slotNumber: doc['slotNumber'],
            entryTime: (doc['entryTime'] as Timestamp).toDate(),
            exitTime: (doc['exitTime'] as Timestamp).toDate(),
            amount: doc['fees'],
          );
        },
      ).toList();
      log('historylist===$parkingHistory');
    } on SocketException {
      log("No Internet Connection");
    } catch (e) {
      print("Error fetching parking history: $e");
    }

    return parkingHistory;
  }
}
