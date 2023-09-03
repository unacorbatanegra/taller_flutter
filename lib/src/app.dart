import 'package:flutter/material.dart';

import 'presentation/pages/complete_profile/complete_profile.dart';
import 'presentation/pages/conversation/conversation_page.dart';
import 'presentation/pages/login/login_page.dart';
import 'presentation/pages/register/register_page.dart';
import 'presentation/pages/root/root_page.dart';
import 'presentation/pages/splah/splash_page.dart';
import 'presentation/widgets/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splash',
      theme: AppTheme.theme,
      routes: {
        '/login': (ctx) => const LoginPage(),
        '/splash': (ctx) => const SplahPage(),
        '/register': (context) => const RegisterPage(),
        '/completeProfile': (context) => const CompleteProfile(),
        '/conversation': (context) => const ConversationPage(),
        '/': (context) => const RootPage()
      },
    );
  }
}
