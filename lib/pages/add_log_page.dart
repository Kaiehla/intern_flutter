import 'package:flutter/material.dart';


class add_log_page extends StatelessWidget {
  const add_log_page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Add Log Page Module",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add Log Page Module"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
