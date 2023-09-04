import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taller_flutter/src/presentation/widgets/widgets.dart';

import '../../../utils/utils.dart';

class SplahPage extends StatefulWidget {
  const SplahPage({super.key});

  @override
  State<SplahPage> createState() => _SplahPageState();
}

class _SplahPageState extends State<SplahPage> {
  final supabase = getIt.get<SupabaseClient>();
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await for for the widget to mount
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final session = supabase.auth.currentSession;
    if (session == null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (v) => false);
      return;
    }

    if (!(session.user.userMetadata?.containsKey('profile_completed') ??
        false)) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/completeProfile',
        (v) => false,
      );
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil('/', (v) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            gap64,
            const Image(
              image: AssetImage(
                'assets/images/logo.png',
              ),
            ),
            Text(
              'Chat-C',
              style: context.h6,
            ),
            gap64,
            loadingIndicator,
          ],
        ),
      ),
    );
  }
}
