import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif/gif.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../utils/validations.dart';

// controllers
final TextEditingController _taskController = TextEditingController();
final TextEditingController _dateController = TextEditingController();
final TextEditingController _hoursController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();

// validations
bool _validateTask = false;
bool _validateDate = false;
bool _validateHours = false;
bool _validateDescription = false;

class add_log_page extends StatelessWidget {
  const add_log_page({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: "Add Progress",
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
                    padding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeaderSection(),
                        TextFieldSection(),
                        ButtonFieldSection()
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          drawer: Drawer(
            child: ListView(
              children: [DrwHeader(), DrwListView()],
            ),
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
        _dateController.text =
        "${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}";
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
              setState(() {});
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
              ...Validations.generalDenyPatterns.map((pattern) => FilteringTextInputFormatter.deny(RegExp(pattern))), // Apply deny filters
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

class ButtonFieldSection extends StatelessWidget {
  const ButtonFieldSection({super.key});

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
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp())),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Back to Home",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
              ),
            ),
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
            "Welcome back, Kai!",
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
