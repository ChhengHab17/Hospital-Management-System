import 'Staff.dart';

class Department {
  final int departmentId;
  final String departmentName;
  final List<Staff> staffMembers;

  Department({
    required this.departmentId,
    required this.departmentName,
    required this.staffMembers,
  });
}