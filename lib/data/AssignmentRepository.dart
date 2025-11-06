import 'JsonRepository.dart';
import '../domain/ShiftAssignment.dart';

class AssignmentRepository {
  final String filePath;

  const AssignmentRepository({required this.filePath});

  JsonRepository<ShiftAssignment> _repo() => JsonRepository<ShiftAssignment>(
        filePath: filePath,
        rootKey: 'assignments',
        fromJson: (m) => ShiftAssignment.fromJson(m),
        toJson: (a) => a.toJson(),
      );

  List<ShiftAssignment> readAll() => _repo().readAll();

  void writeAll(List<ShiftAssignment> assignments) => _repo().writeAll(assignments);
}
