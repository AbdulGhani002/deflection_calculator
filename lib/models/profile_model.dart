/// Model representing an aluminum profile with mechanical properties.
/// 
/// The profile contains moment of inertia values (Ix, Iy) in cm^4 and
/// the elastic modulus (E) in N/mm^2 (MPa).
class ProfileModel {
  final String id;
  final String name;
  final String category;
  final String imageAsset;
  final double ixCm4; // Moment of inertia about X-axis in cm^4
  final double iyCm4; // Moment of inertia about Y-axis in cm^4
  final double eModulus; // Elastic modulus in N/mm^2 (MPa)

  const ProfileModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageAsset,
    required this.ixCm4,
    required this.iyCm4,
    required this.eModulus,
  });

  /// Converts Ix from cm^4 to mm^4 (multiply by 10,000)
  double get ixMm4 => ixCm4 * 10000;

  /// Converts Iy from cm^4 to mm^4 (multiply by 10,000)
  double get iyMm4 => iyCm4 * 10000;

  /// Factory constructor to create ProfileModel from JSON map.
  /// Handles null-safety and provides defaults for missing values.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Profile',
      category: json['category'] as String? ?? 'Uncategorized',
      imageAsset: json['image_asset'] as String? ?? '',
      ixCm4: (json['ix_cm4'] as num?)?.toDouble() ?? 0.0,
      iyCm4: (json['iy_cm4'] as num?)?.toDouble() ?? 0.0,
      eModulus: (json['e_modulus'] as num?)?.toDouble() ?? 70000.0,
    );
  }

  /// Converts the ProfileModel to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image_asset': imageAsset,
      'ix_cm4': ixCm4,
      'iy_cm4': iyCm4,
      'e_modulus': eModulus,
    };
  }

  @override
  String toString() => 'ProfileModel(id: $id, name: $name, Ix: $ixCm4 cm⁴)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
