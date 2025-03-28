import 'package:flutter/material.dart';
import 'package:intern_flutter/main.dart';
import 'package:intern_flutter/models/internModel.dart';
import 'package:intern_flutter/pages/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gif/gif.dart';

class profile_page extends StatelessWidget {
  final internModel internData;
  const profile_page({super.key, required this.internData});

  @override
  Widget build(BuildContext context) {
    const String appTitle = "My Profile";

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
              HeaderSection("My Profile"),
              InternIDCard(
                name: internData.name,
                birthday: internData.birthday.toString(),
                school: internData.school,
                company: internData.company,
                position: internData.position,
              ),
              const SizedBox(height: 15),

              // Info Card Row (Start Date and Hours Req)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  InfoCard(
                    title: "Start Date",
                    value: "03/21/25",
                  ),
                  SizedBox(width: 15),
                  InfoCard(
                    title: "Hours Required",
                    value: "500",
                  ),
                ],
              ),

              // General Settings Row
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align the label and card to the left
                  children: [
                    const Text(
                      "General", // Label above the GeneralCard
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // Make it prominent
                      ),
                    ),
                    const SizedBox(height: 8), // Spacing between label and card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GeneralCard(
                            items: const [
                              {'icon': Icons.badge_outlined, 'text': 'Edit My Intern ID'},
                              {'icon': Icons.calendar_month_rounded, 'text': 'Edit Internship Hours & Start Date'},
                              {'icon': Icons.file_upload_outlined, 'text': 'Export all progress and data'},
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Settings Row
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Settings", // Add label above the card
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SettingsCard(
                            items: const [
                              {'icon': Icons.warning_amber_rounded, 'text': 'Erase all my progress and data'},
                              {'icon': Icons.bug_report_outlined, 'text': 'Report a problem'},
                              {'icon': Icons.fact_check_outlined, 'text': 'Terms and Conditions'},
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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

//GENERAL CARD
class GeneralCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const GeneralCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(64, 251, 99, 156),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2), // Black border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Column(
            children: [
              Row(
                children: [
                  Icon(
                    item['icon'],
                    size: 18,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['text'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (item != items.last)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: DottedLine(
                    padding: 1,
                    color: Colors.black, // Match the color of the divider
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const SettingsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(64, 144, 141, 254),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2), // Black border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Column(
            children: [
              Row(
                children: [
                  Icon(
                    item['icon'],
                    size: 18,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['text'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (item != items.last)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: DottedLine(
                    padding: 1,
                    color: Colors.black, // Match the color of the divider
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

   const InfoCard({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFCE520),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2), // Black border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, // Italic title
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
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

class DottedLine extends StatelessWidget {
  final double padding;
  final Color color;

  const DottedLine({this.padding = 1, this.color = Colors.black, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 1.0;
        final dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return Padding(
              padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
              // Adjust the padding value as needed
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
