import 'package:elective/src/widgets/components.dart';
import 'package:flutter/material.dart';

class AuthWidget {
  static Widget welcomeBack() {
    return Text(
      'Welcome Back',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[900],
      ),
    );
  }

  static Widget loginToAccount() {
    return Text(
      'Log in to your account',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: Colors.blueGrey[600],
      ),
    );
  }

  static Widget createAccount() {
    return Text(
      'Create Account',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[900],
      ),
    );
  }

  static Widget signUpToAccount() {
    return Text(
      'Sign up to create a new account',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: Colors.blueGrey[600],
      ),
    );
  }

  static TextFormField registerNo(TextEditingController controller,{ TextInputAction textInputAction = TextInputAction.next}) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: 'Register Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your register number';
        }
        // Check if the register number contains only digits (no alphabets or special characters)
        if (!RegExp(r'^\d+$').hasMatch(value)) {
          return 'Please enter a valid register number with only numbers';
        }
        return null; // Return null if validation is successful
      },
    );
  }

  static TextFormField email(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email Address',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email address';
        }
        // Check if the email contains '@kcgcollege.com'
        if (!value.endsWith('@kcgcollege.com')) {
          return 'Please enter a valid email address with @kcgcollege.com';
        }
        return null; // Return null if validation is successful
      },
    );
  }

  static TextFormField name(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        // prefixIcon:
        //     Icon(Icons.account_circle_outlined, color: Colors.blueGrey[300]),
        labelText: 'Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: TextInputType.name,
    );
  }

  static Widget department({
    required String? value,
    required void Function(String?)? onChanged,
    required List<String> items,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Department',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: null,
          isExpanded: true,
          hint: Components.openSansText(
              text: 'Select a Department', color: Colors.blueGrey[300]),
          value: value,
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  // static TextFormField password(TextEditingController controller) {
  //   return TextFormField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       prefixIcon: Icon(Icons.lock_outline, color: Colors.blueGrey[300]),
  //       labelText: 'Password',
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8.0),
  //       ),
  //     ),
  //     obscureText: true,
  //   );
  // }

  static ElevatedButton signIn(void Function() onPressed,
      {String text = "Continue"}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Components.openSansText(
          text: text, fontSize: 16, color: Colors.white),
    );
  }
}
