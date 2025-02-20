import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern_flutter/pages/add_log_page.dart';

class weekly_tasks_page extends StatelessWidget {
  const weekly_tasks_page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weekly Tasks Page",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text(""),
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
                      Text("Weekly Progress Report 1", style:
                      TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                      ),
                      ),
                      Text("39 hours completed this week", style:
                      TextStyle(
                        fontSize: 16,
                      ),
                      ),
                      SizedBox(height: 10),
                      ChooseDayChip(),
                      SizedBox(height: 20),
                      TaskPerDaySection(),
                      ButtonFieldSection()
                    ],
                  )
              )
          )
      ),
    );
  }
}

class ChooseDayChip extends StatefulWidget {
  @override
  _ChooseDayChip createState() => _ChooseDayChip();
}

class _ChooseDayChip extends State<ChooseDayChip> {
  List<String> days = ["D-1", "D-2", "D-3", "D-4", "D-5"];
  String _selectedDay = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 5.0,
        children: days.map((day) {
          return ChoiceChip(
            label: Text(day, style:
            TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.instrumentSerif().fontFamily
            ),
            ),
            selected: _selectedDay == day,
            onSelected: (bool selected) {
              setState(() {
                _selectedDay = selected ? day : "";
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

class TaskPerDaySection extends StatelessWidget{
  const TaskPerDaySection({super.key});

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Day 1 of Week 1 - Feb 07, 2025", style:
        TextStyle(
            color: Theme.of(context).colorScheme.primary
        ),
        ),
        SizedBox(height: 5,),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(16)
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "First OJT Task",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: GoogleFonts.instrumentSerif().fontFamily
                  ),
                ),
                Text(
                  "Introduction to Symph and signing in using company account",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Divider(

                ), // Horizontal line separator
                Text(
                  "4 hours spent",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(16)
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Second OJT Task",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: GoogleFonts.instrumentSerif().fontFamily
                  ),
                ),
                Text(
                  "Setting up Discord account and signing up to UI/UX Bootcamp",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Divider(), // Horizontal line separator
                Text(
                  "4 hours spent",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8,),
        Text("Day 2 of Week 1 - Feb 08, 2025", style:
        TextStyle(
            color: Theme.of(context).colorScheme.primary
        ),
        ),
        SizedBox(height: 5,),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(12)
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Third OJT Task",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: GoogleFonts.instrumentSerif().fontFamily
                  ),
                ),
                Text(
                  "Attended team-wide meeting for 2 hours with Talent Head",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Divider(),
                Text(
                  "4 hours spent",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(16)
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fourth OJT Task",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: GoogleFonts.instrumentSerif().fontFamily
                  ),
                ),
                Text(
                  "Onboarding with supervisor and delegation of team and project",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Divider(), // Horizontal line separator
                Text(
                  "4 hours spent",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonFieldSection extends StatelessWidget {
  const ButtonFieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => add_log_page())),
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
                  "Add New Log",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}