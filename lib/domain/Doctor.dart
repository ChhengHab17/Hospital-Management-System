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
  final int patientsPerDay;
  final double bonusPerPatient;

  Doctor({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required this.specialization,
    required this.patientsPerDay,
    required this.bonusPerPatient,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          dateOfBirth: dateOfBirth,
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
    DoctorSpecialization? specialization,
    int? patientsPerDay,
    double? bonusPerPatient,
  }) {
    return Doctor(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      specialization: specialization ?? this.specialization,
      patientsPerDay: patientsPerDay ?? this.patientsPerDay,
      bonusPerPatient: bonusPerPatient ?? this.bonusPerPatient,
    );
  }
}