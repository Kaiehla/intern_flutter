import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intern_flutter/models/wprModel.dart';
import 'package:intern_flutter/pages/add_log_page.dart';
import 'package:intern_flutter/pages/profile_page.dart';
import 'package:intern_flutter/pages/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern_flutter/pages/weekly_tasks_page.dart';
import 'package:gif/gif.dart';
import 'package:intern_flutter/pages/onboarding_page.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intern_flutter/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intern_flutter/utils/globals.dart';
import 'package:intern_flutter/utils/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:intl/intl.dart';

//controllers
final TextEditingController _startDateController = TextEditingController();
final TextEditingController _endDateController = TextEditingController();
final TextEditingController _wprNumController = TextEditingController();
final SharedPreferencesService prefsService = SharedPreferencesService();

//validations
bool _validateStartDate = false;
bool _validateEndDate = false;
bool _validateWprNum = false;

// navigation bar
int _selectedIndex = 0;

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if the app has already registered user
  String? internId = await prefsService.getInternData('id');
  bool hasRegisteredUser = internId?.isNotEmpty ?? false;

  runApp(hasRegisteredUser ? const MyApp() : const onboarding_page());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const String appTitle = "Welcome to Intern App";

    return MaterialApp(
        title: appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.manropeTextTheme(),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.deepPurple, // Label color
            unselectedItemColor: Colors.black45,
            selectedIconTheme: IconThemeData(color: const Color(0xFFF3B006)), // Selected icon color
            unselectedIconTheme: IconThemeData(color: Colors.black45), // Unselected icon color
            backgroundColor: Colors.white,
            elevation: 5,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen()
    );
  }
}

// stateful lesson
// immutable pa to, nagiging mutable lang sha pag nagcreate ka ng state
// pag nagdeclare ka ng stateful widget, laging may kasamang state declaration
class DrwHeader extends StatefulWidget {
  @override
  _Drwheader createState() => _Drwheader(); //declaration ng state
}

//state ng stateful widget class sa taas - tapos yung override build dito lang iddeclare sa state
class _Drwheader extends State<DrwHeader> {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 100,
                child: Gif(
                  image: AssetImage("logo.gif"),
                  autostart: Autostart.loop,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrwListView extends StatefulWidget {
  @override
  _DrwListView createState() => _DrwListView();
}

class _DrwListView extends State<DrwListView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(children: [
        ListTile(
          title: Text("Home"),
          leading: Icon(SolarIconsOutline.homeSmile),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp())),
        ),
        ListTile(
          title: Text("Create Intern ID"),
          leading: Icon(Icons.person_add_alt_1),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => register_page())),
        ),
        ListTile(
          title: Text("Add Progress"),
          leading: Icon(Icons.add),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => add_log_page())),
        ),
        ListTile(
          title: Text("My Intern"),
          leading: Icon(Icons.person),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => profile_page())),
        ),
        ListTile(
          title: Text("Onboarding"),
          leading: Icon(Icons.video_collection_outlined),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => onboarding_page())),
        ),
      ]),
    );
  }
}

