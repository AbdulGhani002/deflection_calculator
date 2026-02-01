import 'package:flutter_test/flutter_test.dart';
import 'package:deflection_calculator/logic/calculator_engine.dart';

void main() {
  group('CalculatorEngine - Deflection Formulas', () {
    // Test parameters:
    // Force: 1000 N
    // Length: 1000 mm (1 meter)
    // E-Modulus: 70000 N/mm² (MPa) - Standard for Aluminum
    // Moment of Inertia: 100 cm⁴ = 1,000,000 mm⁴
    
    const double force = 1000.0; // N
    const double length = 1000.0; // mm
    const double eModulus = 70000.0; // N/mm² (MPa)
    const double iCm4 = 100.0; // cm⁴
    const double iMm4 = iCm4 * 10000; // = 1,000,000 mm⁴
    
    // Precomputed values:
    // L³ = 1,000,000,000 mm³
    // E*I = 70,000 * 1,000,000 = 70,000,000,000 N*mm²

    test('Simple Beam - Point Load: F*L³ / (48*E*I)', () {
      // Expected: 1000 * 1e9 / (48 * 70000 * 1e6)
      //         = 1e12 / (48 * 7e10)
      //         = 1e12 / 3.36e12
      //         = 0.297619... mm
      final expected = (force * 1e9) / (48 * eModulus * iMm4);
      
      final result = CalculatorEngine.calculateDeflection(
        force: force,
        lengthMm: length,
        eModulus: eModulus,
        momentOfInertiaMm4: iMm4,
        supportType: SupportType.simpleBeam,
        loadType: LoadType.pointLoad,
      );
      
      expect(result, closeTo(expected, 1e-10));
      expect(result, closeTo(0.2976190476, 1e-6));
    });

    test('Simple Beam - Distributed Load: 5*F*L³ / (384*E*I)', () {
      // Expected: 5 * 1000 * 1e9 / (384 * 70000 * 1e6)
      //         = 5e12 / (384 * 7e10)
      //         = 5e12 / 2.688e13
      //         = 0.186011... mm
      final expected = (5 * force * 1e9) / (384 * eModulus * iMm4);
      
      final result = CalculatorEngine.calculateDeflection(
        force: force,
        lengthMm: length,
        eModulus: eModulus,
        momentOfInertiaMm4: iMm4,
        supportType: SupportType.simpleBeam,
        loadType: LoadType.distributedLoad,
      );
      
      expect(result, closeTo(expected, 1e-10));
      expect(result, closeTo(0.1860119048, 1e-6));
    });

    test('Cantilever - Point Load: F*L³ / (3*E*I)', () {
      // Expected: 1000 * 1e9 / (3 * 70000 * 1e6)
      //         = 1e12 / (3 * 7e10)
      //         = 1e12 / 2.1e11
      //         = 4.761904... mm
      final expected = (force * 1e9) / (3 * eModulus * iMm4);
      
      final result = CalculatorEngine.calculateDeflection(
        force: force,
        lengthMm: length,
        eModulus: eModulus,
        momentOfInertiaMm4: iMm4,
        supportType: SupportType.cantilever,
        loadType: LoadType.pointLoad,
      );
      
      expect(result, closeTo(expected, 1e-10));
      expect(result, closeTo(4.7619047619, 1e-6));
    });

    test('Cantilever - Distributed Load: F*L³ / (8*E*I)', () {
      // Expected: 1000 * 1e9 / (8 * 70000 * 1e6)
      //         = 1e12 / (8 * 7e10)
      //         = 1e12 / 5.6e11
      //         = 1.785714... mm
      final expected = (force * 1e9) / (8 * eModulus * iMm4);
      
      final result = CalculatorEngine.calculateDeflection(
        force: force,
        lengthMm: length,
        eModulus: eModulus,
        momentOfInertiaMm4: iMm4,
        supportType: SupportType.cantilever,
        loadType: LoadType.distributedLoad,
      );
      
      expect(result, closeTo(expected, 1e-10));
      expect(result, closeTo(1.7857142857, 1e-6));
    });

    test('Fixed-Fixed - Point Load: F*L³ / (192*E*I)', () {
      // Expected: 1000 * 1e9 / (192 * 70000 * 1e6)
      //         = 1e12 / (192 * 7e10)
      //         = 1e12 / 1.344e13
      //         = 0.074404... mm
      final expected = (force * 1e9) / (192 * eModulus * iMm4);
      
      final result = CalculatorEngine.calculateDeflection(
        force: force,
        lengthMm: length,
        eModulus: eModulus,
        momentOfInertiaMm4: iMm4,
        supportType: SupportType.fixedFixed,
        loadType: LoadType.pointLoad,
      );
      
      expect(result, closeTo(expected, 1e-10));
      expect(result, closeTo(0.0744047619, 1e-6));
    });

    test('Fixed-Fixed - Distributed Load: F*L³ / (384*E*I)', () {
      // Expected: 1000 * 1e9 / (384 * 70000 * 1e6)
      //         = 1e12 / (384 * 7e10)
      //         = 1e12 / 2.688e13
      //         = 0.037202... mm
      final expected = (force * 1e9) / (384 * eModulus * iMm4);
      
      final result = CalculatorEngine.calculateDeflection(
        force: force,
        lengthMm: length,
        eModulus: eModulus,
        momentOfInertiaMm4: iMm4,
        supportType: SupportType.fixedFixed,
        loadType: LoadType.distributedLoad,
      );
      
      expect(result, closeTo(expected, 1e-10));
      expect(result, closeTo(0.0372023810, 1e-6));
    });
  });

  group('CalculatorEngine - Unit Conversion (cm⁴ to mm⁴)', () {
    test('calculateDeflectionFromCm4 correctly converts units', () {
      const double force = 500.0;
      const double length = 2000.0;
      const double eModulus = 70000.0;
      const double iCm4 = 50.0;
      
      // Calculate using cm⁴ method
      final resultFromCm4 = CalculatorEngine.calculateDeflectionFromCm4(
        force: force,
        lengthMm: length,
        eModulus: eModulus,
        momentOfInertiaCm4: iCm4,
        supportType: SupportType.simpleBeam,
        loadType: LoadType.pointLoad,
      );
      
      // Calculate manually with mm⁴
      final resultFromMm4 = CalculatorEngine.calculateDeflection(
        force: force,
        lengthMm: length,
        eModulus: eModulus,
        momentOfInertiaMm4: iCm4 * 10000,
        supportType: SupportType.simpleBeam,
        loadType: LoadType.pointLoad,
      );
      
      expect(resultFromCm4, equals(resultFromMm4));
    });

    test('1 cm⁴ equals 10,000 mm⁴', () {
      expect(CalculatorEngine.cm4ToMm4, equals(10000.0));
    });
  });

  group('CalculatorEngine - Input Validation', () {
    test('throws ArgumentError for negative force', () {
      expect(
        () => CalculatorEngine.calculateDeflection(
          force: -100,
          lengthMm: 1000,
          eModulus: 70000,
          momentOfInertiaMm4: 1000000,
          supportType: SupportType.simpleBeam,
          loadType: LoadType.pointLoad,
        ),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for zero or negative length', () {
      expect(
        () => CalculatorEngine.calculateDeflection(
          force: 100,
          lengthMm: 0,
          eModulus: 70000,
          momentOfInertiaMm4: 1000000,
          supportType: SupportType.simpleBeam,
          loadType: LoadType.pointLoad,
        ),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for zero or negative E-modulus', () {
      expect(
        () => CalculatorEngine.calculateDeflection(
          force: 100,
          lengthMm: 1000,
          eModulus: 0,
          momentOfInertiaMm4: 1000000,
          supportType: SupportType.simpleBeam,
          loadType: LoadType.pointLoad,
        ),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for zero or negative moment of inertia', () {
      expect(
        () => CalculatorEngine.calculateDeflection(
          force: 100,
          lengthMm: 1000,
          eModulus: 70000,
          momentOfInertiaMm4: 0,
          supportType: SupportType.simpleBeam,
          loadType: LoadType.pointLoad,
        ),
        throwsArgumentError,
      );
    });

    test('allows zero force (no deflection)', () {
      final result = CalculatorEngine.calculateDeflection(
        force: 0,
        lengthMm: 1000,
        eModulus: 70000,
        momentOfInertiaMm4: 1000000,
        supportType: SupportType.simpleBeam,
        loadType: LoadType.pointLoad,
      );
      
      expect(result, equals(0.0));
    });
  });

  group('CalculatorEngine - Real-World Scenarios', () {
    test('Profile 8 40x40 Light with 100N at 500mm (simple beam, point)', () {
      // Profile: Ix = 9.7 cm⁴ = 97,000 mm⁴
      // Force: 100 N
      // Length: 500 mm
      // E: 70,000 N/mm²
      // Formula: δ = F*L³ / (48*E*I)
      // δ = 100 * 500³ / (48 * 70000 * 97000)
      // δ = 100 * 125,000,000 / (325,920,000,000)
      // δ = 12,500,000,000 / 325,920,000,000
      // δ ≈ 0.0384 mm
      
      final result = CalculatorEngine.calculateDeflectionFromCm4(
        force: 100,
        lengthMm: 500,
        eModulus: 70000,
        momentOfInertiaCm4: 9.7,
        supportType: SupportType.simpleBeam,
        loadType: LoadType.pointLoad,
      );
      
      expect(result, closeTo(0.0384, 0.001));
    });

    test('Profile 8 80x40 Light with 500N at 1000mm (cantilever, distributed)', () {
      // Profile: Ix = 65.8 cm⁴ = 658,000 mm⁴
      // Total distributed load: 500 N
      // Length: 1000 mm
      // E: 70,000 N/mm²
      // Formula: δ = F*L³ / (8*E*I)
      // δ = 500 * 1000³ / (8 * 70000 * 658000)
      // δ = 500 * 1e9 / (368,480,000,000)
      // δ = 5e11 / 3.6848e11
      // δ ≈ 1.357 mm
      
      final result = CalculatorEngine.calculateDeflectionFromCm4(
        force: 500,
        lengthMm: 1000,
        eModulus: 70000,
        momentOfInertiaCm4: 65.8,
        supportType: SupportType.cantilever,
        loadType: LoadType.distributedLoad,
      );
      
      expect(result, closeTo(1.357, 0.01));
    });
  });
}
