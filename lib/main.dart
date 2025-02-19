import 'package:flutter/material.dart';
import 'package:intern_flutter/pages/add_log_page.dart';
import 'package:intern_flutter/pages/profile_page.dart';
import 'package:intern_flutter/pages/register_page.dart';
import 'package:google_fonts/google_fonts.dart';

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
        home: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [

                  ],
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: [DrwHeader(), DrwListView()],
            ),
          ),
        ));
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
      decoration: BoxDecoration(color: Colors.black),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/Kaiehla.jpg'),
            radius: 40,
          ),
          SizedBox(height: 30),
          Text(
            "Kaiehla Espiritu",
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          )
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
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => add_log_page())),
        ),
        ListTile(
          title: Text("My Intern"),
          leading: Icon(Icons.person),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => profile_page())),
        ),
      ]),
    );
  }
}