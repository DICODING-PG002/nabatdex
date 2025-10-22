import 'package:flutter/material.dart';
import 'package:nabatdex/core/database/plant_database_helper.dart';
import 'package:nabatdex/core/model/disease_model.dart';
import 'package:nabatdex/core/model/journal_entry_model.dart';
import 'package:nabatdex/core/model/plant_model.dart';

class PlantDatabaseProvider with ChangeNotifier {
  final PlantDatabaseHelper _dbHelper = PlantDatabaseHelper.instance;

  JournalState _journalState = JournalInitial();
  JournalState get journalState => _journalState;

  PlantState _plantState = PlantInitial();
  PlantState get plantState => _plantState;

  DiseaseState _diseaseState = DiseaseInitial();
  DiseaseState get diseaseState => _diseaseState;

  List<JournalEntryModel> _journalEntries = [];
  List<JournalEntryModel> get journalEntries => _journalEntries;

  PlantModel? _currentPlant;
  PlantModel? get currentPlant => _currentPlant;

  DiseaseModel? _currentDisease;
  DiseaseModel? get currentDisease => _currentDisease;

  Future<void> loadAllJournalEntries() async {
    try {
      _journalState = JournalLoading();
      notifyListeners();

      final entries = await _dbHelper.getAllJournalEntries();
      
      _journalEntries = entries;
      _journalState = JournalLoaded(entries);
      notifyListeners();
    } catch (e) {
      _journalState = JournalError(e.toString());
      notifyListeners();
    }
  }

  Future<bool> saveJournalEntry(JournalEntryModel entry) async {
    try {
      _journalState = JournalLoading();
      notifyListeners();

      await _dbHelper.saveJournalEntry(entry);
      
      await loadAllJournalEntries();
      
      return true;
    } catch (e) {
      _journalState = JournalError(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteJournalEntry(int id) async {
    try {
      _journalState = JournalLoading();
      notifyListeners();

      await _dbHelper.deleteJournalEntry(id);
      
      await loadAllJournalEntries();
      
      return true;
    } catch (e) {
      _journalState = JournalError(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<void> loadPlantByName(String plantName) async {
    try {
      _plantState = PlantLoading();
      notifyListeners();

      final plant = await _dbHelper.getPlantByName(plantName);
      
      _currentPlant = plant;
      _plantState = plant != null 
          ? PlantLoaded(plant) 
          : PlantNotFound();
      notifyListeners();
    } catch (e) {
      _plantState = PlantError(e.toString());
      notifyListeners();
    }
  }

  Future<void> loadDiseaseByName(String diseaseName) async {
    try {
      _diseaseState = DiseaseLoading();
      notifyListeners();

      final disease = await _dbHelper.getDiseaseByName(diseaseName);
      
      _currentDisease = disease;
      _diseaseState = disease != null 
          ? DiseaseLoaded(disease) 
          : DiseaseNotFound();
      notifyListeners();
    } catch (e) {
      _diseaseState = DiseaseError(e.toString());
      notifyListeners();
    }
  }

  void clearPlantData() {
    _currentPlant = null;
    _plantState = PlantInitial();
    notifyListeners();
  }

  void clearDiseaseData() {
    _currentDisease = null;
    _diseaseState = DiseaseInitial();
    notifyListeners();
  }

  void clearAllData() {
    _journalEntries = [];
    _journalState = JournalInitial();
    _currentPlant = null;
    _plantState = PlantInitial();
    _currentDisease = null;
    _diseaseState = DiseaseInitial();
    notifyListeners();
  }
}

sealed class JournalState {}

class JournalInitial extends JournalState {}

class JournalLoading extends JournalState {}

class JournalLoaded extends JournalState {
  final List<JournalEntryModel> entries;
  JournalLoaded(this.entries);
}

class JournalError extends JournalState {
  final String message;
  JournalError(this.message);
}

sealed class PlantState {}

class PlantInitial extends PlantState {}

class PlantLoading extends PlantState {}

class PlantLoaded extends PlantState {
  final PlantModel plant;
  PlantLoaded(this.plant);
}

class PlantNotFound extends PlantState {}

class PlantError extends PlantState {
  final String message;
  PlantError(this.message);
}

sealed class DiseaseState {}

class DiseaseInitial extends DiseaseState {}

class DiseaseLoading extends DiseaseState {}

class DiseaseLoaded extends DiseaseState {
  final DiseaseModel disease;
  DiseaseLoaded(this.disease);
}

class DiseaseNotFound extends DiseaseState {}

class DiseaseError extends DiseaseState {
  final String message;
  DiseaseError(this.message);
}

