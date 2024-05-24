import 'package:chat_app/calls/calls_page.dart';
import 'package:chat_app/home/home_page.dart';
import 'package:flutter/material.dart';
class BottomBar extends StatelessWidget {
  BottomBar({super.key});


  final ValueNotifier<int> selIndex =  ValueNotifier<int>(0);

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const CallsPage(),
  ];

  void _onItemTap(int index) {
      selIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: selIndex,
            builder: (BuildContext context, int value, Widget? child) {
      return _widgetOptions.elementAt(value);
    },),),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: selIndex,
        builder: (BuildContext context, int value, Widget? child) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.teal,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.grey,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.call,
                ),
                label: "Calls",
              ),
            ],
            currentIndex: value,
            onTap: _onItemTap,
            selectedFontSize: 13.0,
            unselectedFontSize: 13.0,
          );
        },
      ),
    );
  }
}