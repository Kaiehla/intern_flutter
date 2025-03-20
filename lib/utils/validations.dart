import 'package:flutter/services.dart';

abstract class Validations {
  // Name Validation: Allows letters, numbers, spaces, hyphens, and apostrophes (e.g., Anne-Marie O’Connor, Yours Truly 88)
  static final List<String> strictDenyPatterns = [
    r"^ ", // No space at the start
    r"^[-'’]", // No hyphen/apostrophe at the start
    r" {2,}", // No double spaces
    r"--", // No double hyphens
    r"''", // No double apostrophes
    r'[!@#\$%^&*()_+={}:;<>?/.\",\|\[\]\\`~]', // No special characters
  ];

  static final List<String> generalDenyPatterns = [
    r"^ ", // No space at the start
    r"^[-'’]", // No hyphen/apostrophe at the start
    r" {2,}", // No double spaces
    r"--", // No double hyphens
    r"''", // No double apostrophes
    r'[!@#\$%^&*()_+={}:;<>?/.\",\|\[\]\\`~]', // No special characters
  ];

  static final List<String> generalNoNumbersDenyPatterns = [
    r"^ ", // No space at the start
    r"^[-'’]", // No hyphen/apostrophe at the start
    r" {2,}", // No double spaces
    r"--", // No double hyphens
    r"''", // No double apostrophes
    r'[!@#\$%^&*()_+={}:;<>?/.\",\|\[\]\\`~]', // No special characters
    r"\d", // No numbers
  ];



  // Birthday Validation: No future dates
  static String? validateBirthday(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Birthday is required';
    }

    DateTime? birthday = DateTime.tryParse(value.trim());
    if (birthday == null) {
      return 'Invalid date format (YYYY-MM-DD)';
    }

    if (birthday.isAfter(DateTime.now())) {
      return 'Future dates are not allowed';
    }

    return null;
  }

  // ✅ Email Validation
  static final RegExp emailRegExp =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  // ✅ Phone Number Validation (Digits only, min 10, max 15)
  static final RegExp phoneRegExp = RegExp(r"^\d{10,15}$");

  // ✅ Hours Required Validation (Positive integers only)
  static final RegExp hoursRegExp = RegExp(r"^[1-9]\d*$");

  // ✅ Generic Validator Function (Trims input before validation)
  static String? validateField(
      String? value, RegExp pattern, String errorMessage) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    if (!pattern.hasMatch(value.trim())) {
      return errorMessage;
    }

    return null;
  }
}
