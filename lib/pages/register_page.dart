import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intern_flutter/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gif/gif.dart';
import 'package:intern_flutter/models/internModel.dart';
import 'package:intern_flutter/pages/profile_page.dart';
import 'package:intern_flutter/utils/shared_preferences_service.dart';
import 'package:intern_flutter/utils/validations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intern_flutter/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intern_flutter/utils/globals.dart';

// Controllers para makuha yung value ng textfields
final TextEditingController _pronounsController = TextEditingController();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _birthdayController = TextEditingController();
final TextEditingController _schoolController = TextEditingController();
final TextEditingController _companyController = TextEditingController();
final TextEditingController _positionController = TextEditingController();
final TextEditingController _startDateController = TextEditingController();
final TextEditingController _hoursRequiredController = TextEditingController();

// Validation states para sa textfields
String? _selectedPronoun = "He/Him";
bool _validateName = false;
bool _validateBirthday = false;
bool _validateSchool = false;
bool _validateCompany = false;
bool _validatePosition = false;
bool _validateStartDate = false;
bool _validateHoursRequired = false;
String internId = "";
bool _isInternRegistered = false;

class register_page extends StatelessWidget {
  const register_page({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = "Create Intern ID";

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.manropeTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 42,
            child: Gif(
              image: AssetImage("logo.gif"),
              autostart: Autostart.loop,
            ),
          ),
          centerTitle: true,
        ),
        // LayoutBuilder para magexpand yung content ng page sa buong screen height
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFieldSection(),
                      // ButtonFieldSection(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        // drawer: Drawer(
        //   child: ListView(
        //     children: [DrwHeader(), DrwListView()],
        //   ),
        // ),
      ),
    );
  }
}

// need gawing stateful para magreflect yung tinatype sa textfields sa ID Card
class TextFieldSection extends StatefulWidget {
  const TextFieldSection({super.key});

  @override
  _TextFieldSectionState createState() => _TextFieldSectionState();
}

class _TextFieldSectionState extends State<TextFieldSection> {
  DateTime? _selectedBirthday;
  DateTime? _selectedStartDate;

