import 'dart:math' as math;

/// Enum representing the type of beam support configuration.
enum SupportType {
  simpleBeam,   // Simply supported beam (pin-roller)
  cantilever,   // Fixed at one end, free at the other
  fixedFixed,   // Fixed at both ends
}

/// Enum representing the type of load applied to the beam.
enum LoadType {
  pointLoad,       // Concentrated load at center
  distributedLoad, // Uniformly distributed load along the beam
}

/// Calculator engine for computing beam deflections.
/// 
/// All formulas assume:
/// - Force (F) in Newtons (N)
/// - Length (L) in millimeters (mm)
/// - Elastic Modulus (E) in N/mm² (MPa)
/// - Moment of Inertia (I) in mm⁴
/// - Result: Deflection in millimeters (mm)
/// 
/// IMPORTANT: When using moment of inertia values from profiles (cm⁴),
/// convert to mm⁴ first: 1 cm⁴ = 10,000 mm⁴
class CalculatorEngine {
  /// Conversion factor from cm⁴ to mm⁴
  static const double cm4ToMm4 = 10000.0;

  /// Calculates maximum beam deflection based on support type and load type.
  /// 
  /// Parameters:
  /// - [force]: Applied force in Newtons (N). For distributed load, this is 
  ///            the total load (w * L where w is load per unit length).
  /// - [lengthMm]: Beam length in millimeters (mm).
  /// - [eModulus]: Elastic modulus in N/mm² (MPa). Typically 70,000 for aluminum.
  /// - [momentOfInertiaMm4]: Moment of inertia in mm⁴.
  /// - [supportType]: Type of beam support (simple, cantilever, fixed-fixed).
  /// - [loadType]: Type of load (point or distributed).
  /// 
  /// Returns the maximum deflection in millimeters (mm).
  static double calculateDeflection({
    required double force,
    required double lengthMm,
    required double eModulus,
    required double momentOfInertiaMm4,
    required SupportType supportType,
    required LoadType loadType,
  }) {
    // Validate inputs
    if (force < 0) {
      throw ArgumentError('Force must be non-negative');
    }
    if (lengthMm <= 0) {
      throw ArgumentError('Length must be positive');
    }
    if (eModulus <= 0) {
      throw ArgumentError('Elastic modulus must be positive');
    }
    if (momentOfInertiaMm4 <= 0) {
      throw ArgumentError('Moment of inertia must be positive');
    }

    final double l3 = math.pow(lengthMm, 3).toDouble();
    final double ei = eModulus * momentOfInertiaMm4;

    switch (supportType) {
      case SupportType.simpleBeam:
        return loadType == LoadType.pointLoad
            ? _simpleBeamPointLoad(force, l3, ei)
            : _simpleBeamDistributedLoad(force, l3, ei);
      
      case SupportType.cantilever:
        return loadType == LoadType.pointLoad
            ? _cantileverPointLoad(force, l3, ei)
            : _cantileverDistributedLoad(force, l3, ei);
      
      case SupportType.fixedFixed:
        return loadType == LoadType.pointLoad
            ? _fixedFixedPointLoad(force, l3, ei)
            : _fixedFixedDistributedLoad(force, l3, ei);
    }
  }

  /// Simple Beam with Point Load at Center
  /// Formula: δ = F*L³ / (48*E*I)
  static double _simpleBeamPointLoad(double f, double l3, double ei) {
    return (f * l3) / (48 * ei);
  }

  /// Simple Beam with Uniformly Distributed Load
  /// Formula: δ = 5*F*L³ / (384*E*I)
  /// Where F is the total distributed load (w * L)
  static double _simpleBeamDistributedLoad(double f, double l3, double ei) {
    return (5 * f * l3) / (384 * ei);
  }

  /// Cantilever Beam with Point Load at Free End
  /// Formula: δ = F*L³ / (3*E*I)
  static double _cantileverPointLoad(double f, double l3, double ei) {
    return (f * l3) / (3 * ei);
  }

  /// Cantilever Beam with Uniformly Distributed Load
  /// Formula: δ = F*L³ / (8*E*I)
  /// Where F is the total distributed load (w * L)
  static double _cantileverDistributedLoad(double f, double l3, double ei) {
    return (f * l3) / (8 * ei);
  }

  /// Fixed-Fixed Beam with Point Load at Center
  /// Formula: δ = F*L³ / (192*E*I)
  static double _fixedFixedPointLoad(double f, double l3, double ei) {
    return (f * l3) / (192 * ei);
  }

  /// Fixed-Fixed Beam with Uniformly Distributed Load
  /// Formula: δ = F*L³ / (384*E*I)
  /// Where F is the total distributed load (w * L)
  static double _fixedFixedDistributedLoad(double f, double l3, double ei) {
    return (f * l3) / (384 * ei);
  }

  /// Convenience method using moment of inertia in cm⁴ (auto-converts to mm⁴).
  static double calculateDeflectionFromCm4({
    required double force,
    required double lengthMm,
    required double eModulus,
    required double momentOfInertiaCm4,
    required SupportType supportType,
    required LoadType loadType,
  }) {
    return calculateDeflection(
      force: force,
      lengthMm: lengthMm,
      eModulus: eModulus,
      momentOfInertiaMm4: momentOfInertiaCm4 * cm4ToMm4,
      supportType: supportType,
      loadType: loadType,
    );
  }
}