// class ProgressSection extends StatelessWidget{
//   const ProgressSection({super.key});
//
//   // eto ung sa hours progress kinimi kimi
//   Future<Map<String, int>> getHoursProgress() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Retrieve internId from SharedPreferences
//     String? internId = prefs.getString('internModel') != null
//         ? jsonDecode(prefs.getString('internModel')!)['id']
//         : null;
//
//     if (internId == null) {
//       print("Intern ID not found in SharedPreferences.");
//       return {'hoursCompleted': 0, 'hoursRequired': 0};
//     }
//
//     // Query Firestore for progress logs to calculate total hours
//     QuerySnapshot progressLogsSnapshot = await FirebaseFirestore.instance
//         .collection('progress_logs')
//         .where('internId', isEqualTo: internId)
//         .get();
//
//     int totalHours = progressLogsSnapshot.docs.fold<int>(
//       0,
//           (sum, doc) => sum + ((doc['hours'] ?? 0) as int),
//     );
//
//     // Query Firestore for interns to get hoursRequired
//     DocumentSnapshot internSnapshot = await FirebaseFirestore.instance
//         .collection('interns')
//         .doc(internId)
//         .get();
//
//     int hoursRequired = internSnapshot.exists
//         ? (internSnapshot.data() as Map<String, dynamic>)['hoursRequired'] ?? 0
//         : 0;
//
//     print("Total Hours Completed: $totalHours");
//     print("Hours Required: $hoursRequired");
//
//     return {'hoursCompleted': totalHours, 'hoursRequired': hoursRequired};
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             decoration:
//             BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 )
//             ),
//             padding: EdgeInsets.all(24),
//             child:
//             Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Expected end of internship by:",
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Text(
//                     "May 02, 2025",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w400,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         width: 200,
//                         height: 200,
//                         child: CircularProgressIndicator(
//                           value: 0.6,
//                           strokeWidth: 8,
//                           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//                           valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
//                         ),
//                       ),
//                       Text(
//                         "60%",
//                         style: TextStyle(
//                           fontSize: 50,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10), //Separator between ProgressIndicator and Hours
//                 FutureBuilder<Map<String, int>>(
//                   future: getHoursProgress(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.hasError) {
//                       return Text("Error: ${snapshot.error}");
//                     } else if (!snapshot.hasData || snapshot.data == null) {
//                       return const Text("No progress data found.");
//                     } else {
//                       final hoursCompleted = snapshot.data!['hoursCompleted'] ?? 0;
//                       final hoursRequired = snapshot.data!['hoursRequired'] ?? 0;
//                       return Text(
//                         "$hoursCompleted/$hoursRequired hours",
//                         style: TextStyle(
//                           fontSize: 23,
//                           fontWeight: FontWeight.w900,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       );
//                     }
//                   },
//                 ),
//
//                  FutureBuilder<String?>(
//                     future: prefsService.getInternData('position'),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator(); // Show a loading indicator while waiting
//                       } else if (snapshot.hasError) {
//                         return const Text("Error retrieving position");
//                       } else if (!snapshot.hasData || snapshot.data == null) {
//                         return const Text("No Intern Position found");
//                       } else {
//                         return Text(
//                           snapshot.data!,
//                           style: TextStyle(
//                             fontSize: 24,
//                             color: Colors.black,
//                             fontStyle: FontStyle.italic,
//                             fontFamily: GoogleFonts.instrumentSerif().fontFamily,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                   FutureBuilder<String?>(
//                     future: prefsService.getInternData('company'),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator(); // Show a loading indicator while waiting
//                       } else if (snapshot.hasError) {
//                         return const Text("Error retrieving company");
//                       } else if (!snapshot.hasData || snapshot.data == null) {
//                         return const Text("No Company found");
//                       } else {
//                         return Text(
//                           snapshot.data!,
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.black,
//                             fontFamily: GoogleFonts.manrope().fontFamily,
//                           ),
//                         );
//                       }
//                     },
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class ProgressSection extends StatelessWidget {
  const ProgressSection({super.key});

  Future<Map<String, int>> getHoursProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve internId from SharedPreferences
    String? internId = prefs.getString('internModel') != null
        ? jsonDecode(prefs.getString('internModel')!)['id']
        : null;

    if (internId == null) {
      print("Intern ID not found in SharedPreferences.");
      return {'hoursCompleted': 0, 'hoursRequired': 0};
    }

    // Query Firestore for progress logs to calculate total hours
    QuerySnapshot progressLogsSnapshot = await FirebaseFirestore.instance
        .collection('progress_logs')
        .where('internId', isEqualTo: internId)
        .get();

    int totalHours = progressLogsSnapshot.docs.fold<int>(
      0,
          (sum, doc) => sum + ((doc['hours'] ?? 0) as int),
    );

    // Query Firestore for interns to get hoursRequired
    DocumentSnapshot internSnapshot = await FirebaseFirestore.instance
        .collection('interns')
        .doc(internId)
        .get();

    int hoursRequired = internSnapshot.exists
        ? (internSnapshot.data() as Map<String, dynamic>)['hoursRequired'] ?? 0
        : 0;

    return {'hoursCompleted': totalHours, 'hoursRequired': hoursRequired};
  }

  Future<String?> getInternPosition() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? internId = prefs.getString('internModel') != null
          ? jsonDecode(prefs.getString('internModel')!)['id']
          : null;

      if (internId == null) {
        print("Intern ID not found in SharedPreferences.");
        return null;
      }

      DocumentSnapshot internSnapshot = await FirebaseFirestore.instance
          .collection('interns')
          .doc(internId)
          .get();

      return internSnapshot.exists
          ? (internSnapshot.data() as Map<String, dynamic>)['position'] as String?
          : null;
    } catch (e) {
      print("Error fetching intern position: $e");
      return null;
    }
  }

  Future<String?> getInternCompany() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? internId = prefs.getString('internModel') != null
          ? jsonDecode(prefs.getString('internModel')!)['id']
          : null;

      if (internId == null) {
        print("Intern ID not found in SharedPreferences.");
        return null;
      }

      DocumentSnapshot internSnapshot = await FirebaseFirestore.instance
          .collection('interns')
          .doc(internId)
          .get();

      return internSnapshot.exists
          ? (internSnapshot.data() as Map<String, dynamic>)['company'] as String?
          : null;
    } catch (e) {
      print("Error fetching intern company: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const Text(
                  //   "Expected end of internship by:",
                  //   style: TextStyle(
                  //     fontSize: 15,
                  //     fontWeight: FontWeight.w400,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  const Text(
                    "Your current progress is:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 15),
                  FutureBuilder<Map<String, int>>(
                    future: getHoursProgress(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text("No progress data found.");
                      } else {
                        final hoursCompleted = snapshot.data!['hoursCompleted'] ?? 0;
                        final hoursRequired = snapshot.data!['hoursRequired'] ?? 0;
                        final progress = hoursRequired > 0
                            ? (hoursCompleted / hoursRequired)
                            : 0.0;
                        final percentage = (progress * 100).toStringAsFixed(0);

                        return Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 8,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                Text(
                                  "$percentage%",
                                  style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "$hoursCompleted/$hoursRequired hours",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),

                  FutureBuilder<String?>(
                    future: getInternPosition(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show a loading indicator while waiting
                      } else if (snapshot.hasError) {
                        return const Text("Error retrieving position");
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text("No Intern Position found");
                      } else {
                        return Text(
                          snapshot.data!,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder<String?>(
                    future: getInternCompany(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show a loading indicator while waiting
                      } else if (snapshot.hasError) {
                        return const Text("Error retrieving company");
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text("No Company found");
                      } else {
                        return Text(
                          snapshot.data!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyProgressSection extends StatelessWidget{
  const WeeklyProgressSection({super.key});

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
          return Center(child: Text("No intern ID found or an error occurred."));
        }

        final internId = futureSnapshot.data;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('wpr_logs')
              .where('internId', isEqualTo: internId)
          // .orderBy('created_at', descending: true)
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (streamSnapshot.hasError) {
              return Center(child: Text("Error loading logs: ${streamSnapshot.error}"));
            }

            if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
              return Center(child: Text("No weekly progress report added yet."));
            }

            final logs = streamSnapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.assignment,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                      title: Text(
                        "Weekly Progress Report ${log['wprNum']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "${log['startDate']} - ${log['endDate']}",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Edit') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return UpdateWPR(wprId: log.id,);
                              },
                            );
                          } else if (value == 'Delete') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Delete WPR ${log['wprNum']}",
                                    style: GoogleFonts.instrumentSerif(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  content: Text(
                                    "Are you sure you want to delete this weekly progress report?",
                                    style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('wpr_logs')
                                            .doc(log.id)
                                            .delete()
                                            .then((_) {
                                          Navigator.of(context).pop();
                                          // ScaffoldMessenger.of(context).showSnackBar(
                                          //   SnackBar(
                                          //     content: Text("WPR deleted successfully."),
                                          //     backgroundColor: Colors.red,
                                          //   ),
                                          // );
                                        }).catchError((error) {
                                          Navigator.of(context).pop();
                                          // ScaffoldMessenger.of(context).showSnackBar(
                                          //   SnackBar(
                                          //     content: Text("Failed to delete WPR: $error"),
                                          //     backgroundColor: Colors.red,
                                          //   ),
                                          // );
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
                      onTap: () {
                        // lipat page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => weekly_tasks_page(
                              wprId: log.id,
                              wprNum: log['wprNum'],
                              startDate: log['startDate'],
                              endDate: log['endDate'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

//ito lang nagpagana sa FAB
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openAddWPRDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddWPR(); // Open the modal
      },
    );
  }

  // navigation logic
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Scaffold(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: const [
              ProgressSection(),
              WeeklyProgressSection(),
            ],
          ),
        ),
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [DrwHeader(), DrwListView()],
      //   ),
      // ),
    ),
    const add_log_page(),
    const profile_page(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddWPRDialog,
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(16)
        ),
      ),
    );
  }
}

class AddWPR extends StatefulWidget {
  final String? wprId;
  final String? wprNum;
  final String? startDate;
  final String? endDate;

  const AddWPR({
    Key? key,
    this.wprId,
    this.wprNum,
    this.startDate,
    this.endDate
  }): super(key: key);

  @override
  _AddWPRState createState() => _AddWPRState();
}

class _AddWPRState extends State<AddWPR> {
  @override
  void initState() {
    super.initState();
    _wprNumController.text = widget.wprNum ?? '';
    _startDateController.text = widget.startDate ?? '';
    _endDateController.text = widget.endDate ?? '';
  }

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Add Firebase Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Counter reference for wpr logs
  final DocumentReference counterDocRef = FirebaseFirestore.instance.collection('counters').doc('wpr_logs_counter');

  Future<DateTime?> getInternStartDate() async {
    final prefsService = SharedPreferencesService();
    final internId = await prefsService.getInternData('id');

    if (internId == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('interns') // adjust if your collection name differs
        .doc(internId)
        .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null && data['startDate'] != null) {
        // If stored as string in format 'd/M/yyyy'
        try {
          return DateFormat('d/M/yyyy').parseStrict(data['startDate']);
        } catch (_) {}

        // Or if stored as Firestore timestamp
        if (data['startDate'] is Timestamp) {
          return (data['startDate'] as Timestamp).toDate();
        }
      }
    }

    return null;
  }

  void _pickStartDate(BuildContext context) async {
    DateTime? internStartDate = await getInternStartDate();

    if (internStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Intern start date not found.")),
      );
      return;
    }

    DateTime initialDate = _selectedStartDate ?? DateTime.now();

    DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: internStartDate,
      lastDate: DateTime(2100),
    );

    if (pickedStartDate != null) {
      setState(() {
        _selectedStartDate = pickedStartDate;
        _startDateController.text =
        "${pickedStartDate.day}/${pickedStartDate.month}/${pickedStartDate.year}";
      });
    }
  }

  void _pickEndDate(BuildContext context) async {
    DateTime? internStartDate = await getInternStartDate();

    if (internStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Intern start date not found.")),
      );
      return;
    }

    // Default initialDate to today, but ensure it's not before the intern's start date
    DateTime initialDate = DateTime.now().isBefore(internStartDate)
        ? internStartDate
        : DateTime.now();

    DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? initialDate,
      firstDate: internStartDate,
      lastDate: DateTime(2100),
    );

    if (pickedEndDate != null) {
      setState(() {
        _selectedEndDate = pickedEndDate;
        _endDateController.text =
        "${pickedEndDate.day}/${pickedEndDate.month}/${pickedEndDate.year}";
      });
    }
  }


  Future<void> addWprToFirestore() async {
    setState(() {
      _validateWprNum = _wprNumController.text.isEmpty;
      _validateStartDate = _selectedStartDate == null;
      _validateEndDate = _selectedEndDate == null;
    });

    if(!_validateWprNum && !_validateStartDate && !_validateEndDate){
      try {
        // Retrieve the intern ID from shared preferences
        SharedPreferencesService prefsService = SharedPreferencesService();
        String? internId = await prefsService.getInternData('id');

        if (internId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No intern ID found. Please register first.")),
          );
          return;
        }

        DocumentReference wprRef = FirebaseFirestore.instance.collection('wpr_logs').doc();

        // Add the log with the intern ID
        await wprRef.set({
          'id': wprRef.id,
          'internId': internId,
          'wprNum': int.parse(_wprNumController.text),
          'startDate': _startDateController.text,
          'endDate': _endDateController.text,
          'created_at': FieldValue.serverTimestamp(),
        });

        // await FirebaseFirestore.instance.collection('wpr_logs').add({
        //   'internId': internId,
        //   'wprNum': int.parse(_wprNumController.text),
        //   'startDate': _startDateController.text,
        //   'endDate': _endDateController.text,
        //   'created_at': FieldValue.serverTimestamp(),
        // });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Added progress log successfully!"), backgroundColor: Colors.green),
        // );

        // waits for snackbar alert to appear before reddirectng
        await Future.delayed(Duration(seconds: 2));

        //clear all field
        _wprNumController.clear();
        _selectedStartDate = null;
        _selectedEndDate = null;
      }catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add log. Please try again.")),
        );
      }
    } else {
      (context as Element).markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Weekly Progress Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _wprNumController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "WPR #",
              border: OutlineInputBorder(),
              errorText: _validateWprNum ? "Enter a valid number" : null,
            ),
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(2),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (text) {
              // so it doesn't accept 0, 00, or 01 as inputs
              if (text == "0" || text == "00" || (text.startsWith('0') && text.length > 1)) {
                _wprNumController.clear();
                setState(() {
                  _validateWprNum = true;
                });
              } else {
                setState(() {
                  _validateWprNum = false;
                });
              }
            },
          ),
          SizedBox(height: 12),

          // Start Date
          TextField(
            controller: _startDateController,
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
                onPressed: () => _pickStartDate(context),
              ),
              errorText: _validateStartDate ? "Enter a valid start date" : null,
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
          SizedBox(height: 12),

          // End Date
          TextField(
            controller: _endDateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "End Date",
              hintText: _selectedEndDate != null
                  ? "${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}"
                  : "dd/mm/yyyy",
              border: OutlineInputBorder(),
              floatingLabelBehavior: _selectedStartDate != null
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.auto,
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_month),
                onPressed: () => _pickEndDate(context),
              ),
              errorText: _validateEndDate ? "Enter a valid end date" : null,
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _wprNumController.clear(); // Clear input fields
            _startDateController.clear();
            _endDateController.clear();

            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              addWprToFirestore();
            });
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          child: Text("Save",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
      ],
    );
  }
}

