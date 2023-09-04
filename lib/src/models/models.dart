import 'package:intl/intl.dart';

export 'conversations/conversations.dart';
export 'message/message.dart';
export 'profile/profile.dart';
// static final DateFormat _hourAMPMFormat = DateFormat.jm();

extension DateTimeFormat on DateTime {
  static final DateFormat _hourAMPMFormat = DateFormat.Hm();
  String get hourFormat => _hourAMPMFormat.format(this);
}
