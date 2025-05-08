import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intern_flutter/pages/update_log_page.dart';
import 'package:intl/intl.dart';
import '../utils/shared_preferences_service.dart';
import 'add_log_page.dart';
import 'package:intern_flutter/main.dart';

class weekly_tasks_page extends StatelessWidget {
  final String wprId;
  final int wprNum;
  final String startDate;
  final String endDate;

  const weekly_tasks_page({
    super.key,
    required this.wprId,
    required this.wprNum,
    required this.startDate,
    required this.endDate,
  });

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
          title: const Text(""),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
              );
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
                  "Weekly Progress Report $wprNum",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                  ),
                ),
                Text(
                  "$startDate - $endDate",
                  style: const TextStyle(fontSize: 16),
                ),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('progress_logs')
                      .where('wprId', isEqualTo: wprId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading hours...", style: TextStyle(fontSize: 16));
                    }

                    if (snapshot.hasError) {
                      return const Text("Error loading hours", style: TextStyle(fontSize: 16));
                    }

                    final logs = snapshot.data?.docs ?? [];
                    int totalHours = 0;

                    for (var doc in logs) {
                      final hours = doc['hours'];
                      if (hours is int) totalHours += hours;
                    }

                    return Text(
                      "$totalHours hours completed this week",
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // ChooseDayChip(),
                const SizedBox(height: 20),
                TaskPerDaySection(wprId: wprId),
                const SizedBox(height: 59),
                // ButtonFieldSection(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const  add_log_page()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// class ChooseDayChip extends StatefulWidget {
//   @override
//   _ChooseDayChip createState() => _ChooseDayChip();
// }
//
// class _ChooseDayChip extends State<ChooseDayChip> {
//   List<String> days = ["D-1", "D-2", "D-3", "D-4", "D-5"];
//   String _selectedDay = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Wrap(
//         spacing: 5.0,
//         children: days.map((day) {
//           return ChoiceChip(
//             label: Text(
//               day,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontFamily: GoogleFonts.instrumentSerif().fontFamily,
//               ),
//             ),
//             selected: _selectedDay == day,
//             onSelected: (bool selected) {
//               setState(() {
//                 _selectedDay = selected ? day : "";
//               });
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }
// }


class TaskPerDaySection extends StatelessWidget {
  final String wprId;

  const TaskPerDaySection({super.key, required this.wprId});

  // Flexible date parser
  DateTime parseFlexibleDate(String dateString) {
    try {
      return DateTime.parse(dateString); // ISO format: 2025-04-23
    } catch (_) {
      return DateFormat('d/M/yyyy').parse(dateString); // e.g., 23/4/2025
    }
  }

  Future<String?> _getInternId() async {
    SharedPreferencesService prefsService = SharedPreferencesService();
    String? internId = await prefsService.getInternData('id');
    if (internId == null || internId.isEmpty) {
      throw Exception("Intern ID not found in shared preferences.");
    }
    return internId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getInternId(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (futureSnapshot.hasError || !futureSnapshot.hasData || futureSnapshot.data == null) {
          return Center(child: Text("No intern ID found."));
        }

        final internId = futureSnapshot.data;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('progress_logs')
              .where('internId', isEqualTo: internId)
              .where('wprId', isEqualTo: wprId)
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (streamSnapshot.hasError) {
              return Center(child: Text("Error loading logs: ${streamSnapshot.error}"));
            }

            if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
              return Center(child: Text("No logs added."));
            }

            final logs = streamSnapshot.data!.docs;

            // Group logs by formatted date
            Map<String, List<QueryDocumentSnapshot>> logsByDate = {};

            for (var log in logs) {
              try {
                DateTime date = parseFlexibleDate(log['date']);
                String formattedDate = DateFormat('dd-MM-yyyy').format(date);
                logsByDate.putIfAbsent(formattedDate, () => []).add(log);
              } catch (e) {
                // Optionally log or handle errors if parsing fails
                print("Invalid date format: ${log['date']}");
              }
            }

            final sortedDates = logsByDate.keys.toList()
              ..sort((a, b) => DateFormat('dd-MM-yyyy').parse(a).compareTo(DateFormat('dd-MM-yyyy').parse(b)));

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final dateKey = sortedDates[index];
                final logsForDate = logsByDate[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        dateKey,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...logsForDate.map((log) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    log['task'] ?? "No Task Title",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
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
                                              title: Text(
                                                "Delete Progress Log",
                                                style: GoogleFonts.instrumentSerif(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              content: Text(
                                                "Are you sure you want to delete this progress log?",
                                                style: GoogleFonts.manrope(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
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
                                                      // ScaffoldMessenger.of(context).showSnackBar(
                                                      //   SnackBar(
                                                      //     content: Text("Progress log deleted successfully."),
                                                      //     backgroundColor: Colors.red,
                                                      //   ),
                                                      // );
                                                      Navigator.of(context).pop();
                                                    }).catchError((error) {
                                                      // ScaffoldMessenger.of(context).showSnackBar(
                                                      //   SnackBar(
                                                      //     content: Text("Failed to delete log: $error"),
                                                      //     backgroundColor: Colors.red,
                                                      //   ),
                                                      // );
                                                      Navigator.of(context).pop();
                                                    });
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                                  ),
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
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
                                        child: Text(
                                          'Edit',
                                          style: GoogleFonts.manrope(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Delete',
                                        child: Text(
                                          'Delete',
                                          style: GoogleFonts.manrope(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
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
                    }).toList(),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}




