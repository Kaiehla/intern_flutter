import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class add_log_page extends StatelessWidget {
  const add_log_page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Add a log",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.manropeTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                "Add Progress",
                style: GoogleFonts.manrope(),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [TextFieldSection(), ButtonFieldSection()],
                ))));
  }
}

class TextFieldSection extends StatefulWidget {
  const TextFieldSection({super.key});

  @override
  _TextFieldSectionState createState() => _TextFieldSectionState();
}

class _TextFieldSectionState extends State<TextFieldSection> {
  DateTime? _selectedStartDate;

  // start date
  void _pickStartDate(BuildContext context) async {
    DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedStartDate != null) {
      setState(() {
        _selectedStartDate = pickedStartDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Text(
            "Welcome back, Kai!",
            style: GoogleFonts.instrumentSerif(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            "What did you work on today?", // New text at the top
            style: TextStyle(fontSize: 16),
          ),
          // task name
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Task Name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16),

          // date and hours spent
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // date
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Date",
                      hintText: _selectedStartDate != null
                          ? "${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}"
                          : "dd/mm/yyyy",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: _selectedStartDate != null
                          ? FloatingLabelBehavior.always
                          : FloatingLabelBehavior.auto,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_month),
                        onPressed: () => _pickStartDate(context),
                      ),
                    ),
                  ),
                ),

                // hours spent
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Hours Spent",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
              ],
            ),
          ),

          // description
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                hintText: "Enter description here...",
              ),
              maxLines: 4,
              maxLength: 150,
            ),
          ),
        ],
      ),
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
