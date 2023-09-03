import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final supabase = getIt.get<SupabaseClient>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      bottomNavigationBar: ListTile(
        onTap: onSignOut,
        leading: const Icon(Icons.logout),
        title: const Text('Cerrar sesión'),
      ),
    );
  }

  void onSignOut() async {
    try {
      context.showPreloader();
      await supabase.auth.signOut();
      if (!mounted) return;
      await context.hidePreloader();
    } on Exception catch (e) {
      context.showErrorSnackBar(message: e.toString());
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
