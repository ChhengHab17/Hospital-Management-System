
import 'Doctor.dart';
import 'Nurse.dart';
import 'Shift.dart';
import 'Staff.dart';
import 'ShiftAssignment.dart';
import 'Payroll.dart';
import '../data/ShiftRepository.dart';
import '../data/StaffRepository.dart';
import '../data/AssignmentRepository.dart';

enum Role { Doctor, Nurse }

enum ShiftTemplate { morning, evening, night, weekend }

class Admin extends Staff {
  final ShiftRepository shiftRepository = ShiftRepository(filePath: 'shift.json');
  final StaffRepository staffRepository = StaffRepository(filePath: 'staff.json');
  final AssignmentRepository assignmentRepository = AssignmentRepository(filePath: 'assignment.json');

  List<Staff> staffs = [];

  List<Shift> shifts = [];
  Map<Shift, List<Staff>> shiftAssignments = {};
  Map<String, ShiftAssignment> assignmentDetails = {};

  Admin({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required Department department,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          dateOfBirth: dateOfBirth,
          department: department,
        ) {
    loadStaffFromFile();
    loadShiftsFromFile();
    loadAssignmentsFromFile();
  }

  int get age => DateTime.now().year - dateOfBirth.year;

  List<Staff> getStaff() {
    return staffs;
  }
  
  String _generateStaffId(String prefix) {
    if (staffs.isEmpty) return '${prefix}1';
    int maxNumber = 0;
    for (var staff in staffs) {
      if (staff.id.startsWith(prefix)) {
        String numberPart = staff.id.substring(prefix.length);
        int? number = int.tryParse(numberPart);
        if (number != null && number > maxNumber) {
          maxNumber = number;
        }
      }
    }
    
    return '$prefix${maxNumber + 1}';
  }
  void createDoctorAccount(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    DoctorSpecialization specialization,
    DateTime dateOfBirth,
    Department department,
    ) {
    String id = _generateStaffId('DR');
    staffs.add(
      Doctor(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        department: department,
        specialization: specialization,
      ),
    );
    saveStaffToFile();
  }

  void createNurseAccount(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    DateTime dateOfBirth,
    Department department,
  ) {
    String id = _generateStaffId('N');
    staffs.add(
      Nurse(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        department: department,
      ),
    );
    saveStaffToFile();
  }

  void loadShiftsFromFile() {
    try {
      var loadedShifts = shiftRepository.readShifts();
      shifts = List<Shift>.from(loadedShifts, growable: true);
    } catch (e) {
      print('Could not load shifts: $e');
      shifts = [];
    }
  }

  void saveShiftsToFile() {
    try {
      shiftRepository.writeShifts(shifts);
    } catch (e) {
      print('Error saving shifts: $e');
    }
  }
  void saveStaffToFile() {
    try{
      staffRepository.writeStaffs(staffs);
    } catch (e) {
      print('Error saving staff: $e');
    }
  }
  void loadStaffFromFile() {
    try {
      var loadedStaffs = staffRepository.readStaffs();
      staffs = List<Staff>.from(loadedStaffs, growable: true);
    } catch (e) {
      print('Could not load staff: $e');
      staffs = [];
    }
  }

  void loadAssignmentsFromFile() {
    try {
      var loadedAssignments = assignmentRepository.readAll();
      shiftAssignments.clear();
      assignmentDetails.clear();
      
      for (var assignment in loadedAssignments) {
        Shift? shift = shifts.firstWhere((s) => s.shiftId == assignment.shiftId);
        Staff? staff = staffs.firstWhere((s) => s.id == assignment.staffId);
        
        if (!shiftAssignments.containsKey(shift)) {
          shiftAssignments[shift] = [];
        }
        shiftAssignments[shift]!.add(staff);
        
        String key = '${assignment.shiftId}-${assignment.staffId}';
        assignmentDetails[key] = assignment;
      }
    } catch (e) {
      print('Could not load assignments: $e');
      shiftAssignments = {};
      assignmentDetails = {};
    }
  }

  void saveAssignmentsToFile() {
    try {
      List<ShiftAssignment> assignments = [];
      shiftAssignments.forEach((shift, staffList) {
        for (var staff in staffList) {
          String key = '${shift.shiftId}-${staff.id}';
          if (assignmentDetails.containsKey(key)) {
            assignments.add(assignmentDetails[key]!);
          } else {
            assignments.add(ShiftAssignment(
              shiftId: shift.shiftId,
              staffId: staff.id,
              patientsSeen: 0,
            ));
          }
        }
      });
      assignmentRepository.writeAll(assignments);
    } catch (e) {
      print('Error saving assignments: $e');
    }
  }
  
  String getRoleFromId(String id) {
    if (id.startsWith('DR')) return 'Doctor';
    if (id.startsWith('N')) return 'Nurse';
    return 'Unknown';
  }

  void displayAllStaff(List<Staff> staffList) {
    for (var staff in staffList) {
      String role = getRoleFromId(staff.id);
      print("${staff.id} - ${role} ${staff.firstName} ${staff.lastName} - ${staff.dateOfBirth} - ${staff.email} - ${staff.phoneNumber}");
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

  Staff updateProfile(String staffId, String newFirstName, String newLastName, DateTime newDateOfBirth) {
    for (int i = 0; i < staffs.length; i++) {
      if (staffs[i].id == staffId) {
        staffs[i] = staffs[i].copyWith(
          firstName: newFirstName, 
          lastName: newLastName,
          dateOfBirth: newDateOfBirth,
        );
        break;
      }
    }
    saveStaffToFile();
    return staffs.firstWhere((staff) => staff.id == staffId);
  }

  Staff updateContactInfo(String staffId, String newEmail, String newPhoneNumber) {
    if (!newEmail.contains('@')) {
      throw ArgumentError('Invalid email format');
    }

    for (int i = 0; i < staffs.length; i++) {
      if (staffs[i].id == staffId) {
        staffs[i] = staffs[i].copyWith(
          email: newEmail,
          phoneNumber: newPhoneNumber,
        );
        break;
      }
    }
    saveStaffToFile();
    return staffs.firstWhere((staff) => staff.id == staffId);
  }

  bool deleteAccount(String staffId) {
    try {
      final initialLength = staffs.length;
      staffs.removeWhere((staff) => staff.id == staffId);
      saveStaffToFile();
      
      if (staffs.length < initialLength) {
        shiftAssignments.forEach((shift, staffList) {
          staffList.removeWhere((staff) => staff.id == staffId);
        });
        shiftAssignments.removeWhere((shift, staffList) => staffList.isEmpty);
        saveAssignmentsToFile();
        print('Staff member with ID $staffId deleted successfully');
        return true;
      } else {
        print('Staff member with ID $staffId not found');
        return false;
      }
    } catch (e) {
      print('Error deleting account: $e');
      return false;
    }
  }

  void addShift(Shift shift) {
    if (shifts.any((s) => s.shiftId == shift.shiftId)) {
      print('Shift with ID ${shift.shiftId} already exists!');
      return;
    }
    
    shifts.add(shift);
    saveShiftsToFile();
    print('Shift added successfully!');
  }

  int _generateShiftId() {
    if (shifts.isEmpty) return 1;
    return shifts.map((s) => s.shiftId).reduce((a, b) => a > b ? a : b) + 1;
  }

  void createShiftFromTemplate(DateTime date, ShiftTemplate template) {
    DateTime startTime, endTime;
    double allowance;
    
    switch (template) {
      case ShiftTemplate.morning:
        startTime = DateTime(date.year, date.month, date.day, 7, 0);
        endTime = DateTime(date.year, date.month, date.day, 15, 0);
        allowance = 100.0;
        break;
      case ShiftTemplate.evening:
        startTime = DateTime(date.year, date.month, date.day, 15, 0);
        endTime = DateTime(date.year, date.month, date.day, 23, 0);
        allowance = 120.0;
        break;
      case ShiftTemplate.night:
        startTime = DateTime(date.year, date.month, date.day, 23, 0);
        endTime = DateTime(date.year, date.month, date.day + 1, 7, 0);
        allowance = 150.0;
        break;
      case ShiftTemplate.weekend:
        startTime = DateTime(date.year, date.month, date.day, 8, 0);
        endTime = DateTime(date.year, date.month, date.day, 20, 0);
        allowance = 180.0;
        break;
    }
    
    int newId = _generateShiftId();
    Shift shift = Shift(
      shiftId: newId,
      startTime: startTime,
      endTime: endTime,
      shiftAllowance: allowance,
    );
    
    shifts.add(shift);
    saveShiftsToFile();
    print('Shift #$newId created successfully! (${startTime} to ${endTime})');
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

    if (!shiftAssignments.containsKey(shift)) {
      shiftAssignments[shift] = [];
    }
    
    if (!shiftAssignments[shift]!.any((s) => s.id == staffId)) {
      shiftAssignments[shift]!.add(staff);
      
      String key = '$shiftId-$staffId';
      assignmentDetails[key] = ShiftAssignment(
        shiftId: shiftId,
        staffId: staffId,
        patientsSeen: 0,
      );
      
      saveAssignmentsToFile();
      print('Staff ${staff.firstName} ${staff.lastName} (${staff.id}) assigned to Shift ${shift.shiftId}');
    } else {
      print('Staff ${staff.id} is already assigned to Shift ${shift.shiftId}');
    }
  }

  void updatePatientsSeen(int shiftId, String staffId, int patients) {
    String key = '$shiftId-$staffId';
    
    if (!assignmentDetails.containsKey(key)) {
      print('Error: No assignment found for Staff $staffId in Shift $shiftId');
      return;
    }
    
    Staff? staff = staffs.firstWhere((s) => s.id == staffId);
    if (staff is! Doctor) {
      print('Error: Only doctors can have patients seen recorded!');
      return;
    }
    
    ShiftAssignment currentAssignment = assignmentDetails[key]!;
    assignmentDetails[key] = currentAssignment.copyWith(patientsSeen: patients);
    
    
    print('✓ Updated: Dr. ${staff.firstName} ${staff.lastName} saw $patients patients in Shift $shiftId');
    
    saveAssignmentsToFile();
  }
  
  void viewStaffAssignments() {
    if (shiftAssignments.isEmpty) {
      print('No staff assignments found.');
      return;
    }
    
    shiftAssignments.forEach((shift, staffList) {
      print('\nShift ID: ${shift.shiftId} (${shift.startTime} to ${shift.endTime})');
      if (staffList.isEmpty) {
        print('  No staff assigned');
      } else {
        print('  Assigned Staff:');
        for (var staff in staffList) {
          String role = getRoleFromId(staff.id);
          String key = '${shift.shiftId}-${staff.id}';

          if (assignmentDetails.containsKey(key) && staff is Doctor) {
            ShiftAssignment assignment = assignmentDetails[key]!;
            print('    - ${staff.id} ($role): ${staff.firstName} ${staff.lastName}');
            print('      Patients Seen: ${assignment.patientsSeen}');
          } else {
            print('    - ${staff.id} ($role): ${staff.firstName} ${staff.lastName}');
          }
        }
      }
    });
  }
  
  bool removeStaffFromShift(int shiftId, String staffId) {
    try {
      Shift? shift = shifts.firstWhere((s) => s.shiftId == shiftId);
      
      if (!shiftAssignments.containsKey(shift)) {
        print('No assignments found for Shift $shiftId');
        return false;
      }
      
      var staffList = shiftAssignments[shift]!;
      final initialLength = staffList.length;
      staffList.removeWhere((staff) => staff.id == staffId);
      
      if (staffList.length < initialLength) {
        if (staffList.isEmpty) {
          shiftAssignments.remove(shift);
        }
        saveAssignmentsToFile();
        print('Staff $staffId removed from Shift $shiftId');
        return true;
      } else {
        print('Staff $staffId was not assigned to Shift $shiftId');
        return false;
      }
    } catch (e) {
      print('Error removing staff from shift: $e');
      return false;
    }
  }

  List<Staff> getStaffForShift(int shiftId) {
    try {
      Shift? shift = shifts.firstWhere((s) => s.shiftId == shiftId);
      return shiftAssignments[shift] ?? [];
    } catch (e) {
      print('Shift $shiftId not found');
      return [];
    }
  }
  int getTotalShiftForStaff(String staffId) {
    int totalShifts = 0;
    shiftAssignments.forEach((shift, staffList) {
      if (staffList.any((s) => s.id == staffId)) {
        totalShifts += 1;
      }
    });
    return totalShifts;
  } 

  void viewMonthlySalary(String staffId, int year, int month) {
    try {
      Staff? staff = staffs.firstWhere(
        (s) => s.id == staffId,
        orElse: () => throw Exception('Staff not found')
      );

      Payroll payroll = Payroll(staffId: staffId, baseSalary: 0.0);
      
      double totalSalary = payroll.calculateMonthlySalary(
        year: year,
        month: month,
        staff: staff,
        allShifts: shifts,
        assignmentDetails: assignmentDetails,
      );

      String monthName = _getMonthName(month);
      print('\n${'=' * 60}');
      print('MONTHLY SALARY - $monthName $year');
      print('=' * 60);
      print('Staff ID: ${staff.id}');
      print('Name: ${staff.firstName} ${staff.lastName}');
      print('Department: ${staff.department.name}');
      print('Role: ${staff.role}');
      if (staff is Doctor) {
        print('Specialization: ${staff.specializationName}');
      }
      print('-' * 60);
      print('Total Monthly Salary: \$${totalSalary.toStringAsFixed(2)}');
      print('=' * 60);
    } catch (e) {
      print('Error calculating salary: $e');
    }
  }

  void viewAllMonthlySalaries(int year, int month) {
    String monthName = _getMonthName(month);
    print('\n${'=' * 70}');
    print('MONTHLY SALARY SUMMARY - $monthName $year');
    print('=' * 70);

    double totalPayroll = 0;
    Payroll payroll = Payroll(staffId: '', baseSalary: 0.0);

    for (Staff staff in staffs) {
      double salary = payroll.calculateMonthlySalary(
        year: year,
        month: month,
        staff: staff,
        allShifts: shifts,
        assignmentDetails: assignmentDetails,
      );

      if (salary > 0) {
        totalPayroll += salary;
        print('${staff.id} - ${staff.firstName} ${staff.lastName} (${staff.role}): \$${salary.toStringAsFixed(2)}');
      }
    }

    print('-' * 70);
    print('Total Payroll: \$${totalPayroll.toStringAsFixed(2)}');
    print('=' * 70);
  }

  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
  
}