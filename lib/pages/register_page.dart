import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intern_flutter/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gif/gif.dart';

class register_page extends StatelessWidget {
  const register_page({super.key});

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
        // LayoutBuilder para magexpand yung content ng page sa buong screen height
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFieldSection(),
                      ButtonFieldSection(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// need gawing stateful para magreflect yung tinatype sa textfields sa ID Card
class TextFieldSection extends StatefulWidget {
  const TextFieldSection({super.key});

  @override
  _TextFieldSectionState createState() => _TextFieldSectionState();
}

class _TextFieldSectionState extends State<TextFieldSection> {
  // Controllers para makuha yung value ng textfields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  // DateTime para sa datepickers 2 states para sa 2 datepickers - birthday at start date
  DateTime? _selectedBirthday;
  DateTime? _selectedStartDate;

  // Birthday Datepicker - frontend validation palang to para bawal piliin yung future date
  void _pickBirthday(BuildContext context) async {
    DateTime? pickedBirthday = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedBirthday != null) {
      setState(() {
        _selectedBirthday = pickedBirthday;
        _birthdayController.text =
            "${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}";
      });
    }
  }

  // Start Date Datepicker
  void _pickStartDate(BuildContext context) async {
    DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedStartDate != null) {
      setState(() {
        _selectedStartDate = pickedStartDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: HeaderLabelSection("Create an Intern ID"),
        ),
        // Intern Card - rereflect dito yung tinatype sa baba; connected to sa kabilang stateless class, pinapasa lang dito sa class yung tinatype from textfields via params
        InternIDCard(
          name: _nameController.text,
          birthday: _birthdayController.text,
          school: _schoolController.text,
          company: _companyController.text,
          position: _positionController.text,
        ),

        // Spacing - pwedeng padding or sizedbox, mas trip ko lang tong sizedbox hehe
        SizedBox(height: 16),

        // Text Fields
        Row(
          children: [
            //  Pronouns Dropdown
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: "Pronouns",
                  border: OutlineInputBorder(),
                ),
                items: ["He/Him", "She/Her", "They/Them"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    // Handle the change
                  });
                },
              ),
            ),
            SizedBox(width: 16),

            // Name
            Expanded(
              flex: 2,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),

        // Birthday - padding and sizedbox same lang ginagawa basta para sa spacing
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: TextField(
            controller: _birthdayController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Birthday",
              hintText: _selectedBirthday != null
                  ? "${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}"
                  : "dd/mm/yyyy",
              border: OutlineInputBorder(),
              floatingLabelBehavior: _selectedBirthday != null
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.auto,
              suffixIcon: IconButton(
                icon: Icon(Icons.cake_rounded),
                onPressed: () => _pickBirthday(context),
              ),
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),

        // School
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: TextField(
            controller: _schoolController,
            decoration: InputDecoration(
              labelText: "School",
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
        SizedBox(height: 4),

        // Divider
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant,
          thickness: 1,
        ),

        // Company
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: TextField(
            controller: _companyController,
            decoration: InputDecoration(
              labelText: "Internship Company",
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),

        // Position
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: TextField(
            controller: _positionController,
            decoration: InputDecoration(
              labelText: "Intern Position",
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),

        // Start Date & Hours Required Row
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Row(
            children: [
              // Start Date
              Expanded(
                child: TextField(
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
                      icon: Icon(Icons.today),
                      onPressed: () => _pickStartDate(context),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 16),

              // Hours Required
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Hours Required",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.timer_outlined)),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Label
class HeaderLabelSection extends StatelessWidget {
  final String label;

  const HeaderLabelSection(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Intern ID Card
class InternIDCard extends StatelessWidget {
  final String name;
  final String birthday;
  final String school;
  final String company;
  final String position;

  // Text Styles for ID Card Details - para isahan lang, class ang peg tatawagin mo nolong
  static const TextStyle idInputStyle = TextStyle(fontSize: 11);
  static const TextStyle idLabelStyle =
      TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

  // Constructor - para maaccess yung mga values ng textfields sa taas
  const InternIDCard({
    required this.name,
    required this.birthday,
    required this.school,
    required this.company,
    required this.position,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
            // double infinity para magexpand yung card sa buong screen width responsive ganern
            width: double.infinity,
            child: Column(
              children: [
                //ID Card Header - Intern & Identification Card No.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Intern",
                        style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "IDENTIFICATION CARD\nNO.213123812\n>",
                        style: TextStyle(fontSize: 12, height: 0.8),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),

                // ID Card Body
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                    ),

                    // Gap
                    SizedBox(width: 14),

                    // ID Details
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          // mainaxis - parang justify  (horizontal) css lang
                          // cross axis - parang align (vertical) css lang
                          // Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Name", style: idLabelStyle)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    name.toUpperCase(),
                                    style: idInputStyle,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          DottedLine(),

                          // Birthday
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Birthday", style: idLabelStyle)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    birthday,
                                    style: idInputStyle,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          DottedLine(),

                          // School
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("School", style: idLabelStyle)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    school.toUpperCase(),
                                    style: idInputStyle,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          DottedLine(),

                          // Company
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Company", style: idLabelStyle)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    company.toUpperCase(),
                                    style: idInputStyle,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          DottedLine(),

                          // Position
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Position", style: idLabelStyle)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    position.toUpperCase(),
                                    style: idInputStyle,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                          DottedLine(),

                          Text(
                            "This card certifies the bearer as an Intern",
                            style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
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
                  "Save",
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
