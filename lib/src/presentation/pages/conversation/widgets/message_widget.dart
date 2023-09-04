// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taller_flutter/src/models/models.dart';
import 'package:taller_flutter/src/presentation/widgets/widgets.dart';

import '../../../../utils/utils.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  final VoidCallback onTap;
  final bool isMine;
  const MessageWidget({
    Key? key,
    required this.message,
    required this.onTap,
    required this.isMine,
  }) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final supabase = getIt.get<SupabaseClient>();
  Future<String> getTitle() async {
    await Future.delayed(Duration.zero);
    if (widget.isMine) return '';

    if (Profile.cache.containsKey(widget.message.createdBy)) {
      return Profile.cache[widget.message.createdBy]!.display;
    }
    return supabase
        .from('profiles')
        .select()
        .eq('id', widget.message.createdBy)
        .single()
        .then((value) =>
            Profile.cache[widget.message.createdBy!] = Profile.fromMap(value))
        .then((value) => value.display);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getTitle(),
        builder: (context, snapshot) {
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
          return Align(
            alignment:
                widget.isMine ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              constraints: BoxConstraints(
                maxWidth: context.w * .7,
              ),
              decoration: BoxDecoration(
                color: Palette.gray5,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                crossAxisAlignment: widget.isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!widget.isMine)
                    Text(
                      snapshot.data!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Palette.gray1,
                        fontWeight: FontWeight.w600,
                      ),
                    ).paddingOnly(bottom: 4.0),
                  Text(
                    widget.message.content,
                    style: const TextStyle(fontSize: 14, color: Palette.gray1),
                  ),
                  Text(
                    widget.message.createdAt!.hourFormat,
                    style: const TextStyle(
                      color: Palette.gray2,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
