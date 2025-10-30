import 'Staff.dart';

class Nurse extends Staff {

  Nurse({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required int age,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          age: age,
        );
}