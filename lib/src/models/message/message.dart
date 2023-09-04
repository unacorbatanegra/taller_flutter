// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  final String id;
  final String content;
  final String? createdBy;
  final DateTime? createdAt;
  final String conversationId;
  Message({
    required this.id,
    required this.content,
    required this.conversationId,
    this.createdBy,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'conversation_id': conversationId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      conversationId: map['conversation_id'],
      content: map['content'] as String,
      createdBy: map['created_by'] as String,
      createdAt: DateTime.parse(map['created_at']).toLocal(),
    );
  }
}
