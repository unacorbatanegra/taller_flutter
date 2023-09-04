import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/models.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'widgets/chat_text_field.dart';
import 'widgets/message_widget.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late Conversation conversation;
  final controller = TextEditingController();
  final supabase = getIt.get<SupabaseClient>();
  late String id;
  Stream<List<Message>>? stream;

  Future<String> getTitle() async {
    await Future.delayed(Duration.zero);
    if (conversation.title.isNotEmpty) {
      return conversation.title;
    }

    final otherId = conversation.participants.where((e) => e != id).first;
    if (Profile.cache.containsKey(otherId)) {
      return Profile.cache[otherId]!.display;
    }
    return supabase
        .from('profiles')
        .select()
        .eq('id', otherId)
        .single()
        .then((value) => Profile.cache[otherId] = Profile.fromMap(value))
        .then((value) => value.display);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Conversation) {
      context.showErrorSnackBar(
        message: 'Hubo un error al obtener la conversación',
      );
      return;
    }
    conversation = args;

    id = supabase.auth.currentUser!.id;
    stream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversation.id)
        .order('created_at')
        .map((event) => event.map((e) => Message.fromMap(e)).toList());
    setState(() {});
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
              return const Center(
                child: Text('No hay mensajes aún.'),
              );
            }
            return Text(snapshot.data!);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: stream,
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
                    return const Center(child: Text('No hay mensajes aún'));
                  }
                  final list = snapshot.data!;
                  if (list.isEmpty) {
                    return const Center(child: Text('No hay mensajes aún'));
                  }
                  return ListView.separated(
                    
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (ctx, idx) {
                      final item = snapshot.data![idx];
                      return MessageWidget(
                        isMine: id == item.createdBy,
                        message: item,
                        onTap: () => onTap(item),
                      );
                    },
                    separatorBuilder: (ctx, idx) => gap6,
                    itemCount: snapshot.data!.length,
                  );
                },
              ),
            ),
            gap8,
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                right: 16,
                // bottom: 32,
              ),
              child: ChatTextField(
                controller: controller,
                hint: 'Enviar mensaje',
                onTap: onSendMessage,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTap(Message item) {}
  bool isLoading = false;
  void onSendMessage() async {
    if (controller.text.isEmpty) return;
    if (isLoading) return;
    try {
      // // context.showPreloader();
      setState(() {
        isLoading = true;
      });

      await supabase.from('messages').insert({
        'conversation_id': conversation.id,
        'content': controller.text.trim(),
      });
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
      return;
    }
    setState(() {
      isLoading = false;
    });

    controller.clear();
  }
}
