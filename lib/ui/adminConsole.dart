import 'dart:io';
import '../domain/Staff.dart';
import '../domain/Admin.dart';
import '../domain/Doctor.dart';
import '../domain/Nurse.dart';

class AdminConsole {
    final Admin admin;

    AdminConsole(this.admin);

    void run() {
        while (true) {
            _displayAdminMenu();
            String? choice = stdin.readLineSync();

            switch (choice) {
                case '1':
                    _viewAllStaff();
                    break;
                case '2':
                    _addNewStaff();
                    break;
                case '3':
                    _removeStaff();
                    break;
                case '4':
                    _updateStaffInformation();
                    break;
                case '0':
                    print('Exiting Admin Console. Goodbye!');
                    return;
                default:
                    print('Invalid choice. Please try again.');
            }
        }
    }

    void _displayAdminMenu() {
        print('\n' + '=' * 60);
        print('HOSPITAL ADMINISTRATOR CONSOLE'.padLeft(40));
        print('=' * 60);
        print('1. View all staff');
        print('2. Add new staff');
        print('3. Remove staff');
        print('4. Update staff information');
        print('0. Exit');
        print('=' * 60);
        print('Enter your choice (0-4): ');
    }

    void _viewAllStaff() {
        print('\n' + '=' * 80);
        print('ALL STAFF MEMBERS'.padLeft(45));
        print('=' * 80);
        List<Staff> staffs = admin.getStaff();
        if (staffs.isEmpty) {
            print('No staff members found.');
            return;
        }
        for (var staff in staffs) {
            print('ID: ${staff.id}, Name: ${staff.firstName} ${staff.lastName}, Role: ${staff.role}, Email: ${staff.email}, Phone: ${staff.phoneNumber}');
        }
    }   

    void _addNewStaff() {
        print('\n' + '=' * 60);
        print('ADD NEW STAFF MEMBER'.padLeft(35));
        print('=' * 60);

        stdout.write('Enter Staff ID: ');
        String id = stdin.readLineSync() ?? '';

        stdout.write('Enter First Name: ');
        String firstName = stdin.readLineSync() ?? '';

        stdout.write('Enter Last Name: ');
        String lastName = stdin.readLineSync() ?? '';

        stdout.write('Enter Email: ');
        String email = stdin.readLineSync() ?? '';

        stdout.write('Enter Phone Number: ');
        String phoneNumber = stdin.readLineSync() ?? '';

        stdout.write('Enter Date of Birth (YYYY-MM-DD): ');
        String dobInput = stdin.readLineSync() ?? '';
        DateTime dateOfBirth;
        try {
            dateOfBirth = DateTime.parse(dobInput);
        } catch (e) {
            print('Invalid date format. Using current date.');
            dateOfBirth = DateTime.now();
        }

        stdout.write('Enter Role (Doctor/Nurse): ');
        String roleInput = stdin.readLineSync() ?? '';
        Role role = roleInput.toLowerCase() == 'doctor' ? Role.Doctor : Role.Nurse;

        // If Doctor, ask for specialization
        if (role == Role.Doctor) {
            DoctorSpecialization specialization = _selectSpecialization();
            
            admin.staffs.add(
                Doctor(
                    id: id,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phoneNumber: phoneNumber,
                    dateOfBirth: dateOfBirth,
                    specialization: specialization,
                    patientsPerDay: 0,
                    bonusPerPatient: 0,
                )
            );
        } else {
            admin.staffs.add(
                Nurse(
                    id: id,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phoneNumber: phoneNumber,
                    dateOfBirth: dateOfBirth,
                )
            );
        }

        print('Staff member $firstName $lastName added successfully.');
    }

    DoctorSpecialization _selectSpecialization() {
        print('\n' + '=' * 60);
        print('SELECT SPECIALIZATION'.padLeft(35));
        print('=' * 60);
        print('1. General Physician');
        print('2. Cardiologist');
        print('3. Pediatrician');
        print('4. Surgeon');
        print('5. Dermatologist');
        print('=' * 60);
        
        Map<String, DoctorSpecialization> specializations = {
            '1': DoctorSpecialization.generalPhysician,
            '2': DoctorSpecialization.cardiologist,
            '3': DoctorSpecialization.pediatrician,
            '4': DoctorSpecialization.surgeon,
            '5': DoctorSpecialization.dermatologist,
        };

        while (true) {
            stdout.write('Enter your choice (1-5): ');
            String? choice = stdin.readLineSync();
            
            if (specializations.containsKey(choice)) {
                return specializations[choice]!;
            } else {
                print('Invalid choice! Please select a number between 1 and 5.');
            }
        }
    }

