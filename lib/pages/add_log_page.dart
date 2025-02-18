import 'package:flutter/material.dart';


class add_log_page extends StatelessWidget {
  const add_log_page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Add Logs",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add Logs"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
            //   enter here ung functions sa baba
              ImageFieldSection(),
              TextFieldSection(),
              ButtonFieldSection()
            ],
          )
        )
      ),
    );
  }
}

class ImageFieldSection extends StatelessWidget {
  const ImageFieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              // pic 1
              Expanded(child: Container(
                height: 180,
                width: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/placeholder.png'),
                  fit: BoxFit.fill
                  ),
                  shape: BoxShape.rectangle
                ),
              )
              ),

              // pic 2
              Expanded(child: Container(
                height: 180,
                width: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/placeholder.png'),
                        fit: BoxFit.fill
                    ),
                    shape: BoxShape.rectangle
                ),
              )
              )
            ],
          ), 
        ],
      ),
    );
  }
}

class TextFieldSection extends StatelessWidget {
  const TextFieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(bottom: 10, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Full Name",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                    hintMaxLines: 2
                ),
              )
          ),

          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child:
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email address",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  hintMaxLines: 2,
                ),
              )
              ),

              Expanded(child:
              TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Phone number",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    hintMaxLines: 2,
                  )
              )
              ),
            ],
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
    return Padding(padding: EdgeInsets.all(30),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child:
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: Text("Submit")
            )
            ),
            Expanded(child:
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: Text("Cancel"))
            ),



            // Expanded(child:
            // ElevatedButton.icon(onPressed: () {},
            //     icon: Icon(
            //       Icons.home,
            //       color: Colors.red,
            //       size: 30.0,
            //     ),
            //     label: Text("Enabled with icons"))
            // ),
          ],
        )
    );
  }
}