import 'package:flutter/material.dart';

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
      home: DefaultTabController(
        length: 3,
        child: HomeScreen(title: 'Air9')
      ),
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

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Upcoiming Flights"),
              // TODO to add upcoming flights widgets
              ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icons.local_airport,),
            Tab(icon: Icons.search,), 
            Tab(icon: Icons.account_circle)
          ],
        ),
    );
  }
}