import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// RegistrationPage allows a new user to register in the system.
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>(); // Key for the form to validate inputs
  DateTime? _selectedBirthday; // Variable to hold the selected birthday date

  // Controllers for text fields to retrieve input values
  final TextEditingController _studentNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Method to handle user registration
  void _register() async {
    // Validate form fields and perform registration if valid
    if (_formKey.currentState!.validate()) {
      try {
        // Create user with email and password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Store user information in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'studentNumber': _studentNumberController.text,
          'firstName': _firstNameController.text,
          'middleName': _middleNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneNumberController.text,
          'birthday': _selectedBirthday?.toIso8601String(),
          'grade': _gradeController.text,
          'major': _majorController.text,
          'description': _descriptionController.text,
          // Include other fields as necessary
        });

        // Show a Snackbar after successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration Successful'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the login page after showing the Snackbar
        Navigator.of(context).pop(); // ONLY WORK WHEN the LoginPage is the previous page on the stack
      } on FirebaseAuthException catch (e) {
        // Handle registration error and show message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Method to show date picker and select birthday
  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous page
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView to prevent overflow when keyboard appears
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Add padding around the form
          child: Form(
            key: _formKey,
            // Use Form widget to validate input
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TextFormFields for each input field
                // ... Add other input fields ...
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _studentNumberController,
                  decoration: const InputDecoration(labelText: 'Student Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your student number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _middleNameController,
                  decoration: const InputDecoration(labelText: 'Middle Name'),
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                ElevatedButton(
                  onPressed: () => _selectBirthday(context), // Pass the current context here
                  child: Text(_selectedBirthday == null
                      ? 'Select your birthday'
                      : 'Birthday: ${_selectedBirthday!.toLocal()}'.split(' ')[0]),
                ),
                TextFormField(
                  controller: _gradeController,
                  decoration: const InputDecoration(labelText: 'Grade'),
                ),
                TextFormField(
                  controller: _majorController,
                  decoration: const InputDecoration(labelText: 'Major'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
