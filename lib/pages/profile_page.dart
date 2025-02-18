import 'package:flutter/material.dart';
import 'package:intern_flutter/main.dart';

class profile_page extends StatelessWidget {
  const profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Intern"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Kaiehla Espiritu",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              "University of Santo Tomas - Manila",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Birthdate"),
              subtitle: Text("04/14/02"),
            ),
            const ListTile(
              leading: Icon(Icons.badge),
              title: Text("Intern Position"),
              subtitle: Text("UI/UX Designer"),
            ),
            const ListTile(
              leading: Icon(Icons.apartment),
              title: Text("Company"),
              subtitle: Text("Symph"),
            ),
            const ListTile(
              leading: Icon(Icons.access_time),
              title: Text("Hours Required"),
              subtitle: Text("500"),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                        (route) => false, // removes all previous routes
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [DrwHeader(), DrwListView()],
        ),
      ),
    );
  }
}
