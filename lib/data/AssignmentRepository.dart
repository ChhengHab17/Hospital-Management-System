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

  // Read assignments from JSON file
  List<ShiftAssignment> readAll() => _repo().readAll();

  // Write assignments to JSON file
  void writeAll(List<ShiftAssignment> assignments) => _repo().writeAll(assignments);
}
