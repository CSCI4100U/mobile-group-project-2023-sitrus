import 'package:cloud_firestore/cloud_firestore.dart';

// Defines a user model for an application with fields for user details.
class AppUser {
  final String uid;
  late final String studentNumber;
  late final String firstName;
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
  final List<String>? friendList;
  bool isFriend; // Indicates if the user is a friend
  bool isRequested; // Indicates if a friend request has been sent

  // Constructor for creating a new AppUser object with required and optional fields.
  AppUser({
    required this.uid,
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
    this.friendList,
    this.isFriend = false,
    this.isRequested = false,
  });

  // Creates a new AppUser instance from a map of key/value pairs, typically from Firestore.
  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
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
      friendList: data['friendList'] != null ? List<String>.from(data['friendList']) : null,
    );
  }

  // Converts the AppUser instance into a map, which is useful for uploading user data to Firestore.
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
      'friendList': friendList,
    };
  }

  // Generates user initials from first and last name, used for displaying a default avatar.
  String getInitials() {
    return ((firstName.isNotEmpty ? firstName[0] : '') + (lastName.isNotEmpty ? lastName[0] : '')).toUpperCase();
  }

  // Constructs a full name string from the first, middle, and last names.
  String getFullName() {
    return [firstName, if (middleName?.isNotEmpty ?? false) middleName, lastName].join(" ").trim();
  }

  // Override the toString method to provide a better representation of the object
  @override
  String toString() {
    return 'AppUser(uid: $uid, studentNumber: $studentNumber, firstName: $firstName, middleName: $middleName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, birthday: $birthday, grade: $grade, status: $status, major: $major, description: $description, icon: $icon, friendList: $friendList, isFriend: $isFriend, isRequested: $isRequested)';
  }
}
