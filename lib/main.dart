import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taller_flutter/src/utils/utils.dart';

import 'src/app.dart';

void main() async {
  await dotenv.load();
  final supabase = await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_KEY'),
  );

  getIt.registerSingleton(supabase.client);
  runApp(const App());
}
