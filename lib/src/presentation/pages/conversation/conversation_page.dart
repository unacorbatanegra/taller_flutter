import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taller_flutter/src/presentation/widgets/widgets.dart';

import '../../../models/models.dart';
import '../../../utils/utils.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late Conversation conversation;

  final supabase = getIt.get<SupabaseClient>();
  Future<String> getTitle() async {
    await Future.delayed(Duration.zero);
    if (conversation.title.isNotEmpty) {
      return conversation.title;
    }
    final myId = supabase.auth.currentUser!.id;
    final id =
        conversation.participants.split(',').where((e) => e != myId).first;
    if (Profile.cache.containsKey(id)) {
      return Profile.cache[id]!.display;
    }
    return supabase
        .from('profiles')
        .select()
        .eq('id', id)
        .single()
        .then((value) => Profile.cache[id] = Profile.fromMap(value))
        .then((value) => value.display);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  void init() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Conversation) {
      context.showErrorSnackBar(
        message: 'Hubo un error al obtener la conversación',
      );
      return;
    }
    conversation = args;
    log.d(args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getTitle(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return emptyWidget;
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No hay conversaciones aún'));
            }
            return Text(snapshot.data!);
          },
        ),
      ),
    );
  }
}
