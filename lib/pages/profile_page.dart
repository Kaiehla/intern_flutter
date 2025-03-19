import 'package:flutter/material.dart';
import 'package:intern_flutter/main.dart';
import 'package:intern_flutter/pages/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gif/gif.dart';

class profile_page extends StatelessWidget {
  const profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = "Create Intern ID";

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
          title: SizedBox(
            height: 42,
            child: Gif(
              image: AssetImage("logo.gif"),
              autostart: Autostart.loop,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection("My Intern"),
              InternIDCard(
                name: "Kaiehla Espiritu",
                birthday: "04/14/02",
                school: "University of Santo Tomas",
                company: "Symph",
                position: "UI/UX Designer",
              ),
              const SizedBox(height: 15),

              // Additional Cards with Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  InfoCard(
                      title: "Start Date",
                      value: "01/28/25",
                      icon: Icons.calendar_today),
                  SizedBox(width: 15),
                  InfoCard(
                      title: "Hours Required",
                      value: "500",
                      icon: Icons.access_time),
                ],
              ),

              const Spacer(),
              SizedBox(
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
                                color: Theme.of(context).colorScheme.onPrimaryContainer),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.deepPurple), // Icon at the top
              const SizedBox(height: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Label
class HeaderSection extends StatelessWidget {
  final String label;

  const HeaderSection(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontFamily: GoogleFonts.instrumentSerif().fontFamily,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
