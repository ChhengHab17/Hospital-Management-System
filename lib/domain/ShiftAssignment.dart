class ShiftAssignment {
  final int shiftId;
  final String staffId;
  final int patientsSeen;

  ShiftAssignment({
    required this.shiftId,
    required this.staffId,
    this.patientsSeen = 0,
  });

  Map<String, Object?> toJson() {
    return {
      'shiftId': shiftId,
      'staffId': staffId,
      'patientsSeen': patientsSeen,
    };
  }

  factory ShiftAssignment.fromJson(Map<String, Object?> json) {
    return ShiftAssignment(
      shiftId: json['shiftId'] as int,
      staffId: json['staffId'] as String,
      patientsSeen: json['patientsSeen'] as int,
    );
  }

  @override
  String toString() {
    return 'ShiftAssignment(shiftId: $shiftId, staffId: $staffId, patientsSeen: $patientsSeen)';
  }

  // Create a copy with updated values
  ShiftAssignment copyWith({
    int? shiftId,
    String? staffId,
    int? patientsSeen,
  }) {
    return ShiftAssignment(
      shiftId: shiftId ?? this.shiftId,
      staffId: staffId ?? this.staffId,
      patientsSeen: patientsSeen ?? this.patientsSeen,
    );
  }
}
