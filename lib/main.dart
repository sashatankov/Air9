import 'package:flutter/material.dart';
import 'flightWidget.dart';

void main() {
  runApp(Air9App());
}

class Air9App extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabController(length: 3, child: HomeScreen(title: 'Air9')),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: HomeScreenBody(),
      ),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Upcoming Flights",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
          ),
          // TODO to add upcoming flights widgets
        ],
      ),
      bottomNavigationBar: TabBar(
        tabs: [
          Tab(
            icon: Icon(
              Icons.local_airport, 
            color: Colors.blue,
            semanticLabel: "flights",
            ),
          ),
          Tab(
            icon: Icon(
              Icons.search, 
              color: Colors.blue,
              semanticLabel: "Search Flights",),
          ),
          Tab(
            icon: Icon(
              Icons.account_circle, 
              color: Colors.blue,
              semanticLabel: "profile",),
          ),
        ],

      ),
    );
  }
}
