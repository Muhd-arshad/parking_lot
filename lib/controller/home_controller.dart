import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parkinglot/model/parkingSlot_model.dart';
import 'package:parkinglot/service/parking_service.dart';

class HomeController with ChangeNotifier {
  final ParkingService parkingService = ParkingService();
  List<ParkingSlot> _slots = [];
  bool isLoading = true;

  List<ParkingSlot> get slots => _slots;

  HomeController() {
    log('calling');
    initializeSlots();
  }

  Future<void> initializeSlots() async {
    isLoading = true;
    await parkingService.initializeSlots();
    fetchParkingSlots();
    isLoading = false;
    notifyListeners();
  }

  void fetchParkingSlots() {
    parkingService.fetchParkingSlots().listen((slotData) {
      _slots = slotData
          .map((data) => ParkingSlot.fromMap(data, data['slotNumber']))
          .toList();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> reserveSlot(int slotNumber, String userId) async {
    await parkingService.reserveSlot(slotNumber, userId);
  }

  Future<void> releaseSlot(int slotNumber) async {
    await parkingService.releaseSlot(slotNumber);
  }
}
