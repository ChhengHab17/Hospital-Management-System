import 'Shift.dart';
import 'ShiftAssignment.dart';
import 'Staff.dart';
import 'Doctor.dart';

const double BONUS_PER_PATIENT = 50.0;

class Payroll {
  final String staffId;
  final double baseSalary;
  final List<Shift> shifts = [];

  Payroll({
    required this.staffId,
    required this.baseSalary,
  });

  double calculateTotalSalary() {
    double totalShiftAllowance = shifts.fold(0, (sum, shift) => sum + shift.shiftAllowance);
    return baseSalary + totalShiftAllowance;
  }

  // Calculate monthly salary based on shifts worked in a specific month
  double calculateMonthlySalary({
    required int year,
    required int month,
    required Staff staff,
    required List<Shift> allShifts,
    required Map<String, ShiftAssignment> assignmentDetails,
  }) {
    // Base salary (default rates)
    double base = staff is Doctor ? 5000.0 : 3000.0;
    double shiftAllowance = 0.0;
    double bonus = 0.0;

    // Filter shifts for the specified month
    List<Shift> monthShifts = allShifts.where((shift) {
      return shift.startTime.year == year && shift.startTime.month == month;
    }).toList();

    // Calculate shift allowances and bonuses for this staff member
    for (var shift in monthShifts) {
      String key = '${shift.shiftId}-${staff.id}';
      
      // Check if this staff worked this shift
      if (assignmentDetails.containsKey(key)) {
        shiftAllowance += shift.shiftAllowance;
        
        // For doctors, add patient bonus
        if (staff is Doctor) {
          ShiftAssignment assignment = assignmentDetails[key]!;
          bonus += assignment.patientsSeen * BONUS_PER_PATIENT;
        }
      }
    }

    return base + shiftAllowance + bonus;
  }
}