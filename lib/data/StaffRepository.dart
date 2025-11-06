import 'JsonRepository.dart';
import '../domain/Staff.dart';
import '../domain/Doctor.dart';
import '../domain/Nurse.dart';

class StaffRepository {
  final String filePath;

  const StaffRepository({required this.filePath});

  JsonRepository<Staff> _repo() => JsonRepository<Staff>(
        filePath: filePath,
        rootKey: 'staffs',
        fromJson: (m) {
          final id = m['id'] as String;
          if (id.startsWith('DR')) {
            return Doctor.fromJson(m);
          } else if (id.startsWith('N')) {
            return Nurse.fromJson(m);
          }
          throw ArgumentError('Unknown staff type based on ID: $id');
        },
        toJson: (s) => s.toJson(),
      );

  List<Staff> readStaffs() => _repo().readAll();

  void writeStaffs(List<Staff> staffs) => _repo().writeAll(staffs);
}