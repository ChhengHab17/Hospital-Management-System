import 'Doctor.dart';
import 'Nurse.dart';
import 'Shift.dart';
import 'Staff.dart';

enum Role { Doctor, Nurse }

class Admin extends Staff {
  final String password;
  final Role role;

  List<Staff> staffs = [];

  List<Shift> shifts = [];
  Map<Shift, Staff> shiftAssignments = {};

  Admin({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required this.password,
    required this.role,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          dateOfBirth: dateOfBirth,
        );

  int get age => DateTime.now().year - dateOfBirth.year;

  void createAccount(
    String id, 
    String firstName, 
    String lastName, 
    String email, 
    String phoneNumber, 
    DateTime dateOfBirth, 
    String password, 
    Role role) {

    if(role == Role.Doctor) {
      staffs.add(
        Doctor(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          dateOfBirth: dateOfBirth,
          specialization: '',
          patientsPerDay: 0,
          bonusPerPatient: 0.0,
        )
      );
    } else if(role == Role.Nurse) {
      staffs.add(
        Nurse(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          dateOfBirth: dateOfBirth,
        )
      );
    }
  }

  void displayAllStaff(List<Staff> staffList) {
    for (var staff in staffList) {
      print("${staff.id} - ${staff.role} ${staff.firstName} ${staff.lastName} - ${staff.dateOfBirth} - ${staff.email} - ${staff.phoneNumber}");
    }
  }

  void displayAllDoctors(List<Staff> staffList) {
    for (var staff in staffList) {
      if (staff is Doctor) {
        print("${staff.firstName} ${staff.lastName} - ${staff.specialization}");
      }
    }
  }

  void displayAllNurses(List<Staff> staffList) {
    for (var staff in staffList) {
      if (staff is Nurse) {
        print("${staff.firstName} ${staff.lastName} - Nurse");
      }
    }
  }

  Admin updateProfile(String newFirstName, String newLastName, DateTime newDateOfBirth) {
    return Admin(
      id: id,
      firstName: newFirstName, 
      lastName: newLastName,
      email: email,
      phoneNumber: phoneNumber,
      dateOfBirth: newDateOfBirth,
      password: password,
      role: role
    );
  }

  Admin updateContactInfo(String newEmail, String newPhoneNumber) {
    if (!newEmail.contains('@')) {
      throw ArgumentError('Invalid email format');
    }

    return Admin(
      id: id, 
      firstName: firstName, 
      lastName: lastName,
      email: newEmail,
      phoneNumber: newPhoneNumber,
      dateOfBirth: dateOfBirth,
      password: password,
      role: role
    );
  }

  Admin changePassword(String newPassword) {
    if (newPassword.length < 8) {
      throw ArgumentError('Password must be at least 8 characters long');
    }

    return Admin(
      id: id, 
      firstName: firstName, 
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      password: newPassword,
      role: role
    );
  }

  void deleteAccount() {
    staffs.removeWhere((staff) => staff.id == id);
  }

  void addShift(Shift shift) {
    shifts.add(shift);
  }

  void removeShift(Shift shift) {
    shifts.remove(shift);
  }

  List<Shift> getShifts() {
    return shifts;
  }
  void assignStaffToShift(Shift shift, Staff staff) {
    shiftAssignments[shift] = staff;
  }
  
}