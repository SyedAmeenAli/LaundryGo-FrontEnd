import 'package:flutter/material.dart';

import '../data/mock_driver_data.dart';
import '../models/driver_models.dart';

/// Owns the Driver product's real job state — accepting, picking up and
/// delivering a job genuinely mutates [DriverJob.stage] here.
class DriverController extends ChangeNotifier {
  final List<DriverJob> _jobs = MockDriverData.seedJobs();

  List<DriverJob> get jobs => List.unmodifiable(_jobs);
  List<DriverJob> get pending =>
      _jobs.where((j) => j.stage == DriverJobStage.pending).toList();
  List<DriverJob> get active => _jobs
      .where(
        (j) =>
            j.stage == DriverJobStage.accepted ||
            j.stage == DriverJobStage.pickedUp,
      )
      .toList();
  List<DriverJob> get history =>
      _jobs.where((j) => j.stage == DriverJobStage.delivered).toList();

  DriverJob jobById(String id) => _jobs.firstWhere((j) => j.id == id);

  void accept(String id) {
    jobById(id).stage = DriverJobStage.accepted;
    notifyListeners();
  }

  void decline(String id) {
    _jobs.removeWhere((j) => j.id == id);
    notifyListeners();
  }

  void confirmPickup(String id) {
    jobById(id).stage = DriverJobStage.pickedUp;
    notifyListeners();
  }

  void confirmDelivery(String id) {
    jobById(id).stage = DriverJobStage.delivered;
    notifyListeners();
  }
}
