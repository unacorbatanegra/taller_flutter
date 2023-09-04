import 'package:flutter/material.dart';
import 'package:taller_flutter/src/presentation/pages/conversations/conversations_page.dart';
import 'package:taller_flutter/src/presentation/pages/menu/menu_page.dart';
import 'package:taller_flutter/src/presentation/widgets/widgets.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: current,
        children: const [ConversationsPage(), MenuPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onChangeTab,
        currentIndex: current,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Majes.chat_2_line),
            label: 'Conversations',
          ),
          BottomNavigationBarItem(
            label: 'Menu',
            icon: Icon(Icons.menu),
          ),
        ],
      ),
    );
  }

  void onChangeTab(int value) {
    if (value == current) return;
    setState(() {
      current = value;
    });
  }
}
