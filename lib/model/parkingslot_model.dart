import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSlot {
  final int slotNumber;
  final bool isAvailable;
  final String? reservedBy;
  final DateTime? entryTime;

  ParkingSlot({
    required this.slotNumber,
    required this.isAvailable,
    this.reservedBy,
    this.entryTime,
  });

  factory ParkingSlot.fromMap(Map<String, dynamic> data, int slotNumber) {
    return ParkingSlot(
      slotNumber: slotNumber,
      isAvailable: data['isAvailable'] ?? true,
      reservedBy: data['reservedBy'],
      entryTime: data['entryTime'] != null
          ? (data['entryTime'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isAvailable': isAvailable,
      'reservedBy': reservedBy,
      'entryTime': entryTime != null ? Timestamp.fromDate(entryTime!) : null,
    };
  }
}
