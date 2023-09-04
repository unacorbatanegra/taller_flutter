import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/models.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'add_title_overlay/add_title_overlay.dart';

class AddConversation extends StatefulWidget {
  const AddConversation({super.key});

  @override
  State<AddConversation> createState() => _AddConversationState();
}

class _AddConversationState extends State<AddConversation> {
  late Future<List<Profile>> future;

  final participants = <String>{};
  final supabase = getIt.get<SupabaseClient>();

  late String id;
  @override
  void initState() {
    id = supabase.auth.currentUser!.id;
    future = supabase
        .from('profiles')
        .select<List<Map<String, dynamic>>>('*')
        .not('id', 'eq', id)
        .then((value) => value.map((e) => Profile.fromMap(e)).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar conversación'),
        actions: [
          CupertinoButton(
            onPressed: onSave,
            child: const Icon(Icons.done),
          )
        ],
      ),
      body: FutureBuilder<List<Profile>>(
        future: future,
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

          return ListView.separated(
            itemBuilder: (ctx, idx) {
              final item = snapshot.data![idx];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    item.firstName.substring(0, 2),
                  ),
                ),
                title: Text(
                  '${item.firstName} ${item.lastName}',
                ),
                onTap: () => onSelected(item.id),
                trailing: Checkbox.adaptive(
                  value: participants.contains(item.id),
                  onChanged: (v) => onSelected(item.id),
                ),
              );
            },
            separatorBuilder: (ctx, idx) => gap6,
            itemCount: snapshot.data?.length ?? 0,
          );
        },
      ),
    );
  }

  void onSelected(String id) {
    if (participants.contains(id)) {
      setState(() {
        participants.removeWhere((e) => id == e);
      });
    } else {
      setState(() {
        participants.add(id);
      });
    }
  }

  void onSave() async {
    if (participants.isEmpty) {
      context.showErrorSnackBar(message: 'Debe elegir al menos un contacto');
      return;
    }
    late Conversation conversation;
    participants.add(id);
    log.d(participants);
    if (participants.length > 2) {
      final result = await showCupertinoModalPopup(
        context: context,
        builder: (ctx) => const AddTitleOverlay(),
      ) as String?;
      if (result == null) return;
      conversation = Conversation.create(
        participants: participants.toList(),
        title: result,
      );
    } else {
      conversation = Conversation.create(
        participants: participants.toList(),
      );
      try {
        if (!mounted) return;
        context.showPreloader();
        final or =
            'participants.cs.{${participants.toList().reversed.join(',')}}';
        final c = await supabase
            .from('conversations')
            .select<List<Map<String, dynamic>>>()
            .or(or)
            .then(
              (value) => value
                  .map((e) => Conversation.fromMap(e))
                  .where((a) => a.participants.length == 2),
            );

        if (!mounted) return;
        await context.hidePreloader();
        // log.d(c);
        if (c.length > 1) {
          if (!mounted) return;
          context.showErrorSnackBar(message: 'Hubo un problema');
          return;
        }
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(
          '/conversation',
          arguments: c.first,
        );
        return;
      } catch (e) {
        log.d(e);
      }
    }

    try {
      if (!mounted) return;
      context.showPreloader();
      log.d('need to be created');
      final c = await supabase
          .from('conversations')
          .upsert(conversation.toMap())
          .select('*')
          .single()
          .then((value) => Conversation.fromMap(value));
      if (!mounted) return;
      await context.hidePreloader();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        '/conversation',
        arguments: c,
      );
    } on Exception catch (e) {
      if (!mounted) return;
      await context.hidePreloader();
      if (!mounted) return;
      context.showErrorSnackBar(message: e.toString());
      return;
    }
  }
}