class UpdateWPR extends StatefulWidget {
  final String? wprId;
  final String? wprNum;
  final String? startDate;
  final String? endDate;

  const UpdateWPR({
    Key? key,
    this.wprId,
    this.wprNum,
    this.startDate,
    this.endDate
  }): super(key: key);

  @override
  _UpdateWPRState createState() => _UpdateWPRState();
}

class _UpdateWPRState extends State<UpdateWPR> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool _isLoading = true;
  bool _validateWprNum = false;
  bool _validateStartDate = false;
  bool _validateEndDate = false;

  final TextEditingController _wprNumController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadExistingWprData();
  }

  Future<void> _loadExistingWprData() async {
    if (widget.wprId == null) return;

    try {
      DocumentSnapshot doc = await _firestore.collection('wpr_logs').doc(widget.wprId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        setState(() {
          _wprNumController.text = data['wprNum'].toString();
          _startDateController.text = data['startDate'] ?? '';
          _endDateController.text = data['endDate'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Failed to load WPR data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load existing log data.")),
      );
    }
  }

  void _pickStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _pickEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> updateWpr() async {
    if (widget.wprId == null) return;

    String currentWprNum = widget.wprNum ?? '';
    String currentStart = widget.startDate ?? '';
    String currentEnd = widget.endDate ?? '';

    String newWprNum = _wprNumController.text.trim();
    String newStart = _startDateController.text.trim();
    String newEnd = _endDateController.text.trim();

    bool unchanged = newWprNum == currentWprNum &&
        newStart == currentStart &&
        newEnd == currentEnd;

    if (unchanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No changes have been made."), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _validateWprNum = newWprNum.isEmpty;
      _validateStartDate = newStart.isEmpty;
      _validateEndDate = newEnd.isEmpty;
    });

    if (_validateWprNum || _validateStartDate || _validateEndDate) return;

    try {
      await _firestore.collection('wpr_logs').doc(widget.wprId).update({
        'wprNum': int.parse(newWprNum),
        'startDate': newStart,
        'endDate': newEnd,
        'updated_at': FieldValue.serverTimestamp(),
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("WPR log updated successfully!"), backgroundColor: Colors.green),
      // );

      await Future.delayed(Duration(seconds: 2));

      _wprNumController.clear();
      _startDateController.clear();
      _endDateController.clear();

      Navigator.of(context).pop();
    } catch (e) {
      print("Update failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update log. Please try again."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : AlertDialog(
      title: Text("Update Weekly Progress Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _wprNumController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "WPR #",
              border: OutlineInputBorder(),
              errorText: _validateWprNum ? "Enter a valid number" : null,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (text) {
              setState(() {
                if (text == "0" || text == "00" || (text.startsWith('0') && text.length > 1)) {
                  _wprNumController.clear();
                  _validateWprNum = true;
                } else {
                  _validateWprNum = false;
                }
              });
            },
          ),
          SizedBox(height: 12),
          TextField(
            controller: _startDateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Start Date",
              hintText: "dd/mm/yyyy",
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_month),
                onPressed: () => _pickStartDate(context),
              ),
              errorText: _validateStartDate ? "Enter a valid start date" : null,
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _endDateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "End Date",
              hintText: "dd/mm/yyyy",
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_month),
                onPressed: () => _pickEndDate(context),
              ),
              errorText: _validateEndDate ? "Enter a valid end date" : null,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _wprNumController.clear();
            _startDateController.clear();
            _endDateController.clear();
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: updateWpr,
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.homeSmile),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.documentAdd),
          label: "WPR",
        ),
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.userCircle),
          label: "Profile",
        ),
      ],
    );
  }
}