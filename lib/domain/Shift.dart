class Shift {
  final int shiftId;
  final DateTime startTime;
  final DateTime endTime;
  final double shiftAllowance;

  Shift({
    required this.shiftId,
    required this.startTime,
    required this.endTime,
    required this.shiftAllowance,
  });

  // Convert Shift to JSON Map
  Map<String, Object?> toJson() {
    return {
      'shiftId': shiftId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'shiftAllowance': shiftAllowance,
    };
  }

  // Create Shift from JSON Map
  factory Shift.fromJson(Map<String, Object?> json) {
    return Shift(
      shiftId: json['shiftId'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      shiftAllowance: (json['shiftAllowance'] as num).toDouble(),
    );
  }
}