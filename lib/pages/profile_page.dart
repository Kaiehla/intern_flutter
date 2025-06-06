import 'package:flutter/material.dart';
import 'package:intern_flutter/main.dart';
import 'package:intern_flutter/models/internModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gif/gif.dart';
import 'package:intern_flutter/pages/register_page.dart';
import 'package:intern_flutter/utils/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intern_flutter/utils/validations.dart';


class profile_page extends StatefulWidget {
  const profile_page({super.key});

  @override
  State<profile_page> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<profile_page> {
  internModel? internData;

  @override
  void initState() {
    super.initState();
    fetchInternData();
  }

  late BuildContext scaffoldContext;

  void fetchInternData() async {
    String? internId = await prefsService.getInternData('id');
    if (internId != null) {
      getInternInfoById(internId);
    } else {
      print("No intern ID found.");
    }
  }

  void getInternInfoById(String documentId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('interns')
          .doc(documentId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          internData = internModel(
            id: documentId,
            name: data['name'],
            birthday: data['birthday'].toDate(),
            school: data['school'],
            company: data['company'],
            position: data['position'],
            startDate: data['startDate'].toDate(),
            hoursRequired: data['hoursRequired'],
            pronouns: data['pronouns'],
          );
        });
      } else {
        print("Document with ID $documentId does not exist.");
      }
    } catch (e) {
      print("Error fetching intern info: $e");
    }
  }

  //edit intern id
  void editInternID() {
    if (internData == null) return;

    final nameController = TextEditingController(text: internData!.name);
    final birthday = internData!.birthday;
    final schoolController = TextEditingController(text: internData!.school);
    final companyController = TextEditingController(text: internData!.company);
    final positionController = TextEditingController(text: internData!.position);
    DateTime selectedBirthday = birthday;

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            title: const Text('Edit Intern ID'),
            content: SizedBox(
              width: 400,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Name
                          TextFormField(
                            controller: nameController,
                            maxLength: 25,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(50),
                              ...Validations.strictDenyPatterns.map((pattern) =>
                                  FilteringTextInputFormatter.deny(RegExp(pattern))),
                              // Apply deny filters
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Birthday
                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedBirthday,
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now().subtract(const Duration(days: 16 * 365)),
                              );
                              if (picked != null) {
                                setState(() => selectedBirthday = picked);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Birthday',
                                border: OutlineInputBorder(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${selectedBirthday.month}/${selectedBirthday.day}/${selectedBirthday.year}",
                                  ),
                                  const Icon(Icons.calendar_today, size: 16),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // School
                          TextFormField(
                            controller: schoolController,
                            maxLength: 30,
                            decoration: const InputDecoration(
                              labelText: 'School',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(30),
                              ...Validations.generalNoNumbersDenyPatterns.map((pattern) =>
                                  FilteringTextInputFormatter.deny(RegExp(pattern))),
                              // Apply deny filters
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'School is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Company
                          TextFormField(
                            controller: companyController,
                            maxLength: 30,
                            decoration: const InputDecoration(
                              labelText: 'Company',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(30),
                              ...Validations.generalDenyPatterns.map((pattern) =>
                                  FilteringTextInputFormatter.deny(RegExp(pattern))),
                              // Apply deny filters
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Company is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Position
                          TextFormField(
                            controller: positionController,
                            maxLength: 30,
                            decoration: const InputDecoration(
                              labelText: 'Position',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(30),
                              ...Validations.generalDenyPatterns.map((pattern) =>
                                  FilteringTextInputFormatter.deny(RegExp(pattern))),
                              // Apply deny filters
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Position is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('interns')
                          .doc(internData!.id)
                          .update({
                        'name': nameController.text.trim(),
                        'birthday': Timestamp.fromDate(selectedBirthday),
                        'school': schoolController.text.trim(),
                        'company': companyController.text.trim(),
                        'position': positionController.text.trim(),
                      });

                      setState(() {
                        internData = internData!.copyWith(
                          name: nameController.text.trim(),
                          birthday: selectedBirthday,
                          school: schoolController.text.trim(),
                          company: companyController.text.trim(),
                          position: positionController.text.trim(),
                        );
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Details updated.")),
                      );
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to update.")),
                      );
                    }
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  //edit internship hours
  void editInternHours() {
    if (internData == null) return;

    TextEditingController hoursController = TextEditingController(
      text: internData!.hoursRequired.toString(),
    );

    bool _validateHoursRequired = false;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            title: const Text('Edit Internship Hours'),
            content: SizedBox(
              width: 400,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: hoursController,
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
                            hoursController.clear();
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
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final String newHoursStr = hoursController.text.trim();
                  final int? newHours = int.tryParse(newHoursStr);

                  if (newHours != null && internData != null) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('interns')
                          .doc(internData!.id)
                          .update({
                        'hoursRequired': newHours,
                      });

                      setState(() {
                        internData = internData!.copyWith(
                          hoursRequired: newHours,
                        );
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Details updated.")),
                      );
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to update.")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter valid hours.")),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  //edit start date
  void editInternStartDate() {
    if (internData == null) return;

    DateTime selectedStartDate = internData!.startDate;
    final _startDateController = TextEditingController(
      text: "${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}",
    );

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            title: const Text('Edit Internship Start Date'),
            content: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: _startDateController,
                        decoration: InputDecoration(
                          labelText: "Start Date",
                          hintText: "dd/mm/yyyy",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.today),
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedStartDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                selectedStartDate = pickedDate;
                                _startDateController.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (internData != null) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('interns')
                          .doc(internData!.id)
                          .update({
                        'startDate': Timestamp.fromDate(selectedStartDate),
                      });

                      setState(() {
                        internData = internData!.copyWith(
                          startDate: selectedStartDate,
                        );
                      });

                      Navigator.pop(context);
                    } catch (e) {
                      Navigator.pop(context);
                    }
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  //show report a problem
  void showReportAProblem() {
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogHeight = screenHeight * 0.6;

    TextEditingController issueController = TextEditingController();

    // Save the parent context (outside the dialog)
    final parentContext = context;

    showDialog(
      context: parentContext,
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: dialogHeight),
            child: AlertDialog(
              title: const Text('Report a Problem'),
              content: SizedBox(
                width: double.maxFinite,
                child: TextField(
                  controller: issueController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: 'Describe the issue here.',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final issue = issueController.text.trim();
                    if (issue.isNotEmpty && internData != null) {
                      try {
                        await FirebaseFirestore.instance.collection('problemReports').add({
                          'internId': internData!.id,
                          'issue': issue,
                          'timestamp': Timestamp.now(),
                        });

                        Navigator.pop(context); // First close the dialog

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Report submitted."),
                          ),
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Fail to submit report."),
                          ),
                        );
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }

  //show terms and conditions
  void showTermsAndConditions(String text) {
    if (text == 'Terms and Conditions') {
      showDialog(
        context: context,
        builder: (context) {
          final screenHeight = MediaQuery.of(context).size.height;
          final dialogHeight = screenHeight * 0.6;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: dialogHeight,
              ),
              child: AlertDialog(
                title: const Text('Terms and Conditions'),
                content: SingleChildScrollView(
                  child: const Text(
                        'Effective Date: May 8, 2025\n\n'
                        'Welcome to Hours Truly (“App”, “we”, “our”, or “us”). These Terms and Conditions (“Terms”) govern your use of our app, which allows interns, employers, and educational institutions to track internship hours, log progress, and manage internship-related information.\n\n'
                        'By accessing or using Hours Truly Intern Tracker, you agree to be bound by these Terms. If you do not agree, you may not use the app.\n\n'
                        '1. Eligibility\n'
                        'You must be at least 16 years old or have permission from a parent, guardian, or institution to use this App. By using the app, you represent that you meet these requirements.\n\n'
                        '2. App Purpose\n'
                        'Intern Tracker provides the following functionalities:\n'
                        '- Logging internship hours.\n'
                        '- Recording weekly progress reports and tasks.\n'
                        '- Displaying an intern’s position and affiliated company/organization.\n'
                        'The app is designed for personal, educational, and monitoring purposes only.\n\n'
                        '3. User Accounts\n'
                        'To access certain features, users may need to create an account. You are responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account.\n\n'
                        '4. User Responsibilities\n'
                        'You agree to:\n'
                        '- Provide accurate and current information.\n'
                        '- Use the app only for lawful purposes.\n'
                        '- Not upload false, misleading, or inappropriate content.\n\n'
                        '5. Data Collection and Use\n'
                        'We collect and store data such as:\n'
                        '- Intern\'s name, position, and company.\n'
                        '- Logged hours and weekly progress reports.\n'
                        'This data may be used for:\n'
                        '- Progress monitoring.\n'
                        '- Reporting to academic or supervisory institutions.\n'
                        '- Improving app functionality.\n'
                        'See our Privacy Policy for full details on data handling.\n\n'
                        '6. Data Ownership\n'
                        'Users retain ownership of their content. By submitting information, you grant Intern Tracker a non-exclusive, royalty-free license to use that content solely for the operation of the app.\n\n'
                        '7. Account Termination\n'
                        'We reserve the right to suspend or terminate accounts that violate these Terms or misuse the app.\n\n'
                        '8. Intellectual Property\n'
                        'All content, design, and branding on the app, except for user-submitted content, are the property of Intern Tracker and are protected by intellectual property laws.\n\n'
                        '9. Limitation of Liability\n'
                        'Intern Tracker is provided “as is” without warranties of any kind. We are not liable for any indirect, incidental, or consequential damages arising out of your use or inability to use the app.\n\n'
                        '10. Modifications\n'
                        'We may update these Terms at any time. Continued use of the app after changes constitutes your acceptance of the revised Terms.\n\n'
                        '11. Contact\n'
                        'If you have any questions or concerns regarding these Terms, please contact us at:\n'
                        'Email: mail@hourstruly.com\n'
                        'Support: user.support@hourstruly.com',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
                insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = "My Profile";

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
              image: const AssetImage("logo.gif"),
              autostart: Autostart.loop,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(child:
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: internData == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection("My Profile"),
                InternIDCard(
                  name: internData!.name,
                  birthday:
                  "${internData!.birthday.day}/${internData!.birthday.month}/${internData!.birthday.year}",
                  school: internData!.school,
                  company: internData!.company,
                  position: internData!.position,
                ),
                const SizedBox(height: 15),

                // Info Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoCard(
                      title: "Start Date",
                      value:
                      "${internData!.startDate.day}/${internData!.startDate.month}/${internData!.startDate.year}",
                    ),
                    const SizedBox(width: 15),
                    InfoCard(
                      title: "Hours Required",
                      value: internData!.hoursRequired.toString(),
                    ),
                  ],
                ),

                // General Settings
                const SizedBox(height: 16),
                const Text(
                  "General",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GeneralCard(
                        items: [
                          {
                            'icon': Icons.badge_outlined,
                            'text': 'Edit My Intern ID',
                            'onTap': () => editInternID(),
                          },
                          {
                            'icon': Icons.timelapse_rounded,
                            'text': 'Edit Internship Hours',
                            'onTap': () => editInternHours(),
                          },
                          {
                            'icon': Icons.calendar_month_rounded,
                            'text': 'Edit Internship Start Date',
                            'onTap': () => editInternStartDate(),
                          },
                        ],
                      ),
                    ),
                  ],
                ),

                // Settings
                const SizedBox(height: 16),
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SettingsCard(
                        items: [
                          {
                            'icon': Icons.warning_amber_rounded,
                            'text': 'Erase all my progress and data',
                            'onTap': () {
                              EraseDataDialog.showEraseDataDialog(
                                  context);
                            },
                          },
                          {
                            'icon': Icons.bug_report_outlined,
                            'text': 'Report a problem',
                            'onTap': () => showReportAProblem(),
                          },
                          {
                            'icon': Icons.fact_check_outlined,
                            'text': 'Terms and Conditions',
                            'onTap': () => showTermsAndConditions('Terms and Conditions'),
                          },
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // SizedBox(
                //   width: double.infinity,
                //   child: FilledButton(
                //     onPressed: () => Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => MyApp()),
                //     ),
                //     style: FilledButton.styleFrom(
                //       backgroundColor:
                //       Theme.of(context).colorScheme.inversePrimary,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //         side: const BorderSide(
                //             color: Colors.black, width: 2),
                //       ),
                //     ),
                //     child: const Padding(
                //       padding: EdgeInsets.symmetric(vertical: 12),
                //       child: Text(
                //         "Back to Home",
                //         style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
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

//GENERAL CARD
class GeneralCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const GeneralCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(64, 251, 99, 156),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2), // Black border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Column(
            children: [
              GestureDetector(
                onTap: item['onTap'], // Call the onTap function
                child: Row(
                  children: [
                    Icon(
                      item['icon'],
                      size: 18,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['text'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (item != items.last)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: DottedLine(
                    padding: 1,
                    color: Colors.black, // Match the color of the divider
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const SettingsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(64, 144, 141, 254),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2), // Black border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Column(
            children: [
              GestureDetector(
                onTap: item['onTap'], // Call the onTap function
                child: Row(
                  children: [
                    Icon(
                      item['icon'],
                      size: 18,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['text'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (item != items.last)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: DottedLine(
                    padding: 1,
                    color: Colors.black, // Match the color of the divider
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFCE520),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2), // Black border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Space between text
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, // Italic title
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Label
class HeaderSection extends StatelessWidget {
  final String label;

  const HeaderSection(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontFamily: GoogleFonts.instrumentSerif().fontFamily,
        ),
        textAlign: TextAlign.start,
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

class EraseDataDialog {
  static void showEraseDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("This will erase all your progress and data."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await prefsService
                      .clearSharedPreferences(); // Clear all shared preferences
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const register_page()),
                        (route) => false, // Remove all previous routes
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("All progress and data erased."),
                      backgroundColor: Colors.red,
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to erase data: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
