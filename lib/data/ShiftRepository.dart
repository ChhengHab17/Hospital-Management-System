import '../domain/Shift.dart';
import 'JsonRepository.dart';

class ShiftRepository {
  final String filePath;

  const ShiftRepository({required this.filePath});

  JsonRepository<Shift> _repo() => JsonRepository<Shift>(
        filePath: filePath,
        rootKey: 'shifts',
        fromJson: (m) => Shift.fromJson(m),
        toJson: (s) => s.toJson(),
      );

  // Read shifts from JSON file
  List<Shift> readShifts() => _repo().readAll();

  // Write shifts to JSON file
  void writeShifts(List<Shift> shifts) => _repo().writeAll(shifts);
}