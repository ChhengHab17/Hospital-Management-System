import 'Staff.dart';

class Nurse extends Staff {

  Nurse({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required Department department,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          dateOfBirth: dateOfBirth,
          department: department
        );

  @override
  String get role => 'Nurse';

  @override
  Nurse copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    Department? department,
  }) {
    return Nurse(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      department: department ?? this.department,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      ...super.toJson(),
    };
  }

  factory Nurse.fromJson(Map<String, Object?> json) {
    return Nurse(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      department: Department.values[json['department'] as int],
    );
  }
}