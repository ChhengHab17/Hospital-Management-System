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

  double calculateMonthlySalary({
    required int year,
    required int month,
    required Staff staff,
    required List<Shift> allShifts,
    required Map<String, ShiftAssignment> assignmentDetails,
  }) {
    double base = staff is Doctor ? 5000.0 : 3000.0;
    double shiftAllowance = 0.0;
    double bonus = 0.0;

    List<Shift> monthShifts = allShifts.where((shift) {
      return shift.startTime.year == year && shift.startTime.month == month;
    }).toList();

    for (var shift in monthShifts) {
      String key = '${shift.shiftId}-${staff.id}';
      
      if (assignmentDetails.containsKey(key)) {
        shiftAllowance += shift.shiftAllowance;
        
        if (staff is Doctor) {
          ShiftAssignment assignment = assignmentDetails[key]!;
          bonus += assignment.patientsSeen * BONUS_PER_PATIENT;
        }
      }
    }

    return base + shiftAllowance + bonus;
  }
}