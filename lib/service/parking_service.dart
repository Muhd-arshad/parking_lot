import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> initializeSlots() async {
    final collection = firestore.collection('parkingSlots');
    final snapshot = await collection.get();

    if (snapshot.docs.isEmpty) {
      for (int i = 1; i <= 50; i++) {
        await collection.doc('slot_$i').set({
          'isAvailable': true,
          'reservedBy': null,
          'entryTime': null,
        });
      }
    }
  }

  Stream<List<Map<String, dynamic>>> fetchParkingSlots() {
    return firestore.collection('parkingSlots').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                ...doc.data(),
                'slotNumber': int.parse(doc.id.split('_').last),
              })
          .toList();
    });
  }

  Future<void> reserveSlot(int slotNumber, String userId) async {
    await firestore.collection('parkingSlots').doc('slot_$slotNumber').update({
      'isAvailable': false,
      'reservedBy': userId,
      'entryTime': Timestamp.now(),
    });
  }

  Future<void> releaseSlot(int slotNumber) async {
    var doc = await firestore
        .collection('parkingSlots')
        .doc('slot_$slotNumber')
        .get();
    Timestamp entryTime = doc['entryTime'];
    Timestamp exitTime = Timestamp.now();

    int minutesSpent =
        exitTime.toDate().difference(entryTime.toDate()).inMinutes;
    double fees =
        (minutesSpent > 10) ? ((minutesSpent - 10) / 60).ceil() * 100 : 0;

    await firestore.collection('parkingSlots').doc('slot_$slotNumber').update({
      'isAvailable': true,
      'reservedBy': null,
      'entryTime': null,
    });

    await firestore
        .collection('users')
        .doc(doc['reservedBy'])
        .collection('history')
        .add({
      'slotNumber': slotNumber,
      'entryTime': entryTime,
      'exitTime': exitTime,
      'fees': fees,
    });
  }
}
