import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String studentNumber;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final DateTime? birthday;
  final String? grade;
  final String status;
  final String? major;
  final String? description;
  final String? icon;

  AppUser({
    required this.id,
    required this.studentNumber,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.birthday,
    this.grade,
    required this.status,
    this.major,
    this.description,
    this.icon,
  });

  // Helper method to create a User object from a map
  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    return AppUser(
      id: documentId,
      studentNumber: data['studentNumber'] ?? '',
      firstName: data['firstName'] ?? '',
      middleName: data['middleName'],
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'],
      birthday: data['birthday'] is Timestamp ? (data['birthday'] as Timestamp).toDate() : null,
      grade: data['grade'],
      status: data['status'] ?? 'Offline',
      major: data['major'],
      description: data['description'],
      icon: data['icon'],
    );
  }

  // Helper method to convert a User object to a map
  Map<String, dynamic> toMap() {
    return {
      'studentNumber': studentNumber,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthday': birthday != null ? Timestamp.fromDate(birthday!) : null,
      'grade': grade,
      'status': status,
      'major': major,
      'description': description,
      'icon': icon,
    };
  }


  // Method to generate an initial-based avatar if no icon is provided
  String getInitials() {
    return ((firstName.isNotEmpty ? firstName[0] : '') + (lastName.isNotEmpty ? lastName[0] : '')).toUpperCase();
  }
}
