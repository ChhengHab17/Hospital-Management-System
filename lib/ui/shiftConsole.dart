import 'dart:io';
import '../domain/Admin.dart';
import '../domain/Shift.dart';

class ShiftConsole {
  final Admin admin;

  ShiftConsole(this.admin);

  void run() {
    while (true) {
      _displayMainMenu();
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          _viewAllShifts();
          break;
        case '2':
          _addNewShift();
          break;
        case '3':
          _removeShift();
          break;
        case '4':
          _assignStaffToShift();
          break;
        case '5':
          _viewShiftAssignments();
          break;
        case '0':
          print('\nExiting Shift Management System. Goodbye!');
          return;
        default:
          print('\nInvalid choice! Please try again.');
      }

      print('\nPress Enter to continue...');
      stdin.readLineSync();
    }
  }

  void _displayMainMenu() {
    print('\n' + '=' * 60);
    print('HOSPITAL SHIFT MANAGEMENT SYSTEM'.padLeft(40));
    print('=' * 60);
    print('1. View All Shifts');
    print('2. Add New Shift');
    print('3. Remove Shift');
    print('4. Assign Staff to Shift');
    print('5. View Shift Assignments');
    print('0. Exit');
    print('=' * 60);
    print('Enter your choice (0-5): ');
  }

  void _viewAllShifts() {
    print('\n' + '=' * 80);
    print('ALL SHIFTS'.padLeft(45));
    print('=' * 80);
    
    final shifts = admin.getShifts();
    if (shifts.isEmpty) {
      print('No shifts available.');
      return;
    }
    for (final shift in shifts) {
      print('Shift ID: ${shift.shiftId}, Start: ${shift.startTime}, End: ${shift.endTime}, Allowance: \$${shift.shiftAllowance}');
    }
  }

  void _addNewShift() {
    print("Enter shiftId: ");
    int shiftId = int.parse(stdin.readLineSync()!);
    print("Enter start time (format: yyyy-MM-dd HH:mm): ");
    String startInput = stdin.readLineSync()!;
    DateTime startTime = DateTime.parse(startInput.replaceFirst(' ', 'T'));

    print("Enter end time (format: yyyy-MM-dd HH:mm): ");
    String endInput = stdin.readLineSync()!;
    DateTime endTime = DateTime.parse(endInput.replaceFirst(' ', 'T'));

    print("Enter shift allowance: ");
    double shiftAllowance = double.parse(stdin.readLineSync()!);
    Shift shift = Shift(shiftId: shiftId, startTime: startTime, endTime: endTime, shiftAllowance: shiftAllowance);
  admin.addShift(shift);
  }

  void _removeShift() {
    print("Enter shiftId to remove: ");
    int shiftId = int.parse(stdin.readLineSync()!);
    
  admin.removeShift(shiftId);
  }

  void _assignStaffToShift() {
    print('\n' + '=' * 60);
    print('ASSIGN STAFF TO SHIFT');
    print('=' * 60);
    print("Enter shiftId: ");
    int shiftId = int.parse(stdin.readLineSync()!);
    print("Enter staff ID to assign: ");
    String staffId = stdin.readLineSync()!;

    
  admin.assignStaffToShift(shiftId, staffId);
  }

  void _viewShiftAssignments() {
  print('\n' + '=' * 80);
  print('SHIFT ASSIGNMENTS'.padLeft(50));
  print('=' * 80);
    
  admin.viewStaffAssignments();
  }
}

