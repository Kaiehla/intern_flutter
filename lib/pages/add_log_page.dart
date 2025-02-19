import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Add Log"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      TextFieldSection(),
                      ButtonFieldSection()
                    ],
                  )
              )
          )
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

          // text
          Text(
            "Add a new log", // New text at the top
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp())),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Save Log",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}