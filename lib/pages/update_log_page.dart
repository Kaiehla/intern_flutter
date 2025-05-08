import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../utils/validations.dart';
import 'package:intl/intl.dart';

final TextEditingController _taskController = TextEditingController();
final TextEditingController _dateController = TextEditingController();
final TextEditingController _hoursController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();

bool _validateTask = false;
bool _validateDate = false;
bool _validateHours = false;
bool _validateDescription = false;

class update_log_page extends StatefulWidget {
  final String? logId;
  final String? task;
  final String? date;
  final String? hours;
  final String? description;

  const update_log_page({
    Key? key,
    this.logId,
    this.task,
    this.date,
    this.hours,
    this.description,
  }) : super(key: key);

  @override
  _AddLogPageState createState() => _AddLogPageState();
}

class _AddLogPageState extends State<update_log_page> {
  @override
  void initState() {
    super.initState();
    _taskController.text = widget.task ?? '';
    _dateController.text = widget.date ?? '';
    _hoursController.text = widget.hours ?? '';
    _descriptionController.text = widget.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Edit Progress",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.manropeTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Edit Progress"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HeaderSection(),
                      TextFieldSection(),
                      ButtonFieldSection(
                        logId: widget.logId,
                        task: _taskController.text,
                        date: _dateController.text,
                        hours: _hoursController.text,
                        description: _descriptionController.text,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TextFieldSection extends StatefulWidget {
  const TextFieldSection({super.key});

  @override
  _TextFieldSectionState createState() => _TextFieldSectionState();
}

class _TextFieldSectionState extends State<TextFieldSection> {
  // DateTime? _selectedBirthday;
  DateTime? _selectedStartDate;

  void _pickBirthday(BuildContext context) async {
    DateTime? pickedBirthday = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedBirthday != null) {
      setState(() {
        _selectedStartDate = pickedBirthday;
        _dateController.text = DateFormat('d/M/yyyy').format(_selectedStartDate!);
      });
    }
  }

  // validations
  void validateIDFields() {
    setState(() {
      _validateTask = _taskController.text.isEmpty;
      _validateDate = _dateController.text.isEmpty;
      _validateHours = _hoursController.text.isEmpty;
      _validateDescription = _descriptionController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InternIDCard(
            task: _taskController.text,
            date: _dateController.text,
            hours: _hoursController.text,
            description: _descriptionController.text,
          ),
          SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Task
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _taskController,
                  maxLength: 30,
                  decoration: InputDecoration(
                    labelText: "Task Title",
                    border: OutlineInputBorder(),
                    errorText: _validateTask ? "Enter task name" : null,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(30),
                    ...Validations.strictDenyPatterns.map((pattern) => FilteringTextInputFormatter.deny(RegExp(pattern))),
                  ],
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),

            ],
          ),

          // Date
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: TextField(
              controller: _dateController,
              readOnly: true,
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
                  icon: Icon(Icons.calendar_month),
                  onPressed: () => _pickBirthday(context),
                ),
                errorText: _validateDate ? "Enter a valid date" : null,
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ),

          // Hours spent
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: TextField(
              controller: _hoursController,
              maxLength: 2, // Maximum of 2 digits
              keyboardType: TextInputType.number, // Sets the keyboard to numbers
              decoration: InputDecoration(
                labelText: "Hours Spent",
                border: OutlineInputBorder(),
                errorText: _validateHours ? "Enter a valid number of hours" : null,
              ),
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(2), // Limit input to 2 characters
                FilteringTextInputFormatter.digitsOnly, // Allow only numbers
              ],
              onChanged: (text) {
                // so it doesn't accept 0, 00, or 01 as inputs
                if (text == "0" || text == "00" || (text.startsWith('0') && text.length > 1)) {
                  _hoursController.clear();
                  setState(() {
                    _validateHours = true;
                  });
                } else {
                  setState(() {
                    _validateHours = false;
                  });
                }
              },
            ),
          ),


          // Description
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: TextField(
              controller: _descriptionController,
              maxLength: 200,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                errorText: _validateDescription ? "Enter description..." : null,
              ),
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(200),
              ],
              onChanged: (text) {
                setState(() {});
              },
            ),
          )
        ]
    );
  }
}

// card
class InternIDCard extends StatelessWidget {
  final String task;
  final String date;
  final String hours;
  final String description;

  static const TextStyle idInputStyle = TextStyle(fontSize: 11);
  static const TextStyle idLabelStyle =
  TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

