import '../providers/app_state.dart';

/// Localization strings for the Deflection Calculator app.
/// Supports English and German.
class AppLocalizations {
  final AppLocale locale;

  AppLocalizations(this.locale);

  /// Get localized string by key.
  String get(String key) {
    return _localizedStrings[locale]?[key] ?? _localizedStrings[AppLocale.en]?[key] ?? key;
  }

  static const Map<AppLocale, Map<String, String>> _localizedStrings = {
    AppLocale.en: {
      // App
      'app_title': 'Deflection Calculator',
      'app_subtitle': 'Aluminum Profile Calculator',
      
      // Load Types
      'load_type': 'Load Type',
      'point_load': 'Point Load',
      'distributed_load': 'Distributed Load',
      
      // Support Types
      'support_type': 'Support Type',
      'simple_beam': 'Simple Beam',
      'cantilever': 'Cantilever',
      'fixed_fixed': 'Fixed-Fixed',
      'simple_beam_desc': 'Pin-Roller Support',
      'cantilever_desc': 'Fixed-Free End',
      'fixed_fixed_desc': 'Fixed Both Ends',
      
      // Inputs
      'force': 'Force',
      'force_unit': 'N',
      'length': 'Length',
      'length_unit': 'mm',
      'enter_force': 'Enter force in Newtons',
      'enter_length': 'Enter length in mm',
      
      // Profile
      'profile': 'Profile',
      'select_profile': 'Select Profile',
      'no_profile': 'No profile selected',
      'moment_of_inertia': 'Moment of Inertia',
      'axis': 'Axis',
      'x_axis': 'X-Axis (Ix)',
      'y_axis': 'Y-Axis (Iy)',
      
      // Results
      'deflection': 'Deflection',
      'result': 'Result',
      'maximum_deflection': 'Maximum Deflection',
      
      // Actions
      'calculate': 'Calculate',
      'reset': 'Reset',
      'close': 'Close',
      
      // Settings
      'settings': 'Settings',
      'language': 'Language',
      'english': 'English',
      'german': 'German',
      
      // Errors
      'error': 'Error',
      'invalid_input': 'Invalid input',
      'loading': 'Loading...',
    },
    
    AppLocale.de: {
      // App
      'app_title': 'Durchbiegungsrechner',
      'app_subtitle': 'Aluminiumprofil-Rechner',
      
      // Load Types
      'load_type': 'Lasttyp',
      'point_load': 'Punktlast',
      'distributed_load': 'Streckenlast',
      
      // Support Types
      'support_type': 'Lagerungsart',
      'simple_beam': 'Einfacher Balken',
      'cantilever': 'Kragarm',
      'fixed_fixed': 'Beidseitig Eingespannt',
      'simple_beam_desc': 'Gelenkig gelagert',
      'cantilever_desc': 'Fest-Frei',
      'fixed_fixed_desc': 'Beidseitig fest',
      
      // Inputs
      'force': 'Kraft',
      'force_unit': 'N',
      'length': 'Länge',
      'length_unit': 'mm',
      'enter_force': 'Kraft in Newton eingeben',
      'enter_length': 'Länge in mm eingeben',
      
      // Profile
      'profile': 'Profil',
      'select_profile': 'Profil auswählen',
      'no_profile': 'Kein Profil ausgewählt',
      'moment_of_inertia': 'Flächenträgheitsmoment',
      'axis': 'Achse',
      'x_axis': 'X-Achse (Ix)',
      'y_axis': 'Y-Achse (Iy)',
      
      // Results
      'deflection': 'Durchbiegung',
      'result': 'Ergebnis',
      'maximum_deflection': 'Maximale Durchbiegung',
      
      // Actions
      'calculate': 'Berechnen',
      'reset': 'Zurücksetzen',
      'close': 'Schließen',
      
      // Settings
      'settings': 'Einstellungen',
      'language': 'Sprache',
      'english': 'Englisch',
      'german': 'Deutsch',
      
      // Errors
      'error': 'Fehler',
      'invalid_input': 'Ungültige Eingabe',
      'loading': 'Laden...',
    },
  };
}

/// Extension for easy access to localized strings from BuildContext.
extension LocalizationExtension on AppLocale {
  AppLocalizations get strings => AppLocalizations(this);
}