  void _pickBirthday(BuildContext context) async {
    DateTime? pickedBirthday = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedBirthday != null) {
      final DateTime today = DateTime.now();
      final int age = today.year - pickedBirthday.year;
      if (age < 16 ||
          (age == 16 &&
              today.isBefore(pickedBirthday.add(Duration(days: age * 365))))) {
        setState(() {
          _validateBirthday = true;
          _birthdayController.text = "";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("You must be at least 16 years old to use HoursTruly")),
        );
      } else {
        setState(() {
          _selectedBirthday = pickedBirthday;
          _birthdayController.text =
              "${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}";
          _validateBirthday = false;
        });
      }
    }
  }

  void _pickStartDate(BuildContext context) async {
    DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedStartDate != null) {
      setState(() {
        _selectedStartDate = pickedStartDate;
        _startDateController.text =
            "${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}";
        _validateStartDate = false;
      });
    }
  }

  // implement a list of user model
  List<internModel> internList = [];

  // get all interns from firebase
  void getAllInterns() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('interns').get();
      List<internModel> interns = [];
      for (var doc in querySnapshot.docs) {
        var internData = doc.data() as Map<String, dynamic>;
        // Convert Timestamp fields to DateTime
        if (internData['birthday'] is Timestamp) {
          internData['birthday'] =
              (internData['birthday'] as Timestamp).toDate();
        }
        if (internData['startDate'] is Timestamp) {
          internData['startDate'] =
              (internData['startDate'] as Timestamp).toDate();
        }
        interns.add(internModel(
          id: doc.id,
          pronouns: internData['pronouns'] ?? 'Not specified',
          name: internData['name'] ?? 'Unknown',
          birthday: internData['birthday'] ?? DateTime(1900, 1, 1),
          school: internData['school'] ?? 'Unknown',
          company: internData['company'] ?? 'Unknown',
          position: internData['position'] ?? 'Unknown',
          startDate: internData['startDate'] ?? DateTime(1900, 1, 1),
          hoursRequired: internData['hoursRequired'] ?? 0,
        ));
      }
      setState(() {
        internList = interns;
      });
    } catch (e) {
      print("Error fetching interns: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    checkInternRegistered();
  }

  // validations
  bool validateIDFields() {
    bool isValid = false;

    setState(() {
      _selectedPronoun == null;
      _validateName = _nameController.text.isEmpty;
      _validateBirthday = _birthdayController.text.isEmpty;
      _validateSchool = _schoolController.text.isEmpty;
      _validateCompany = _companyController.text.isEmpty;
      _validatePosition = _positionController.text.isEmpty;
      _validateStartDate = _selectedStartDate == null;
      _validateHoursRequired = _hoursRequiredController.text.isEmpty;

      // if tama na lahat ng fields, proceed to main page then clear all fields
      if (!_validateName &&
          !_validateBirthday &&
          !_validateSchool &&
          !_validateCompany &&
          !_validatePosition &&
          !_validateStartDate &&
          !_validateHoursRequired) {
        isValid = true;
      }
    });
    return isValid;
  }

  // add to database
  void addIntern() async {
    if (!validateIDFields()) {
      return;
    }
    try {
      // Save to Firebase and get the document reference
      await FirebaseFirestore.instance.collection('interns').add({
        'pronouns': _selectedPronoun,
        'name': _nameController.text,
        'birthday': _selectedBirthday,
        'school': _schoolController.text,
        'company': _companyController.text,
        'position': _positionController.text,
        'startDate': _selectedStartDate,
        'hoursRequired': int.parse(_hoursRequiredController.text),
      }).then((docRef) {
        // Use the document ID from the added document
        // internList.add(internModel(
        //   id: docRef.id,
        //   // Assign the generated document ID
        //   pronouns: _selectedPronoun!,
        //   name: _nameController.text,
        //   birthday: _selectedBirthday!,
        //   school: _schoolController.text,
        //   company: _companyController.text,
        //   position: _positionController.text,
        //   startDate: _selectedStartDate!,
        //   hoursRequired: int.parse(_hoursRequiredController.text),
        // ));
        // // set the intern id to globals
        // globals.internId = docRef.id;
        // print("Intern added successfully with ID: ${docRef.id}");

        // use sharedprefs to store the register intern across all pages after being registered successfully since only 1 intern per device
        prefsService.saveInternModel(internModel(
          id: docRef.id,
          pronouns: _selectedPronoun!,
          name: _nameController.text,
          birthday: _selectedBirthday!,
          school: _schoolController.text,
          company: _companyController.text,
          position: _positionController.text,
          startDate: _selectedStartDate!,
          hoursRequired: int.parse(_hoursRequiredController.text),
        ));
        print("Intern saved to SharedPreferences: ${docRef.id}");

        //redirect to main
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
        );
      });

      // Clear all fields
      _selectedPronoun = "He/Him";
      _nameController.clear();
      _selectedBirthday = null;
      _birthdayController.clear();
      _schoolController.clear();
      _companyController.clear();
      _positionController.clear();
      _selectedStartDate = null;
      _startDateController.clear();
      _hoursRequiredController.clear();
    } catch (e) {
      print("Error adding intern: $e");
    }
  }

  // get data from data
  void getInternInfoById(String documentId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('interns')
          .doc(documentId)
          .get();

      if (doc.exists) {
        var internData = doc.data() as Map<String, dynamic>;
        setState(() {
          _selectedPronoun = internData['pronouns'];
          _nameController.text = internData['name'];
          _selectedBirthday = internData['birthday'].toDate();
          _birthdayController.text =
              "${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}";
          _schoolController.text = internData['school'];
          _companyController.text = internData['company'];
          _positionController.text = internData['position'];
          _selectedStartDate = internData['startDate'].toDate();
          _startDateController.text =
              "${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}";
          _hoursRequiredController.text =
              internData['hoursRequired'].toString();
          globals.internId = documentId; // Store the document ID for later use
        });
      } else {
        print("Document with ID $documentId does not exist.");
      }
    } catch (e) {
      print("Error fetching intern info: $e");
    }
  }

  // void updateUser(String internId) async {
  //   // Validate fields
  //   if (!validateIDFields()) {
  //     return;
  //   }
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('interns')
  //         .doc(internId)
  //         .update({
  //       'name': _nameController.text,
  //       'pronouns': _selectedPronoun!,
  //       'birthday': _selectedBirthday!,
  //       'school': _schoolController.text,
  //       'company': _companyController.text,
  //       'position': _positionController.text,
  //       'startDate': _selectedStartDate!,
  //       'hoursRequired': int.parse(_hoursRequiredController.text),
  //     });
  //     print("Intern updated successfully.");
  //   } catch (e) {
  //     print("An error occurred while updating the intern: $e");
  //   }
  // }

