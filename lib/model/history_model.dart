import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final int slotNumber;
  final DateTime entryTime;
  final DateTime exitTime;
  final num amount;

 HistoryModel({
    required this.slotNumber,
    required this.entryTime,
    required this.exitTime,
    required this.amount,
  });

  factory HistoryModel.fromFirestore(Map<String, dynamic> data) {
    return HistoryModel(
      slotNumber: data['slotNumber'] as int,
      entryTime: (data['entryTime'] as Timestamp).toDate(),
      exitTime: (data['exitTime'] as Timestamp).toDate(),
      amount: (data['fees'] as num),
    );
  }
}
