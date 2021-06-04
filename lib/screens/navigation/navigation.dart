import 'package:evenager/screens/navigation/add_event/page.dart';
import 'package:evenager/screens/navigation/your_events/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    YourEvents(),
    AddEvent(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Evenager"),
        centerTitle: true,
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromRGBO(130, 25, 227, 1),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Seus Eventos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: "Agendar Evento",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
