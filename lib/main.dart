import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:intern_flutter/pages/add_log_page.dart';
import 'package:intern_flutter/pages/onboarding_page.dart';
import 'package:intern_flutter/pages/profile_page.dart';
import 'package:intern_flutter/pages/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern_flutter/pages/weekly_tasks_page.dart';

void main() {
  runApp(const MyApp());
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
        ),
        debugShowCheckedModeBanner: false,
        home:
        // onboarding_page(),
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
                children: [
                  ProgressSection(),
                  Text(
                    "Weekly Progress Reports",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WeeklyProgressSection()
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: [DrwHeader(), DrwListView()],
            ),
          ),
        )
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
          leading: Icon(Icons.home),
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
          title: Text("Add Entry"),
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

class ProgressSection extends StatelessWidget {
  const ProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Make the column as small as possible
              children: [
                Text(
                  "Expected end of internship by:",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "May 02, 2025",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: 0.6,
                        strokeWidth: 8,
                        backgroundColor: Colors.blueGrey,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                    Text(
                      "60%",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                //Separator between ProgressIndicator and Hours
                Text(
                  "250/500 hours",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  "UI/UX Intern",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Symph",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyProgressSection extends StatelessWidget {
  const WeeklyProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.assignment),
              title: Text(
                "Weekly Progress Report 1",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "Feb 17, 2025 - Feb 21, 2025",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              trailing: Icon(Icons.more_vert),
              onTap: () {
                // Navigate to the target page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => weekly_tasks_page()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.assignment),
              title: Text(
                "Weekly Progress Report 2",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                "Feb 24, 2025 - Feb 28, 2025",
                style: TextStyle(fontSize: 14),
              ),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.assignment),
              title: Text(
                "Weekly Progress Report 3",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                "Mar 03, 2025 - Mar 07, 2025",
                style: TextStyle(fontSize: 14),
              ),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.assignment),
              title: Text(
                "Weekly Progress Report 4",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "Mar 10, 2025 - Mar 14, 2025",
                style: TextStyle(fontSize: 14),
              ),
              trailing: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }
}
