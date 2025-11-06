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

  List<Shift> readShifts() => _repo().readAll();

  void writeShifts(List<Shift> shifts) => _repo().writeAll(shifts);
}