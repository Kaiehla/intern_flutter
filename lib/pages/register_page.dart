import 'package:flutter/material.dart';
import 'package:intern_flutter/pages/add_log_page.dart';
import 'package:intern_flutter/pages/profile_page.dart';
import 'package:intern_flutter/main.dart';
import 'package:flutter/services.dart';

class register_page extends StatelessWidget {
  const register_page({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const String appTitle = "Create Intern ID";

    return MaterialApp(
        title: appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
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
                  AvatarSection(),
                  // ImageFieldSection(),
                  TextFieldSection(),
                  ButtonFieldSection(),
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

// for every class, dapat may extends or constructor ng widget state
class TextFieldSection extends StatefulWidget {
  const TextFieldSection({super.key});

  // state ng 2 datepickers
  @override
  _TextFieldSectionState createState() => _TextFieldSectionState();
}

class _TextFieldSectionState extends State<TextFieldSection> {
  DateTime? _selectedBirthday;
  DateTime? _selectedStartDate;

  // state ng birthday
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
      });
    }
  }

  // state ng start date
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
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Name & Last Name
          Row(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),

          // Birthday
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: TextField(
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
            ),
          ),

          // School
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: TextField(
              decoration: InputDecoration(
                labelText: "School",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Divider - tried sizebox instead of padding wala lang trip ko lang hehe gumana naman
          SizedBox(height: 16),
          Divider(
            color: Theme.of(context).colorScheme.outlineVariant,
            thickness: 1,
          ),

          // Internship Company
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Internship Company",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Intern Position
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Intern Position",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Start Date & Hours Required -tried padding then row gumana naman
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                        icon: Icon(Icons.cake_rounded),
                        onPressed: () => _pickStartDate(context),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Hours Required",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
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

class ButtonFieldSection extends StatelessWidget {
  const ButtonFieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp())),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageFieldSection extends StatelessWidget {
  const ImageFieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Container(
        height: 120.0,
        width: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Kaiehla.jpg'),
              // fit: BoxFit.cover,
            ),
            shape: BoxShape.circle),
      ),
    );
  }
}

class AvatarSection extends StatelessWidget {
  const AvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: CircleAvatar(
          radius: 65,
          child: Icon(Icons.person, size: 80),
        ),
      ),
    );
  }
}
