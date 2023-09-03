// ignore_for_file: public_member_api_docs, sort_constructors_first

class Conversation {
  final String? id;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String? createdBy;
  final String title;
  final String participants;
  final String preview;
  final int? unread;
  Conversation({
    required this.id,
    required this.createdAt,
    required this.modifiedAt,
    required this.createdBy,
    required this.title,
    required this.participants,
    this.preview = '',
    this.unread = 0,
  });
  factory Conversation.create({
    String title = '',
    required String participants,
  }) =>
      Conversation(
        id: null,
        createdAt: null,
        modifiedAt: null,
        createdBy: null,
        title: title,
        participants: participants,
        preview: '',
        unread: 0,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'participants': participants,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at']),
      modifiedAt: DateTime.parse(map['modified_at']),
      createdBy: map['created_by'] as String,
      title: map['title'] as String,
      participants: map['participants'],
      preview: map['preview'],
      unread: map['unread'],
    );
  }
}
