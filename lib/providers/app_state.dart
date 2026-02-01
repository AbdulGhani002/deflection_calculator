import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/profile_model.dart';
import '../logic/calculator_engine.dart';

/// Supported locales for the application.
enum AppLocale { en, de }

/// Application state manager using ChangeNotifier for Provider pattern.
/// 
/// Manages:
/// - Profile list loading and selection
/// - Calculator inputs (force, length, load type, support type)
/// - Deflection calculation results
/// - Localization settings
class AppState extends ChangeNotifier {
  // Profile data
  List<ProfileModel> _profiles = [];
  ProfileModel? _selectedProfile;
  bool _isLoading = true;
  String? _errorMessage;

  // Calculator inputs
  double _force = 100.0; // Newtons
  double _length = 1000.0; // mm
  LoadType _loadType = LoadType.pointLoad;
  SupportType _supportType = SupportType.simpleBeam;
  
  // Use X-axis (Ix) by default for deflection calculation
  bool _useXAxis = true;

  // Localization
  AppLocale _locale = AppLocale.en;

  // Getters
  List<ProfileModel> get profiles => _profiles;
  ProfileModel? get selectedProfile => _selectedProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get force => _force;
  double get length => _length;
  LoadType get loadType => _loadType;
  SupportType get supportType => _supportType;
  bool get useXAxis => _useXAxis;
  AppLocale get locale => _locale;

  /// Calculated deflection result in mm.
  double get deflectionResult {
    if (_selectedProfile == null) return 0.0;
    if (_force <= 0 || _length <= 0) return 0.0;

    try {
      final momentOfInertia = _useXAxis 
          ? _selectedProfile!.ixMm4 
          : _selectedProfile!.iyMm4;

      return CalculatorEngine.calculateDeflection(
        force: _force,
        lengthMm: _length,
        eModulus: _selectedProfile!.eModulus,
        momentOfInertiaMm4: momentOfInertia,
        supportType: _supportType,
        loadType: _loadType,
      );
    } catch (e) {
      return 0.0;
    }
  }

  /// Load profiles from the JSON asset file.
  Future<void> loadProfiles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final jsonString = await rootBundle.loadString('assets/data/profiles.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      _profiles = jsonList
          .map((json) => ProfileModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Select the first profile by default
      if (_profiles.isNotEmpty) {
        _selectedProfile = _profiles.first;
      }
      
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Failed to load profiles: $e';
      _isLoading = false;
    }
    
    notifyListeners();
  }

  /// Select a profile by its ID.
  void selectProfile(String id) {
    final profile = _profiles.firstWhere(
      (p) => p.id == id,
      orElse: () => _profiles.first,
    );
    _selectedProfile = profile;
    notifyListeners();
  }

  /// Select a profile directly.
  void selectProfileModel(ProfileModel profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  /// Update force value (in Newtons).
  void setForce(double value) {
    if (value >= 0) {
      _force = value;
      notifyListeners();
    }
  }

  /// Update length value (in mm).
  void setLength(double value) {
    if (value > 0) {
      _length = value;
      notifyListeners();
    }
  }

  /// Update load type (point or distributed).
  void setLoadType(LoadType type) {
    _loadType = type;
    notifyListeners();
  }

  /// Update support type (simple, cantilever, fixed-fixed).
  void setSupportType(SupportType type) {
    _supportType = type;
    notifyListeners();
  }

  /// Toggle between X-axis and Y-axis moment of inertia.
  void setUseXAxis(bool value) {
    _useXAxis = value;
    notifyListeners();
  }

  /// Change the application locale.
  void setLocale(AppLocale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  /// Toggle between English and German.
  void toggleLocale() {
    _locale = _locale == AppLocale.en ? AppLocale.de : AppLocale.en;
    notifyListeners();
  }
}
