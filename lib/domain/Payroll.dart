import 'Shift.dart';

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
}