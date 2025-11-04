import 'dart:io';
import '../domain/Admin.dart';
import 'shiftConsole.dart';
import 'adminConsole.dart';

class HospitalConsole {
  final Admin admin = Admin(
    id: 'ADMIN001',
    firstName: 'System',
    lastName: 'Administrator',
    email: 'admin@hospital.com',
    phoneNumber: '000-000-0000',
    dateOfBirth: DateTime(1990, 1, 1),
    password: 'admin123',
    role: Role.Doctor,
  );
  void run() {
    while (true) {
      _displayMainMenu();
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          _runShiftManagement();
          break;
        case '2':
          _runStaffManagement();
          break;
        case '3':
          print('\nThank you for using Hospital Management System. Goodbye!');
          return;
        default:
          print('\nInvalid choice! Please try again.');
          print('Press Enter to continue...');
          stdin.readLineSync();
      }
    }
    
  }

  void _displayMainMenu() {
    print('\n' + '=' * 70);
    print('HOSPITAL MANAGEMENT SYSTEM'.padLeft(50));
    print('=' * 70);
    print('1. Shift Management');
    print('2. Staff Management');
    print('3. Exit');
    print('=' * 70);
    print('Enter your choice (1-3): ');
  }

  void _runShiftManagement() {
    ShiftConsole shiftConsole = ShiftConsole(admin);
    shiftConsole.run();
  }

  void _runStaffManagement() {
    AdminConsole adminConsole = AdminConsole(admin);
    adminConsole.run();
  }

}
