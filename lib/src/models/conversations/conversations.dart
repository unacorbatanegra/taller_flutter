// ignore_for_file: public_member_api_docs, sort_constructors_first

class Conversation {
  final String? id;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String? createdBy;
  final String title;
  final List<String> participants;
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
    required List<String> participants,
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
      'participants': participants
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at']).toLocal(),
      modifiedAt: DateTime.parse(map['modified_at']).toLocal(),
      createdBy: map['created_by'] as String,
      title: map['title'] as String,
      participants:
          List.from(map['participants']).map((e) => e as String).toList(),
      preview: map['preview'],
      unread: map['unread'],
    );
  }

  @override
  String toString() {
    return 'Conversation(id: $id, createdAt: $createdAt, modifiedAt: $modifiedAt, createdBy: $createdBy, title: $title, participants: $participants, preview: $preview, unread: $unread)';
  }
}