  const InternIDCard({
    required this.task,
    required this.date,
    required this.hours,
    required this.description,
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
        child: Column(
          children: [
            Text(
              "Progress Report",
              style: TextStyle(
                fontSize: 26,
                fontStyle: FontStyle.italic,
                fontFamily: GoogleFonts.instrumentSerif().fontFamily,
              ),
            ),
            DottedLine(),

            // ID Card Body
            Column(
              children: [
                // Task
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 1, child: Text("Task Title", style: idLabelStyle)),
                    Expanded(
                      flex: 2,
                      child: Text(
                        task,
                        style: idInputStyle,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),

                // Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 1, child: Text("Date", style: idLabelStyle)),
                    Expanded(
                      flex: 2,
                      child: Text(
                        date,
                        style: idInputStyle,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                DottedLine(),

                // Hours spent
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Hours Spent", style: idLabelStyle),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            hours,
                            style: idInputStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Hour/s",
                            style: idInputStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


                SizedBox(height: 8),

                // Description
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description", style: idLabelStyle),
                      SizedBox(
                        height: 60,
                        child: Text(
                          description,
                          style: idInputStyle,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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

class ButtonFieldSection extends StatelessWidget {
  final String? logId;
  final String? task;
  final String? date;
  final String? hours;
  final String? description;
  // const ButtonFieldSection({super.key, this.logId});


  const ButtonFieldSection({
    super.key,
    this.logId,
    this.task,
    this.date,
    this.hours,
    this.description,
  });

  void updateLog(BuildContext context, String? logId) async {
    if (logId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Log ID is null. Cannot update."), backgroundColor: Colors.red),
      );
      return;
    }

    // Check if any changes have been made
    if (_taskController.text.trim() == (task ?? '').trim() &&
        _dateController.text.trim() == (date ?? '').trim() &&
        _hoursController.text.trim() == (hours ?? '').trim() &&
        _descriptionController.text.trim() == (description ?? '').trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No changes have been made."), backgroundColor: Colors.orange),
      );
    } else {
      // Validate fields
      _validateTask = _taskController.text.isEmpty;
      _validateDate = _dateController.text.isEmpty;
      _validateHours = _hoursController.text.isEmpty;
      _validateDescription = _descriptionController.text.isEmpty;

      if (!_validateTask && !_validateDate && !_validateHours && !_validateDescription) {
        try {
          int? hours = int.tryParse(_hoursController.text);
          if (hours == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Hours must be a valid number."), backgroundColor: Colors.red),
            );
            return;
          }

          String newLogDateString = _dateController.text.trim();

          // Function to parse date strings into DateTime objects
          DateTime parseDateString(String dateString) {
            return DateFormat('d/M/yyyy').parseStrict(dateString);
          }

          // Parse the new log date
          DateTime newLogDate = parseDateString(newLogDateString);

          QuerySnapshot wprSnapshot = await FirebaseFirestore.instance
              .collection('wpr_logs')
              .get();

          String? newWprId;

          // Loop through WPR logs to find the matching one based on the new date
          for (var doc in wprSnapshot.docs) {
            // Handle both Timestamp and String for startDate and endDate
            var startDate = doc['startDate'];
            var endDate = doc['endDate'];

            DateTime start, end;

            // If it's a Timestamp, convert it to DateTime. If it's a string, parse it.
            if (startDate is Timestamp) {
              start = startDate.toDate();
            } else if (startDate is String) {
              start = DateFormat('d/M/yyyy').parseStrict(startDate);
            } else {
              throw Exception("Unknown date format for startDate.");
            }

            if (endDate is Timestamp) {
              end = endDate.toDate();
            } else if (endDate is String) {
              end = DateFormat('d/M/yyyy').parseStrict(endDate);
            } else {
              throw Exception("Unknown date format for endDate.");
            }

            // Check if the new log date falls within the range of the WPR dates
            if (!newLogDate.isBefore(start) && !newLogDate.isAfter(end)) {
              newWprId = doc.id;
              break;
            }
          }

          // Update the progress log with the new data
          await FirebaseFirestore.instance.collection('progress_logs').doc(logId).update({
            'task': _taskController.text,
            'date': newLogDateString, // Update the date as a string
            'hours': hours,
            'description': _descriptionController.text,
            'updated_at': FieldValue.serverTimestamp(),
            if (newWprId != null) 'wprId': newWprId, // Update the WPR if it changed
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Progress log updated successfully!"), backgroundColor: Colors.orangeAccent),
          );

          // Wait for snackbar alert to appear before redirecting
          await Future.delayed(Duration(seconds: 2));

          // Clear fields after successful update
          _taskController.clear();
          _dateController.clear();
          _hoursController.clear();
          _descriptionController.clear();

          // Navigate to the homepage after success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        } catch (error) {
          print("Update failed: $error");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to update log: $error"), backgroundColor: Colors.red),
          );
        }
      } else {
        (context as Element).markNeedsBuild();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {
                  if (logId != null) {
                    updateLog(context, logId);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Log ID is missing. Cannot update."), backgroundColor: Colors.orange),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
          ],
        ),

      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back!",
            style: GoogleFonts.instrumentSerif(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),

          Text(
            "What did you work on today?",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