    void _removeStaff() {
        print('\n' + '=' * 60);
        print('REMOVE STAFF MEMBER'.padLeft(35));
        print('=' * 60);

        stdout.write('Enter Staff ID to remove: ');
        String id = stdin.readLineSync() ?? '';

        bool success = admin.deleteAccount(id);
        if (!success) {
            print('Failed to remove staff member with ID $id.');
        }
    }

    void _updateStaffInformation() {
        print('\n' + '=' * 60);
        print('UPDATE STAFF INFORMATION'.padLeft(35));
        print('=' * 60);

        stdout.write('Enter Staff ID to update: ');
        String id = stdin.readLineSync() ?? '';

        List<Staff> staffs = admin.getStaff();
        int staffIndex = -1;
        Staff? staffToUpdate;
        
        for (int i = 0; i < staffs.length; i++) {
            if (staffs[i].id == id) {
                staffToUpdate = staffs[i];
                staffIndex = i;
                break;
            }
        }

        if (staffToUpdate == null) {
            print('No staff member found with ID $id.');
            return;
        }

        // Display update submenu
        while (true) {
            print('\n' + '=' * 60);
            print('UPDATE OPTIONS FOR ${staffToUpdate?.firstName} ${staffToUpdate?.lastName}'.padLeft(40));
                print('=' * 60);
                print('1. Update Profile (Name & Date of Birth)');
            print('2. Update Contact Information (Email & Phone)');
            print('0. Back to Main Menu');
            print('=' * 60);
            stdout.write('Enter your choice (0-2): ');
            
            String? choice = stdin.readLineSync();

            switch (choice) {
                case '1':
                    staffToUpdate = _updateProfile(staffToUpdate!, staffIndex);
                    break;
                case '2':
                    staffToUpdate = _updateContactInfo(staffToUpdate!, staffIndex);
                    break;
                case '0':
                    return;
                default:
                    print('Invalid choice. Please try again.');
            }
        }
    }

    Staff _updateProfile(Staff staff, int index) {
        print('\n' + '=' * 60);
        print('UPDATE PROFILE'.padLeft(35));
        print('=' * 60);

        stdout.write('Enter new First Name (current: ${staff.firstName}, press Enter to keep): ');
        String? firstNameInput = stdin.readLineSync();
        String firstName = (firstNameInput?.isNotEmpty ?? false) ? firstNameInput! : staff.firstName;

        stdout.write('Enter new Last Name (current: ${staff.lastName}, press Enter to keep): ');
        String? lastNameInput = stdin.readLineSync();
        String lastName = (lastNameInput?.isNotEmpty ?? false) ? lastNameInput! : staff.lastName;

        stdout.write('Enter new Date of Birth - YYYY-MM-DD (current: ${staff.dateOfBirth.toString().split(' ')[0]}, press Enter to keep): ');
        String? dobInput = stdin.readLineSync();
        DateTime dateOfBirth = staff.dateOfBirth;
        
        if (dobInput?.isNotEmpty ?? false) {
            try {
                dateOfBirth = DateTime.parse(dobInput!);
            } catch (e) {
                print('Invalid date format. Keeping current date.');
            }
        }

        // Create NEW staff object with updated values
        Staff updatedStaff = staff.copyWith(
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
        );

        // Replace old staff with new staff in the list
        admin.getStaff()[index] = updatedStaff;

        print('Profile updated successfully for $firstName $lastName.');
        return updatedStaff;
    }

    Staff _updateContactInfo(Staff staff, int index) {
        print('\n' + '=' * 60);
        print('UPDATE CONTACT INFORMATION'.padLeft(40));
        print('=' * 60);

        stdout.write('Enter new Email (current: ${staff.email}, press Enter to keep): ');
        String? emailInput = stdin.readLineSync();
        String email = (emailInput?.isNotEmpty ?? false) ? emailInput! : staff.email;

        // Validate email
        if (email != staff.email && !email.contains('@')) {
            print('Invalid email format. Keeping current email.');
            email = staff.email;
        }

        stdout.write('Enter new Phone Number (current: ${staff.phoneNumber}, press Enter to keep): ');
        String? phoneInput = stdin.readLineSync();
        String phoneNumber = (phoneInput?.isNotEmpty ?? false) ? phoneInput! : staff.phoneNumber;

        // Create NEW staff object with updated values
        Staff updatedStaff = staff.copyWith(
            email: email,
            phoneNumber: phoneNumber,
        );

        // Replace old staff with new staff in the list
        admin.getStaff()[index] = updatedStaff;

        print('Contact information updated successfully for ${staff.firstName} ${staff.lastName}.');
        return updatedStaff;
    }
}
