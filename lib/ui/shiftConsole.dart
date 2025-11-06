import 'dart:io';
import '../domain/Admin.dart';

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
        case '6':
          _removeStaffFromShift();
          break;
        case '7':
          _viewStaffForShift();
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
    print('6. Remove Staff from Shift');
    print('7. View Staff for Specific Shift');
    print('0. Exit');
    print('=' * 60);
    stdout.write('Enter your choice (0-7): ');
  }

  void _viewAllShifts() {
    print('\n' + '=' * 60);
    print('ALL SHIFTS'.padLeft(40));
    print('=' * 60);
    
    final shifts = admin.getShifts();
    if (shifts.isEmpty) {
      print('No shifts available.');
      print('=' * 60);
      return;
    }
    for (final shift in shifts) {
      print('Shift ID: ${shift.shiftId}, Start: ${shift.startTime}, End: ${shift.endTime}, Allowance: \$${shift.shiftAllowance}');
    }
    print('=' * 60);
  }

  void _addNewShift() {
    try {
      print('\n' + '=' * 60);
      print('ADD NEW SHIFT'.padLeft(40));
      print('=' * 60);
      
      stdout.write('Enter date (yyyy-MM-dd), e.g., 2025-11-04: ');
      String? dateStr = stdin.readLineSync();
      
      if (dateStr == null || dateStr.trim().isEmpty) {
        print('Error: Date cannot be empty!');
        print('=' * 60);
        return;
      }

      DateTime date = DateTime.parse(dateStr.trim());
      
      print('\nSelect shift type:');
      print('1. Morning Shift (7:00-15:00) - \$100');
      print('2. Evening Shift (15:00-23:00) - \$120');
      print('3. Night Shift (23:00-07:00) - \$150');
      print('4. Weekend Shift (8:00-20:00) - \$180');
      stdout.write('Choice (1-4): ');
      
      String? templateChoice = stdin.readLineSync();
      
      ShiftTemplate? template;
      switch (templateChoice) {
        case '1':
          template = ShiftTemplate.morning;
          break;
        case '2':
          template = ShiftTemplate.evening;
          break;
        case '3':
          template = ShiftTemplate.night;
          break;
        case '4':
          template = ShiftTemplate.weekend;
          break;
        default:
          print('Invalid choice!');
          return;
      }
      
      admin.createShiftFromTemplate(date, template);
      print('=' * 60);
    } on FormatException {
      print('\nError: Invalid date format! Please use yyyy-MM-dd (e.g., 2025-11-04)');
      print('=' * 60);
    } catch (e) {
      print('\nError: Failed to create shift. Please check your input and try again.');
      print('=' * 60);
    }
  }

  void _removeShift() {
    try {
      print('\n' + '=' * 60);
      print('REMOVE SHIFT'.padLeft(40));
      print('=' * 60);

      final shifts = admin.getShifts();
      if (shifts.isEmpty) {
        print('No shifts available to remove.');
        print('=' * 60);
        return;
      }
      
      print('\nCurrent Shifts:');
      for (final shift in shifts) {
        print('ID: ${shift.shiftId} | ${shift.startTime} to ${shift.endTime} | \$${shift.shiftAllowance}');
      }
      
      stdout.write('\nEnter Shift ID to remove (0 to cancel): ');
      int shiftId = int.parse(stdin.readLineSync()!);
      
      if (shiftId == 0) {
        print('Operation cancelled.');
        print('=' * 60);
        return;
      }
      
      admin.removeShift(shiftId);
      print('=' * 60);
    } catch (e) {
      print('\nError: Failed to remove shift. Please check the shift ID and try again.');
      print('=' * 60);
    }
  }

  void _assignStaffToShift() {
    try {
      print('\n' + '=' * 60);
      print('ASSIGN STAFF TO SHIFT'.padLeft(40));
      print('=' * 60);
      print("Enter shiftId: ");
      int shiftId = int.parse(stdin.readLineSync()!);
      print("Enter staff ID to assign: ");
      String staffId = stdin.readLineSync()!;

      
      admin.assignStaffToShift(shiftId, staffId);
      print('=' * 60);
    } catch (e) {
      print('\nError: Failed to assign staff to shift. Please check your input and try again.');
      print('=' * 60);
    }
  }

  void _viewShiftAssignments() {
    try {
      print('\n' + '=' * 60);
      print('SHIFT ASSIGNMENTS'.padLeft(40));
      print('=' * 60);
      
      admin.viewStaffAssignments();
      print('=' * 60);
    } catch (e) {
      print('\nError: Failed to view shift assignments. Please try again.');
      print('=' * 60);
    }
  }

  void _removeStaffFromShift() {
    try {
      print('\n' + '=' * 60);
      print('REMOVE STAFF FROM SHIFT'.padLeft(40));
      print('=' * 60);
      
      stdout.write('Enter Shift ID: ');
      int shiftId = int.parse(stdin.readLineSync()!);
      
      var staffList = admin.getStaffForShift(shiftId);
      if (staffList.isEmpty) {
        print('No staff assigned to Shift $shiftId');
        print('=' * 60);
        return;
      }
      
      print('\nCurrent staff assigned to Shift $shiftId:');
      for (var staff in staffList) {
        print('  - ${staff.id}: ${staff.firstName} ${staff.lastName}');
      }
      
      stdout.write('\nEnter Staff ID to remove: ');
      String staffId = stdin.readLineSync()!;
      
      admin.removeStaffFromShift(shiftId, staffId);
      print('=' * 60);
    } catch (e) {
      print('\nError: Failed to remove staff from shift. Please check your input and try again.');
      print('=' * 60);
    }
  }

  void _viewStaffForShift() {
    try {
      print('\n' + '=' * 60);
      print('VIEW STAFF FOR SPECIFIC SHIFT'.padLeft(40));
      print('=' * 60);
      
      stdout.write('Enter Shift ID: ');
      int shiftId = int.parse(stdin.readLineSync()!);
      
      var staffList = admin.getStaffForShift(shiftId);
      
      if (staffList.isEmpty) {
        print('No staff assigned to Shift $shiftId');
      } else {
        print('\nStaff assigned to Shift $shiftId:');
        for (var staff in staffList) {
          String role = admin.getRoleFromId(staff.id);
          print('  - ${staff.id} ($role): ${staff.firstName} ${staff.lastName}');
          print('    Email: ${staff.email}, Phone: ${staff.phoneNumber}');
        }
        print('\nTotal: ${staffList.length} staff member(s)');
      }
      print('=' * 60);
    } catch (e) {
      print('\nError: Failed to view staff for shift. Please check the shift ID and try again.');
      print('=' * 60);
    }
  }
}
