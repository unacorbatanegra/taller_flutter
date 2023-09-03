import 'package:flutter/material.dart';
import 'package:taller_flutter/src/presentation/pages/conversations/conversation_page.dart';
import 'package:taller_flutter/src/presentation/pages/menu/menu_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

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
            icon: Icon(Icons.message),
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
