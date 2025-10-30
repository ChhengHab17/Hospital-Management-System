import 'dart:ffi';

import 'Staff.dart';

class Doctor extends Staff {
  final String specialization;
  final int patientsPerDay;
  final Float bonusPerPatient;

  Doctor({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required int age,
    required this.specialization,
    required this.patientsPerDay,
    required this.bonusPerPatient,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          age: age,
        );
}