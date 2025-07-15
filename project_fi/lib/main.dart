import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrial App EX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomeScreen(),
      color: Colors.amber,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KH"),
        titleTextStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      body: Container(
        child: Text(
          "Welcome!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 235, 178, 7),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Welcome!');
        },
        child: Icon(Icons.arrow_drop_up),
      ),
      endDrawer: Drawer(),
    );
  }
}
