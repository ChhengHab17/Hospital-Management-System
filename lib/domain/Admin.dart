import 'Doctor.dart';
import 'Nurse.dart';
import 'Shift.dart';
import 'Staff.dart';
import '../data/ShiftRepository.dart';

enum Role { Doctor, Nurse }

class Admin extends Staff {
  final String password;
  final Role role;
  final ShiftRepository shiftRepository = ShiftRepository(filePath: 'data.json');

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
        ) {
    // Load shifts from file when Admin is created
    loadShiftsFromFile();
  }

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
      role: role,
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
      role: role,
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
      role: role,
    );
  }

  void deleteAccount() {
    staffs.removeWhere((staff) => staff.id == id);
  }

  // Load shifts from JSON file
  void loadShiftsFromFile() {
    try {
      shifts = shiftRepository.readShifts();
      print('Loaded ${shifts.length} shifts from file');
    } catch (e) {
      print('Could not load shifts: $e');
      shifts = [];
    }
  }

  // Save shifts to JSON file
  void saveShiftsToFile() {
    try {
      shiftRepository.writeShifts(shifts);
      print('Saved ${shifts.length} shifts to file');
    } catch (e) {
      print('Error saving shifts: $e');
    }
  }

  void addShift(Shift shift) {
    // Check if shift ID already exists
    if (shifts.any((s) => s.shiftId == shift.shiftId)) {
      print('Shift with ID ${shift.shiftId} already exists!');
      return;
    }
    
    shifts.add(shift);
    saveShiftsToFile();
    print('Shift added successfully!');
  }

  void removeShift(int shiftId) {
    final initialLength = shifts.length;
    shifts.removeWhere((shift) => shift.shiftId == shiftId);
    
    if (shifts.length < initialLength) {
      saveShiftsToFile();
      print('Shift removed successfully!');
    } else {
      print('Shift with ID $shiftId not found!');
    }
  }

  void updateShift(Shift updatedShift) {
    final index = shifts.indexWhere((s) => s.shiftId == updatedShift.shiftId);
    
    if (index != -1) {
      shifts[index] = updatedShift;
      saveShiftsToFile();
      print('Shift updated successfully!');
    } else {
      print('Shift with ID ${updatedShift.shiftId} not found!');
    }
  }

  Shift? findShiftById(int shiftId) {
    try {
      return shifts.firstWhere((s) => s.shiftId == shiftId);
    } catch (e) {
      return null;
    }
  }

  void viewAllShifts() {
    if (shifts.isEmpty) {
      print('No shifts available.');
      return;
    }
    
    print('\n All Shifts:');
    for (var shift in shifts) {
      print('Shift ${shift.shiftId}: ${shift.startTime} to ${shift.endTime} (\$${shift.shiftAllowance})');
    }
  }

  List<Shift> getShifts() {
    return shifts;
  }
  void assignStaffToShift(int shiftId, String staffId) {
    Shift? shift = shifts.firstWhere((s) => s.shiftId == shiftId);
    Staff? staff = staffs.firstWhere((s) => s.id == staffId);
    shiftAssignments[shift] = staff;
  }
  void viewStaffAssignments() {
    shiftAssignments.forEach((shift, staff) {
      print('Shift ID: ${shift.shiftId} assigned to Staff ID: ${staff.id}');
    });
  }
  
}