import 'dart:io';
import '../domain/Staff.dart';
import '../domain/Admin.dart';
import '../domain/Doctor.dart';
import 'shiftConsole.dart';

class AdminConsole {
  final Admin admin;

  AdminConsole(this.admin);

  void run() {
    while (true) {
      _displayAdminMenu();
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          _viewAllStaff();
          _pressEnterToContinue();
          break;
        case '2':
          _addNewStaff();
          _pressEnterToContinue();
          break;
        case '3':
          _removeStaff();
          _pressEnterToContinue();
          break;
        case '4':
          _updateStaffInformation();
          break;
        case '5':
          _runShiftManagement();
          break;
        case '6':
          _updatePatientsSeen();
          _pressEnterToContinue();
          break;
        case '7':
          _viewStaffMonthlySalary();
          _pressEnterToContinue();
          break;
        case '8':
          _viewAllMonthlySalaries();
          _pressEnterToContinue();
          break;
        case '0':
          print('\nExiting Admin Console. Goodbye!');
          return;
        default:
          print('\nInvalid choice. Please try again.');
          _pressEnterToContinue();
      }
    }
  }

  void _pressEnterToContinue() {
    print('\nPress Enter to continue...');
    stdin.readLineSync();
  }

  void _displayAdminMenu() {
    print('\n' + '=' * 60);
    print('HOSPITAL ADMINISTRATOR CONSOLE'.padLeft(40));
    print('=' * 60);
    print('1. View all staff');
    print('2. Add new staff');
    print('3. Remove staff');
    print('4. Update staff information');
    print('5. Shift Management');
    print('6. Update Patients Seen (Doctors)');
    print('7. View Staff Monthly Salary');
    print('8. View All Staff Monthly Salaries');
    print('0. Exit');
    print('=' * 60);
    print('Enter your choice (0-8): ');
  }

  void _runShiftManagement() {
    ShiftConsole shiftConsole = ShiftConsole(admin);
    shiftConsole.run();
  }

  void _viewAllStaff() {
    print('\n' + '=' * 140);
    print('ALL STAFF MEMBERS'.padLeft(75));
    print('=' * 140);

    List<Staff> staffs = admin.getStaff();
    if (staffs.isEmpty) {
      print('No staff members found.');
      print('=' * 140);
      return;
    }

    // Table header
    print(
        '${'ID'.padRight(10)} | ${'Name'.padRight(25)} | ${'Role'.padRight(8)} | ${'Specialization'.padRight(20)} | ${'Date of Birth'.padRight(12)} | ${'Email'.padRight(25)} | ${'Phone'.padRight(10)} | ${'Shift'.padRight(10)}');
    print('-' * 140);

    // Table rows
    for (var staff in staffs) {
      String id = staff.id.padRight(10);
      String name = '${staff.firstName} ${staff.lastName}'.padRight(25);
      String role = staff.role.toString().padRight(8);
      String specialization = staff is Doctor
          ? staff.specializationName.padRight(20)
          : 'N/A'.padRight(20);
      String dob = staff.dateOfBirth.toString().split(' ')[0].padRight(12);
      String email = staff.email.padRight(25);
      String phone = staff.phoneNumber.padRight(10);
      int shift = admin.getTotalShiftForStaff(staff.id);
      String shiftStr = shift.toString().padRight(11);

      print(
          '$id | $name | $role | $specialization | $dob | $email | $phone | $shiftStr');
    }

    print('=' * 140);
    print('Total Staff Members: ${staffs.length}');
    print('=' * 140);
  }

  void _addNewStaff() {
    try {
      print('\n' + '=' * 60);
      print('ADD NEW STAFF MEMBER'.padLeft(40));
      print('=' * 60);

      stdout.write('Enter First Name: ');
      String firstName = stdin.readLineSync() ?? '';

      stdout.write('Enter Last Name: ');
      String lastName = stdin.readLineSync() ?? '';

      String email = '';
      while (true) {
        stdout.write('Enter Email: ');
        email = stdin.readLineSync() ?? '';
        if (email.contains('@')) {
          break;
        }
        print('Invalid email format. Please try again.');
      }

      stdout.write('Enter Phone Number: ');
      String phoneNumber = stdin.readLineSync() ?? '';

      DateTime dateOfBirth;
      while (true) {
        stdout.write('Enter Date of Birth (YYYY-MM-DD): ');
        String dobInput = stdin.readLineSync() ?? '';
        try {
          dateOfBirth = DateTime.parse(dobInput);
          break;
        } catch (e) {
          print('Invalid date format. Please try again.');
        }
      }

      stdout.write('Enter Role (Doctor/Nurse): ');
      String roleInput = stdin.readLineSync() ?? '';
      Role role = roleInput.toLowerCase() == 'doctor' ? Role.Doctor : Role.Nurse;

      Department department = _selectDepartment();

      if (role == Role.Doctor) {
        DoctorSpecialization specialization = _selectSpecialization();
        admin.createDoctorAccount(
            firstName, lastName, email, phoneNumber, specialization, dateOfBirth, department);
      } else {
        admin.createNurseAccount(
            firstName, lastName, email, phoneNumber, dateOfBirth, department);
      }

      print('\nStaff member $firstName $lastName added successfully.');
      print('=' * 60);
    } catch (e) {
      print('\nError: Failed to add staff member. Please check your input and try again.');
      print('=' * 60);
    }
  }

  Department _selectDepartment() {
    print('\n' + '=' * 60);
    print('SELECT DEPARTMENT'.padLeft(40));
    print('=' * 60);
    print('1. General');
    print('2. Cardiology');
    print('3. Neurology');
    print('4. Pediatrics');
    print('5. General Medicine');
    print('6. Emergency');
    print('=' * 60);

    Map<String, Department> departments = {
      '1': Department.General,
      '2': Department.Cardiology,
      '3': Department.Neurology,
      '4': Department.Pediatrics,
      '5': Department.GeneralMedicine,
      '6': Department.Emergency,
    };

    while (true) {
      stdout.write('Enter your choice (1-6): ');
      String? choice = stdin.readLineSync();

      if (departments.containsKey(choice)) {
        return departments[choice]!;
      } else {
        print('Invalid choice! Please select a number between 1 and 6.');
      }
    }
  }

  DoctorSpecialization _selectSpecialization() {
    print('\n' + '=' * 60);
    print('SELECT SPECIALIZATION'.padLeft(40));
    print('=' * 60);
    print('1. General Physician');
    print('2. Cardiologist');
    print('3. Pediatrician');
    print('4. Surgeon');
    print('5. Dermatologist');
    print('=' * 60);

    Map<String, DoctorSpecialization> specializations = {
      '1': DoctorSpecialization.generalPhysician,
      '2': DoctorSpecialization.cardiologist,
      '3': DoctorSpecialization.pediatrician,
      '4': DoctorSpecialization.surgeon,
      '5': DoctorSpecialization.dermatologist,
    };

    while (true) {
      stdout.write('Enter your choice (1-5): ');
      String? choice = stdin.readLineSync();

      if (specializations.containsKey(choice)) {
        return specializations[choice]!;
      } else {
        print('Invalid choice! Please select a number between 1 and 5.');
      }
    }
  }

  void _removeStaff() {
    try {
      print('\n' + '=' * 60);
      print('REMOVE STAFF MEMBER'.padLeft(40));
      print('=' * 60);

      stdout.write('Enter Staff ID to remove: ');
      String id = stdin.readLineSync() ?? '';

      bool success = admin.deleteAccount(id);
      if (!success) {
        print('Failed to remove staff member with ID $id.');
      }
      print('=' * 60);
    } catch (e) {
      print('\nError: Failed to remove staff member. Please check the ID and try again.');
      print('=' * 60);
    }
  }

  void _updateStaffInformation() {
    try {
      print('\n' + '=' * 60);
      print('UPDATE STAFF INFORMATION'.padLeft(40));
      print('=' * 60);

      stdout.write('Enter Staff ID to update: ');
      String id = stdin.readLineSync() ?? '';

      List<Staff> staffs = admin.getStaff();
      int staffIndex = -1;
      Staff? staffToUpdate;

      for (int i = 0; i < staffs.length; i++) {
        if (staffs[i].id == id) {
          staffToUpdate = staffs[i];
          staffIndex = i;
          break;
        }
      }

      if (staffToUpdate == null) {
        print('No staff member found with ID $id.');
        return;
      }

      while (true) {
        print('\n' + '=' * 60);
        print(
            'UPDATE OPTIONS FOR ${staffToUpdate?.firstName} ${staffToUpdate?.lastName}'
                .padLeft(40));
        print('=' * 60);
        print('1. Update Profile (Name & Date of Birth)');
        print('2. Update Contact Information (Email & Phone)');
        print('0. Back to Main Menu');
        print('=' * 60);
        stdout.write('Enter your choice (0-2): ');

        String? choice = stdin.readLineSync();

        switch (choice) {
          case '1':
            staffToUpdate = _updateProfile(staffToUpdate!, staffIndex);
            break;
          case '2':
            staffToUpdate = _updateContactInfo(staffToUpdate!, staffIndex);
            break;
          case '0':
            return;
          default:
            print('Invalid choice. Please try again.');
        }
      }
    } catch (e) {
      print('\nError: Failed to update staff information. Please check your input and try again.');
      print('=' * 60);
    }
  }

  Staff _updateProfile(Staff staff, int index) {
    print('\n' + '=' * 60);
    print('UPDATE PROFILE'.padLeft(40));
    print('=' * 60);

    stdout.write(
        'Enter new First Name (current: ${staff.firstName}, press Enter to keep): ');
    String? firstNameInput = stdin.readLineSync();
    String firstName = (firstNameInput?.isNotEmpty ?? false)
        ? firstNameInput!
        : staff.firstName;

    stdout.write(
        'Enter new Last Name (current: ${staff.lastName}, press Enter to keep): ');
    String? lastNameInput = stdin.readLineSync();
    String lastName =
        (lastNameInput?.isNotEmpty ?? false) ? lastNameInput! : staff.lastName;

    stdout.write(
        'Enter new Date of Birth - YYYY-MM-DD (current: ${staff.dateOfBirth.toString().split(' ')[0]}, press Enter to keep): ');
    String? dobInput = stdin.readLineSync();
    DateTime dateOfBirth = staff.dateOfBirth;

    if (dobInput?.isNotEmpty ?? false) {
      try {
        dateOfBirth = DateTime.parse(dobInput!);
      } catch (e) {
        print('Invalid date format. Keeping current date.');
      }
    }

    Staff updatedStaff =
        admin.updateProfile(staff.id, firstName, lastName, dateOfBirth);

    print('\nProfile updated successfully for $firstName $lastName.');
    print('=' * 60);
    return updatedStaff;
  }

  Staff _updateContactInfo(Staff staff, int index) {
    print('\n' + '=' * 60);
    print('UPDATE CONTACT INFORMATION'.padLeft(40));
    print('=' * 60);

    stdout.write(
        'Enter new Email (current: ${staff.email}, press Enter to keep): ');
    String? emailInput = stdin.readLineSync();
    String email =
        (emailInput?.isNotEmpty ?? false) ? emailInput! : staff.email;

    if (email != staff.email && !email.contains('@')) {
      print('Invalid email format. Keeping current email.');
      email = staff.email;
    }

    stdout.write(
        'Enter new Phone Number (current: ${staff.phoneNumber}, press Enter to keep): ');
    String? phoneInput = stdin.readLineSync();
    String phoneNumber =
        (phoneInput?.isNotEmpty ?? false) ? phoneInput! : staff.phoneNumber;

    Staff updatedStaff = admin.updateContactInfo(staff.id, email, phoneNumber);

    print(
        '\nContact information updated successfully for ${staff.firstName} ${staff.lastName}.');
    print('=' * 60);
    return updatedStaff;
  }

  void _updatePatientsSeen() {
    try {
      print('\n' + '=' * 60);
      print('UPDATE PATIENTS SEEN (DOCTORS ONLY)'.padLeft(40));
      print('=' * 60);

      stdout.write('Enter Shift ID: ');
      int shiftId = int.parse(stdin.readLineSync()!);

      var staffList = admin.getStaffForShift(shiftId);
      var doctors = staffList.where((s) => s.id.startsWith('D')).toList();

      if (doctors.isEmpty) {
        print('No doctors assigned to Shift $shiftId');
        print('=' * 60);
        return;
      }

      print('\nDoctors assigned to Shift $shiftId:');
      for (var doctor in doctors) {
        print('  - ${doctor.id}: Dr. ${doctor.firstName} ${doctor.lastName}');
      }

      stdout.write('\nEnter Doctor ID: ');
      String doctorId = stdin.readLineSync()!;

      if (!doctors.any((d) => d.id == doctorId)) {
        print('Error: Doctor $doctorId is not assigned to Shift $shiftId');
        print('=' * 60);
        return;
      }

      stdout.write('Enter number of patients seen: ');
      int patients = int.parse(stdin.readLineSync()!);

      if (patients < 0) {
        print('Error: Number of patients cannot be negative!');
        print('=' * 60);
        return;
      }

      admin.updatePatientsSeen(shiftId, doctorId, patients);
      print('=' * 60);
    } catch (e) {
      print('\nError: Failed to update patients seen. Please check your input and try again.');
      print('=' * 60);
    }
  }

  void _viewStaffMonthlySalary() {
    try {
      print('\n' + '=' * 60);
      print('VIEW STAFF MONTHLY SALARY'.padLeft(40));
      print('=' * 60);

      stdout.write('Enter Staff ID: ');
      String staffId = stdin.readLineSync()!;

      stdout.write('Enter Year (e.g., 2025): ');
      int year = int.parse(stdin.readLineSync()!);

      stdout.write('Enter Month (1-12): ');
      int month = int.parse(stdin.readLineSync()!);

      if (month < 1 || month > 12) {
        print('Error: Month must be between 1 and 12!');
        print('=' * 60);
        return;
      }

      admin.viewMonthlySalary(staffId, year, month);
    } catch (e) {
      print('\nError: Failed to view monthly salary. Please check your input and try again.');
      print('=' * 60);
    }
  }

  void _viewAllMonthlySalaries() {
    try {
      print('\n' + '=' * 60);
      print('VIEW ALL STAFF MONTHLY SALARIES'.padLeft(40));
      print('=' * 60);

      stdout.write('Enter Year (e.g., 2025): ');
      int year = int.parse(stdin.readLineSync()!);

      stdout.write('Enter Month (1-12): ');
      int month = int.parse(stdin.readLineSync()!);

      if (month < 1 || month > 12) {
        print('Error: Month must be between 1 and 12!');
        print('=' * 60);
        return;
      }

      admin.viewAllMonthlySalaries(year, month);
    } catch (e) {
      print('\nError: Failed to view monthly salaries. Please check your input and try again.');
      print('=' * 60);
    }
  }
}
