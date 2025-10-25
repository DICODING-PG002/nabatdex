import 'package:flutter/material.dart';
import 'package:nabatdex/core/database/plant_database_helper.dart';
import 'package:nabatdex/core/model/plant_activity_model.dart';

class PlantActivityProvider with ChangeNotifier {
  final PlantDatabaseHelper _dbHelper = PlantDatabaseHelper.instance;

  ActivityState _state = ActivityInitial();
  ActivityState get state => _state;

  List<PlantActivityModel> _activities = [];
  List<PlantActivityModel> get activities => _activities;

  PlantActivityModel? _currentActivity;
  PlantActivityModel? get currentActivity => _currentActivity;

  Future<void> loadActivities(int journalEntryId) async {
    try {
      _state = ActivityLoading();
      notifyListeners();

      final activities = await _dbHelper.getActivitiesByJournalId(journalEntryId);
      
      _activities = activities;
      _state = ActivityLoaded(activities);
      notifyListeners();
    } catch (e) {
      _state = ActivityError(e.toString());
      notifyListeners();
    }
  }

  Future<bool> saveActivity(PlantActivityModel activity) async {
    try {
      _state = ActivitySaving();
      notifyListeners();

      await _dbHelper.saveActivity(activity);
      
      await loadActivities(activity.journalEntryId);
      
      _state = ActivitySaved();
      notifyListeners();
      
      return true;
    } catch (e) {
      _state = ActivityError(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteActivity(int activityId, int journalEntryId) async {
    try {
      _state = ActivityDeleting();
      notifyListeners();

      await _dbHelper.deleteActivity(activityId);
      
      await loadActivities(journalEntryId);
      
      _state = ActivityDeleted();
      notifyListeners();
      
      return true;
    } catch (e) {
      _state = ActivityError(e.toString());
      notifyListeners();
      return false;
    }
  }

  void setCurrentActivity(PlantActivityModel? activity) {
    _currentActivity = activity;
    notifyListeners();
  }

  void clearActivities() {
    _activities = [];
    _currentActivity = null;
    _state = ActivityInitial();
    notifyListeners();
  }
}

sealed class ActivityState {}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final List<PlantActivityModel> activities;
  ActivityLoaded(this.activities);
}

class ActivitySaving extends ActivityState {}

class ActivitySaved extends ActivityState {}

class ActivityDeleting extends ActivityState {}

class ActivityDeleted extends ActivityState {}

class ActivityError extends ActivityState {
  final String message;
  ActivityError(this.message);
}

