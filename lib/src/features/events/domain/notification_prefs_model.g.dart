// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_prefs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationPrefsModelImpl _$$NotificationPrefsModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationPrefsModelImpl(
  eventReminders: json['eventReminders'] as bool? ?? true,
  inviteAlerts: json['inviteAlerts'] as bool? ?? true,
  rsvpUpdates: json['rsvpUpdates'] as bool? ?? true,
  eventChanges: json['eventChanges'] as bool? ?? true,
  marketingEmails: json['marketingEmails'] as bool? ?? false,
);

Map<String, dynamic> _$$NotificationPrefsModelImplToJson(
  _$NotificationPrefsModelImpl instance,
) => <String, dynamic>{
  'eventReminders': instance.eventReminders,
  'inviteAlerts': instance.inviteAlerts,
  'rsvpUpdates': instance.rsvpUpdates,
  'eventChanges': instance.eventChanges,
  'marketingEmails': instance.marketingEmails,
};