// update the intern data by id

  void updateInternById(String documentId) async {
    // Validate fields
    if (!validateIDFields()) {
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('interns')
          .doc(documentId)
          .update({
        'name': _nameController.text,
        'pronouns': _selectedPronoun!,
        'birthday': _selectedBirthday!,
        'school': _schoolController.text,
        'company': _companyController.text,
        'position': _positionController.text,
        'startDate': _selectedStartDate!,
        'hoursRequired': int.parse(_hoursRequiredController.text),
      });
      print("Intern Updated Successfully with ID: ${documentId}");
    } catch (e) {
      print("Error fetching intern info: $e");
    }
  }

// delete function
//   void deleteUser() {
//     // int searchedIndex = searchIndex(_nameController.text);
//     // internList.removeAt(searchedIndex);
//
//     //delete to firebase database by name
//     FirebaseFirestore.instance
//         .collection('interns')
//         .where('name', isEqualTo: _nameController.text)
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         FirebaseFirestore.instance
//             .collection('interns')
//             .doc(doc.id)
//             .delete()
//             .then((value) {
//           print("User Deleted");
//         }).catchError((error) {
//           print("Failed to delete user: $error");
//         });
//       });
//     });
//   }

  // delete by intern id
  void deleteInternById(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('interns')
          .doc(documentId)
          .delete();
      print("Intern deleted successfully.");
    } catch (e) {
      print("Error deleting intern: $e");
    }
  }

  // check if there is an intern already registered to prevent multiple registrations on 1 phone
  void checkInternRegistered() async {
    String? internData = await prefsService.getInternData('id');
    if (internData != null) {
      setState(() {
        _isInternRegistered = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An intern is already registered."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: HeaderLabelSection("Create an Intern ID"),
        ),
        InternIDCard(
          name: _nameController.text,
          birthday: _birthdayController.text,
          school: _schoolController.text,
          company: _companyController.text,
          position: _positionController.text,
        ),
        SizedBox(height: 16),

        // Form Inputs
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pronouns
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: _selectedPronoun,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: "Pronouns",
                  border: OutlineInputBorder(),
                ),
                items: ["He/Him", "She/Her", "They/Them"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPronoun = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a pronoun';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 16),

            // Name
            Expanded(
              flex: 2,
              child: TextField(
                controller: _nameController,
                maxLength: 25,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                  errorText: _validateName ? "Enter a valid Name" : null,
                ),
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(50),
                  ...Validations.strictDenyPatterns.map((pattern) =>
                      FilteringTextInputFormatter.deny(RegExp(pattern))),
                  // Apply deny filters
                ],
                onChanged: (text) {
                  setState(() {
                    _validateName = false;
                  });
                },
              ),
            ),
          ],
        ),

        // Birthday
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: TextField(
            controller: _birthdayController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Birthday",
              hintText: _selectedBirthday != null
                  ? "${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}"
                  : "dd/mm/yyyy",
              border: OutlineInputBorder(),
              floatingLabelBehavior: _selectedBirthday != null
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.auto,
              suffixIcon: IconButton(
                icon: Icon(Icons.cake_rounded),
                onPressed: () => _pickBirthday(context),
              ),
              errorText: _validateBirthday ? "Enter a valid Birthday" : null,
            ),
            onChanged: (text) {
              setState(() {
                _validateBirthday = false;
              });
            },
          ),
        ),

        // School
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: TextField(
            controller: _schoolController,
            maxLength: 30,
            decoration: InputDecoration(
              labelText: "School",
              border: OutlineInputBorder(),
              errorText: _validateSchool ? "Enter a valid School" : null,
            ),
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(30),
              ...Validations.generalNoNumbersDenyPatterns.map((pattern) =>
                  FilteringTextInputFormatter.deny(RegExp(pattern))),
              // Apply deny filters
            ],
            onChanged: (text) {
              setState(() {
                _validateSchool = false;
              });
            },
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant,
          thickness: 1,
        ),

        // Internship Company
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: TextField(
            controller: _companyController,
            maxLength: 30,
            decoration: InputDecoration(
              labelText: "Internship Company",
              border: OutlineInputBorder(),
              errorText: _validateCompany ? "Enter a valid Company" : null,
            ),
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(30),
              ...Validations.generalDenyPatterns.map((pattern) =>
                  FilteringTextInputFormatter.deny(RegExp(pattern))),
              // Apply deny filters
            ],
            onChanged: (text) {
              setState(() {
                _validateCompany = false;
              });
            },
          ),
        ),

        // Intern Position
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: TextField(
            controller: _positionController,
            maxLength: 30,
            decoration: InputDecoration(
              labelText: "Intern Position",
              border: OutlineInputBorder(),
              errorText: _validatePosition ? "Enter a valid Position" : null,
            ),
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(30),
              ...Validations.generalDenyPatterns.map((pattern) =>
                  FilteringTextInputFormatter.deny(RegExp(pattern))),
              // Apply deny filters
            ],
            onChanged: (text) {
              setState(() {
                _validatePosition = false;
              });
            },
          ),
        ),

        // Start Date & Hours Required
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: "Start Date",
                    hintText: _selectedStartDate != null
                        ? "${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}"
                        : "dd/mm/yyyy",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: _selectedStartDate != null
                        ? FloatingLabelBehavior.always
                        : FloatingLabelBehavior.auto,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.today),
                      onPressed: () => _pickStartDate(context),
                    ),
                    errorText:
                        _validateStartDate ? "Enter a valid start date" : null,
                  ),
                  onChanged: (text) {
                    setState(() {
                      _validateStartDate = false;
                    });
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _hoursRequiredController,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: "Hours Required",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.timer_outlined),
                    errorText: _validateHoursRequired
                        ? "Enter hours in numbers"
                        : null,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (text) {
                    // so it doesn't accept 0, 00, or 01 as inputs
                    if (text == "0" ||
                        text == "00" ||
                        (text.startsWith('0') && text.length > 1)) {
                      _hoursRequiredController.clear();
                      setState(() {
                        _validateHoursRequired = true;
                      });
                    } else {
                      setState(() {
                        _validateHoursRequired = false;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        // List of Interns
        // Padding(
        //     padding: EdgeInsets.only(top: 10),
        //     child: ListView.builder(
        //       shrinkWrap: true,
        //       itemCount: internList.length,
        //       itemBuilder: (context, index) {
        //         return ListTile(
        //           title: Text(
        //               '${internList[index].name} (${internList[index].pronouns})',
        //               style: TextStyle(fontWeight: FontWeight.bold)),
        //           subtitle: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(internList[index].birthday.toLocal().toString()),
        //               Text(internList[index].school),
        //               Text(internList[index].company),
        //               Text(internList[index].position),
        //               Text(internList[index].startDate.toLocal().toString()),
        //               Text(internList[index].hoursRequired.toString()),
        //             ],
        //           ),
        //           onTap: () {
        //             // Handle tap to get intern info by document id
        //             getInternInfoById(internList[index].id);
        //           },
        //         );
        //       },
        //     )),

        SizedBox(height: 16),

        // Button
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _isInternRegistered
                      ? null
                      : () {
                    setState(() {
                      addIntern();
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        _isInternRegistered ? Colors.grey : Theme.of(context).colorScheme.inversePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: FilledButton(
              //     onPressed: globals.internId.isEmpty
              //         ? null
              //         : () {
              //             setState(() {
              //               updateInternById(globals.internId);
              //             });
              //           },
              //     style: FilledButton.styleFrom(
              //       backgroundColor: globals.internId.isEmpty
              //           ? Colors.grey
              //           : Theme.of(context).colorScheme.inversePrimary,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         side: BorderSide(color: Colors.black, width: 2),
              //       ),
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(vertical: 12),
              //       child: Text(
              //         "Update",
              //         style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold,
              //           color: globals.internId.isEmpty
              //               ? Colors.black38
              //               : Theme.of(context).colorScheme.onPrimaryContainer,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Expanded(
              //   child: FilledButton(
              //     onPressed: globals.internId.isEmpty
              //         ? null
              //         : () {
              //             setState(() {
              //               deleteInternById(globals.internId);
              //             });
              //           },
              //     style: FilledButton.styleFrom(
              //       backgroundColor: globals.internId.isEmpty
              //           ? Colors.grey
              //           : Theme.of(context).colorScheme.inversePrimary,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         side: BorderSide(color: Colors.black, width: 2),
              //       ),
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(vertical: 12),
              //       child: Text(
              //         "Reset",
              //         style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold,
              //           color: globals.internId.isEmpty
              //               ? Colors.black38
              //               : Theme.of(context).colorScheme.onPrimaryContainer,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

// Label
class HeaderLabelSection extends StatelessWidget {
  final String label;

  const HeaderLabelSection(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Intern Id Card
class InternIDCard extends StatelessWidget {
  final String name;
  final String birthday;
  final String school;
  final String company;
  final String position;

  // Text Styles for ID Card Details - para isahan lang, class ang peg tatawagin mo nolong
  static const TextStyle idInputStyle = TextStyle(fontSize: 11);
  static const TextStyle idLabelStyle =
      TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

  // Constructor - para maaccess yung mga values ng textfields sa taas
  const InternIDCard({
    required this.name,
    required this.birthday,
    required this.school,
    required this.company,
    required this.position,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
            // double infinity para magexpand yung card sa buong screen width responsive ganern
            width: double.infinity,
            child: Column(
              children: [
                //ID Card Header - Intern & Identification Card No.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Intern",
                        style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "IDENTIFICATION CARD\nNO.213123812\n>",
                        style: TextStyle(fontSize: 12, height: 0.8),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),

                // ID Card Body
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                    ),

                    // Gap
                    SizedBox(width: 14),

                    // ID Details
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          // mainaxis - parang justify  (horizontal) css lang
                          // cross axis - parang align (vertical) css lang
                          // Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Name", style: idLabelStyle)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    name.toUpperCase(),
                                    style: idInputStyle,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          DottedLine(),

                          // Birthday
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Birthday", style: idLabelStyle)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    birthday,
                                    style: idInputStyle,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          DottedLine(),

                          // School
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("School", style: idLabelStyle)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    school.toUpperCase(),
                                    style: idInputStyle,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          DottedLine(),

                          // Company
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Company", style: idLabelStyle)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    company.toUpperCase(),
                                    style: idInputStyle,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          DottedLine(),

                          // Position
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Position", style: idLabelStyle)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    position.toUpperCase(),
                                    style: idInputStyle,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          DottedLine(),

                          Text(
                            "This card certifies the bearer as an Intern",
                            style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class DottedLine extends StatelessWidget {
  final double padding;
  final Color color;

  const DottedLine({this.padding = 1, this.color = Colors.black, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 1.0;
        final dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return Padding(
              padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
              // Adjust the padding value as needed
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

// class ButtonFieldSection extends StatelessWidget {
//   const ButtonFieldSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: FilledButton(
//               onPressed: _buttonDisable
//                   ? null
//                   : () => Navigator.push(
//                       context, MaterialPageRoute(builder: (context) => MyApp())),
//               style: FilledButton.styleFrom(
//                 backgroundColor: _buttonDisable
//                     ? Colors.grey
//                     : Theme.of(context).colorScheme.inversePrimary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   side: BorderSide(color: Colors.black, width: 2),
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 12),
//                 child: Text(
//                   "Save",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: _buttonDisable
//                         ? Colors.black38
//                         : Theme.of(context).colorScheme.onPrimaryContainer,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
