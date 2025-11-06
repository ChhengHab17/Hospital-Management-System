import 'package:test/test.dart';
import '../lib/domain/Admin.dart';
import '../lib/domain/Doctor.dart';
import '../lib/domain/Staff.dart';
import '../lib/domain/Payroll.dart';

void main() {
  late Admin admin;

  setUp(() {
    admin = Admin(
      id: 'A1',
      firstName: 'Admin',
      lastName: 'User',
      email: 'admin@gmail.com',
      phoneNumber: '1234567890',
      dateOfBirth: DateTime(1980, 1, 1),
      department: Department.General,
    );
    admin.staffs.clear();
    admin.shifts.clear();
    admin.shiftAssignments.clear();
    admin.assignmentDetails.clear();
  });

  group('Critical Functionality Tests', () {
    test('1. Create doctor with correct ID and attributes', () {
      admin.createDoctorAccount(
        'Tang',
        'jeng',
        'tangjeng@gmail.com',
        '0111111111',
        DoctorSpecialization.cardiologist,
        DateTime(1990, 5, 15),
        Department.Cardiology,
      );

      expect(admin.staffs.length, 1);
      expect(admin.staffs[0].id, 'DR1');
      expect(admin.staffs[0], isA<Doctor>());
      expect(admin.staffs[0].firstName, 'Tang');
    });

    test('2. Update contact info validates email format', () {
      admin.createNurseAccount(
        'Kun',
        'Pich',
        'Pich@gmail.com',
        '0222222222',
        DateTime(1992, 8, 20),
        Department.Emergency,
      );

      expect(
        () => admin.updateContactInfo('N1', 'invalidemail', '2222222222'),
        throwsArgumentError,
      );

      admin.updateContactInfo('N1', 'new.email@gmail.com', '0222222222');
      expect(admin.staffs[0].email, 'new.email@gmail.com');
    });

    test('3. Shift templates create correct times and allowances', () {
      admin.createShiftFromTemplate(DateTime(2025, 11, 5), ShiftTemplate.morning);
      admin.createShiftFromTemplate(DateTime(2025, 11, 6), ShiftTemplate.evening);
      admin.createShiftFromTemplate(DateTime(2025, 11, 7), ShiftTemplate.night);

      expect(admin.shifts.length, 3);
      expect(admin.shifts[0].shiftAllowance, 100.0);
      expect(admin.shifts[1].shiftAllowance, 120.0);
      expect(admin.shifts[2].shiftAllowance, 150.0);
    });

    test('4. Assign and remove staff from shifts', () {
      admin.createDoctorAccount(
        'Tang',
        'jeng',
        'Tangjeng@gmail.com',
        '0111111111',
        DoctorSpecialization.cardiologist,
        DateTime(1990, 5, 15),
        Department.Cardiology,
      );

      admin.createShiftFromTemplate(DateTime(2025, 11, 5), ShiftTemplate.morning);

      admin.assignStaffToShift(1, 'DR1');
      expect(admin.assignmentDetails.containsKey('1-DR1'), true);

      admin.removeStaffFromShift(1, 'DR1');
      expect(admin.staffs.length, 1);
    });

    test('5. Duplicate staff assignment does not duplicate', () {
      admin.createNurseAccount(
        'Kun',
        'Pich',
        'pich@gmail.com',
        '0222222222',
        DateTime(1992, 8, 20),
        Department.Emergency,
      );

      admin.createShiftFromTemplate(DateTime(2025, 11, 5), ShiftTemplate.morning);

      admin.assignStaffToShift(1, 'N1');
      admin.assignStaffToShift(1, 'N1');

      int count = admin.assignmentDetails.keys.where((key) => key == '1-N1').length;
      expect(count, 1);
    });

    test('6. Only doctors can have patients seen updated', () {
      admin.createDoctorAccount(
        'Tang',
        'jeng',
        'Tangjeng@gmail.com',
        '0111111111',
        DoctorSpecialization.cardiologist,
        DateTime(1990, 5, 15),
        Department.Cardiology,
      );

      admin.createNurseAccount(
        'Kun',
        'Pich',
        'Pich@gmail.com',
        '0222222222',
        DateTime(1992, 8, 20),
        Department.Emergency,
      );

      admin.createShiftFromTemplate(DateTime(2025, 11, 5), ShiftTemplate.morning);
      admin.assignStaffToShift(1, 'DR1');
      admin.assignStaffToShift(1, 'N1');

      admin.updatePatientsSeen(1, 'DR1', 15);
      expect(admin.assignmentDetails['1-DR1']!.patientsSeen, 15);

      expect(() => admin.updatePatientsSeen(1, 'N1', 10), returnsNormally);
    });

    test('7. Doctor monthly salary includes base + shifts + patient bonuses', () {
      admin.createDoctorAccount(
        'Tang',
        'jeng',
        'Tangjeng@gmail.com',
        '0111111111',
        DoctorSpecialization.cardiologist,
        DateTime(1990, 5, 15),
        Department.Cardiology,
      );

      admin.createShiftFromTemplate(DateTime(2025, 11, 5), ShiftTemplate.morning);
      admin.assignStaffToShift(1, 'DR1');
      admin.updatePatientsSeen(1, 'DR1', 10);

      Payroll payroll = Payroll(staffId: 'DR1', baseSalary: 5000.0);
      Doctor doctor = admin.staffs[0] as Doctor;
      
      double salary = payroll.calculateMonthlySalary(
        year: 2025,
        month: 11,
        staff: doctor,
        allShifts: admin.shifts,
        assignmentDetails: admin.assignmentDetails,
      );

      expect(salary, 5600.0);
    });

    test('8. Only shifts from specified month are counted in salary', () {
      admin.createDoctorAccount(
        'Tang',
        'jeng',
        'Tangjeng@gmail.com',
        '0111111111',
        DoctorSpecialization.cardiologist,
        DateTime(1990, 5, 15),
        Department.Cardiology,
      );

      admin.createShiftFromTemplate(DateTime(2025, 11, 5), ShiftTemplate.morning);
      admin.createShiftFromTemplate(DateTime(2025, 12, 10), ShiftTemplate.evening);

      admin.assignStaffToShift(1, 'DR1');
      admin.assignStaffToShift(2, 'DR1');
      admin.updatePatientsSeen(1, 'DR1', 5);
      admin.updatePatientsSeen(2, 'DR1', 8);

      Payroll payroll = Payroll(staffId: 'DR1', baseSalary: 5000.0);
      Doctor doctor = admin.staffs[0] as Doctor;
      
      double novemberSalary = payroll.calculateMonthlySalary(
        year: 2025,
        month: 11,
        staff: doctor,
        allShifts: admin.shifts,
        assignmentDetails: admin.assignmentDetails,
      );

      expect(novemberSalary, 5350.0);
    });
  });
}
