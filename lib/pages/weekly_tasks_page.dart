import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intern_flutter/pages/update_log_page.dart';

import 'add_log_page.dart';

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
      debugShowCheckedModeBanner: false,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Weekly Progress Report 1",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                  ),
                ),
                Text(
                  "39 hours completed this week",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                ChooseDayChip(),
                SizedBox(height: 20),
                TaskPerDaySection(),
                SizedBox(height: 59),
                // ButtonFieldSection(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => add_log_page()),
            );
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(16)
          ),
        ),
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
            label: Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.instrumentSerif().fontFamily,
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

class TaskPerDaySection extends StatelessWidget {
  const TaskPerDaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('progress_logs').orderBy('created_at', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No logs available."));
        }

        final logs = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return Card(
              elevation: 4, // Adds shadow to the card
              margin: EdgeInsets.symmetric(vertical: 8), // Adds spacing between cards
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Adds padding inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            log['task'] ?? "No Task Title",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                            ),
                            overflow: TextOverflow.ellipsis, // Handles long text gracefully
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'Edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => update_log_page(
                                    logId: log.id,
                                    task: log['task'],
                                    date: log['date'],
                                    hours: log['hours'].toString(),
                                    description: log['description'],
                                  ),
                                ),
                              );
                            } else if (value == 'Delete') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Progress Log",
                                      style: GoogleFonts.instrumentSerif(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),),
                                    content: Text("Are you sure you want to delete this progress log?",
                                      style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('progress_logs')
                                              .doc(log.id)
                                              .delete()
                                              .then((_) {
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Progress log deleted successfully."),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }).catchError((error) {
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Failed to delete log: $error"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                        ),
                                        child: Text("Delete",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'Edit',
                              child: Text('Edit',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ),
                            PopupMenuItem(
                              value: 'Delete',
                              child: Text('Delete',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ),
                          ],
                          icon: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                    Text(
                      log['description'] ?? "No Description",
                      style: TextStyle(fontSize: 14),
                    ),
                    Divider(),
                    Text(
                      "${log['hours']} hour/s spent",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            );
          },
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
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: EdgeInsets.only(bottom: 16), // Adds spacing from the bottom
//         child: SizedBox(
//           width: double.infinity,
//           child: FilledButton(
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => add_log_page()),
//             ),
//             style: FilledButton.styleFrom(
//               backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 side: BorderSide(color: Colors.black, width: 2),
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               child: Text(
//                 "Add Progress",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onPrimaryContainer,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }