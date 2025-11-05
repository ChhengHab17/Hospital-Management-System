import '../domain/Staff.dart';

import '../domain/Admin.dart';
import 'adminConsole.dart';

class HospitalConsole {
  final Admin admin = Admin(
    id: 'ADMIN001',
    firstName: 'System',
    lastName: 'Administrator',
    email: 'admin@hospital.com',
    phoneNumber: '000-000-0000',
    dateOfBirth: DateTime(1990, 1, 1),
    department: Department.General
  );
  void run() {
    _runAdminConsole();
    
  }

  void _runAdminConsole() {
    AdminConsole adminConsole = AdminConsole(admin);
    adminConsole.run();
  }
}

