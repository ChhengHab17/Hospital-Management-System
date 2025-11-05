import 'Staff.dart';

enum DoctorSpecialization {
  generalPhysician,
  cardiologist,
  pediatrician,
  surgeon,
  dermatologist,
}

class Doctor extends Staff {
  final DoctorSpecialization specialization;

  Doctor({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required Department department,
    required this.specialization,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          dateOfBirth: dateOfBirth,
          department: department,
        );

  @override
  String get role => 'Doctor';

  String get specializationName {
    switch (specialization) {
      case DoctorSpecialization.generalPhysician:
        return 'General Physician';
      case DoctorSpecialization.cardiologist:
        return 'Cardiologist';
      case DoctorSpecialization.pediatrician:
        return 'Pediatrician';
      case DoctorSpecialization.surgeon:
        return 'Surgeon';
      case DoctorSpecialization.dermatologist:
        return 'Dermatologist';
    }
  }

  @override
  Doctor copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    Department? department,
    DoctorSpecialization? specialization,
    int? patientsPerDay,
  }) {
    return Doctor(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      department: department ?? this.department,
      specialization: specialization ?? this.specialization,
    );
  }
  @override
  Map<String, Object?> toJson() {
    return {
      ...super.toJson(),
      'specialization': specialization.index,
    };
  }
  factory Doctor.fromJson(Map<String, Object?> json) {
    return Doctor(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      department: Department.values[json['department'] as int],
      specialization: DoctorSpecialization.values[json['specialization'] as int],
    );
  }
}