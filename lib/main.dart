import 'package:flutter/material.dart';
import 'package:intern_flutter/pages/add_log_page.dart';
import 'package:intern_flutter/pages/profile_page.dart';
import 'package:intern_flutter/pages/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern_flutter/pages/weekly_tasks_page.dart';
import 'package:gif/gif.dart';
import 'package:intern_flutter/pages/onboarding_page.dart';
import 'package:flutter/services.dart';

//controllers
final TextEditingController _startDateController = TextEditingController();
final TextEditingController _endDateController = TextEditingController();
final TextEditingController _wprNumController = TextEditingController();

//validations
bool _validateStartDate = false;
bool _validateEndDate = false;
bool _validateWprNum = false;

void main() {
  runApp(const MyApp());
  // runApp(const register_page());
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
          title: Text("Add Progress"),
          leading: Icon(Icons.add),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => add_log_page())),
        ),
        // ListTile(
        //   title: Text("My Intern"),
        //   leading: Icon(Icons.person),
        //   onTap: () => Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => profile_page(internData: ,))),
        // ),
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

class ProgressSection extends StatelessWidget{
  const ProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration:
            BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )
            ),
            padding: EdgeInsets.all(24),
            child:
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Expected end of internship by:",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "May 02, 2025",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 15),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: 0.6,
                          strokeWidth: 8,
                          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
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
                  SizedBox(height: 10), //Separator between ProgressIndicator and Hours
                  Text(
                    "300/500 hours",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    "UI/UX Designer",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                    ),
                  ),
                  Text(
                    "Symph",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WeeklyProgressSection extends StatelessWidget{
  const WeeklyProgressSection({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(padding: EdgeInsets.symmetric(vertical: 5),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Weekly Progress Reports", style:
          TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          ),
          SizedBox(height: 10,),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(16)
            ),
            child: ListTile(
              leading: Icon(Icons.assignment, color: Theme.of(context).colorScheme.primary, size: 30,),
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
                // lipat page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => weekly_tasks_page()),
                );
              },
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(16)
            ),
            child: ListTile(
              leading: Icon(Icons.assignment, color: Theme.of(context).colorScheme.primary, size: 30),
              title: Text("Weekly Progress Report 2",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
              subtitle: Text("Feb 24, 2025 - Feb 28, 2025",
                style: TextStyle(
                    fontSize: 14
                ),
              ),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(16)
            ),
            child: ListTile(
              leading: Icon(Icons.assignment, color: Theme.of(context).colorScheme.primary, size: 30),
              title: Text("Weekly Progress Report 3",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
              subtitle: Text("Mar 03, 2025 - Mar 07, 2025",
                style: TextStyle(
                    fontSize: 14
                ),
              ),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(16)
            ),
            child: ListTile(
              leading: Icon(Icons.assignment, color: Theme.of(context).colorScheme.primary, size: 30),
              title: Text("Weekly Progress Report 4",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text("Mar 10, 2025 - Mar 14, 2025",
                style: TextStyle(
                    fontSize: 14
                ),
              ),
              trailing: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  @override
  _AddWPRState createState() => _AddWPRState();
}

class _AddWPRState extends State<AddWPR> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  void _pickStartDate(BuildContext context) async {
    DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedStartDate != null) {
      setState(() {
        _selectedStartDate = pickedStartDate;
        _startDateController.text =
        "${pickedStartDate.day}/${pickedStartDate.month}/${pickedStartDate.year}";

        _validateStartDate = false; //clear error if valid date is selected
      });
    }
  }

  void _pickEndDate(BuildContext context) async {
    DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedEndDate != null) {
      setState(() {
        _selectedEndDate = pickedEndDate;
        _endDateController.text =
        "${pickedEndDate.day}/${pickedEndDate.month}/${pickedEndDate.year}";

        _validateEndDate = false; //clear error if valid date is selected
      });
    }
  }

  //validations
  void validateWprFields() {
    // setState(() {
    //   // _validateStartDate = _startDateController.text.isEmpty;
    //   _validateStartDate = _selectedStartDate == null;
    //   // _validateEndDate = _endDateController.text.isEmpty;
    //   _validateEndDate = _selectedStartDate == null;
    //   _validateWprNum = _wprNumController.text.isEmpty;
    // });

    //ginanto ko kasi may scenario na nawawala yung error checking/warning sa EndDate pag sinave ko kahit StartDate lng may laman
    setState(() {
      if (_wprNumController.text.isEmpty) {
        _validateWprNum = true;
      }
      if (_selectedStartDate == null) {
        _validateStartDate = true;
      }
      if (_selectedEndDate == null) {
        _validateEndDate = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Weekly Progress Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
              validateWprFields();

              if (!_validateStartDate && !_validateEndDate) {
                validateWprFields();
              }
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