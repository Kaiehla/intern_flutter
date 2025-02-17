import 'package:flutter/material.dart';
import 'package:intern_flutter/main.dart';

class profile_page extends StatelessWidget {
  const profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Profile Page Module",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("My Intern"),
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
        )
    );
  }
}
