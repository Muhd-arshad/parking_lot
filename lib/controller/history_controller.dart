import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkinglot/model/history_model.dart';
import 'package:parkinglot/service/history_service.dart';

class HistoryController extends ChangeNotifier {
  HistoryService historyService = HistoryService();

  List<HistoryModel> _parkingHistory = [];
  final user = FirebaseAuth.instance.currentUser;
  List<HistoryModel> get parkingHistory => _parkingHistory;

  Future<void> fetchParkingHistory(String userId) async {
    _parkingHistory = await historyService.fetchParkingHistory(userId);
  }
  final DateFormat timeFormat = DateFormat('hh:mm a');
}
