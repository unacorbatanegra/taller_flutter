import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../models/models.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class ConversationWidget extends StatefulWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  const ConversationWidget({
    Key? key,
    required this.conversation,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  final supabase = getIt.get<SupabaseClient>();
  Future<String> getTitle() async {
    if (widget.conversation.title.isNotEmpty) {
      return widget.conversation.title;
    }
    final myId = supabase.auth.currentUser!.id;
    final id = widget.conversation.participants
        
        .where((e) => e != myId)
        .first;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
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
          return const Center(child: Text('Hubo un error'));
        }
        return ListTile(
          contentPadding: zero,
          leading: CircleAvatar(
            child: Text(snapshot.data!.substring(0, 2)),
          ),
          onTap: widget.onTap,
          subtitle: Row(
            children: [
              Expanded(
                flex: 8,
                child: Text(
                  widget.conversation.preview,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  widget.conversation.modifiedAt!.hourFormat,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          title: Text(snapshot.data!),
        );
      },
    );
  }
}
