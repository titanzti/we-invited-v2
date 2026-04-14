import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_prefs_model.freezed.dart';
part 'notification_prefs_model.g.dart';

@freezed
class NotificationPrefsModel with _$NotificationPrefsModel {
  const factory NotificationPrefsModel({
    @Default(true) bool eventReminders,
    @Default(true) bool inviteAlerts,
    @Default(true) bool rsvpUpdates,
    @Default(true) bool eventChanges,
    @Default(false) bool marketingEmails,
  }) = _NotificationPrefsModel;

  factory NotificationPrefsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPrefsModelFromJson(json);
  
  factory NotificationPrefsModel.defaults() => const NotificationPrefsModel();
}
