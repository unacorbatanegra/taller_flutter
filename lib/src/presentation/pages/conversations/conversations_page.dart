// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/models.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../add_conversation/add_conversation.dart';
import 'widgets/conversation_widget.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  late Stream<List<Conversation>> _stream;
  final supabase = getIt.get<SupabaseClient>();

  late String id;
  @override
  void initState() {
    if (!mounted) return;
    id = supabase.auth.currentUser?.id ?? '';
    _stream = supabase
        .from('conversations')
        .stream(primaryKey: ['id'])
        .order('modified_at')
        .map((event) => event
            .map((e) => Conversation.fromMap(e))
            .where((a) => a.participants.contains(id))
            .toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversaciones'),
        actions: [
          CupertinoButton(
            onPressed: addConversation,
            child: const Icon(Icons.add_circle),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: StreamBuilder<List<Conversation>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingIndicator;
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No hay conversaciones aún'));
            }
            final list =
                snapshot.data!.where((e) => e.preview.isNotEmpty).toList();
            return ListView.separated(
              itemBuilder: (ctx, idx) {
                final item = list[idx];
                return ConversationWidget(
                  conversation: item,
                  onTap: () => onTap(item),
                );
              },
              separatorBuilder: (ctx, idx) => gap6,
              itemCount: list.length,
            );
          },
        ),
      ),
    );
  }

  void addConversation() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => const AddConversation(),
    );
  }

  void onTap(Conversation item) {
    Navigator.of(context).pushNamed('/conversation', arguments: item);
  }
}
