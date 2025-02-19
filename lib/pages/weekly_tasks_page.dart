import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      Text("39 hours completed this week", style:
                      TextStyle(
                          fontSize: 15,
                      ),
                      ),
                      SizedBox(height: 10),
                      ChooseDayChip(),
                      SizedBox(height: 20),
                      TaskPerDaySection(),
                      SizedBox(height: 15),
                      TaskPerDaySection()
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
            label: Text(day),
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
          Text("Day 1 of Week 1 - Feb 07, 2025"),
          SizedBox(height: 5,),
          Card.filled(
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Task Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Description of task kunyare nalang mahaba to pake nyo ba ha",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Divider(), // Horizontal line separator
                  Text(
                    "2 hours spent",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card.filled(
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Task Name Uli Why Not",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Description of task kunyare nalang mahaba to pake nyo ba hahahahahah",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Divider(), // Horizontal line separator
                  Text(
                    "2 hours spent",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
  }
}