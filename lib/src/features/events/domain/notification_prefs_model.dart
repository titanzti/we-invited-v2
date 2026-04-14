class NotificationPrefsModel {
  final bool eventReminders;
  final bool inviteAlerts;
  final bool rsvpUpdates;
  final bool eventChanges;
  final bool marketingEmails;

  NotificationPrefsModel({
    this.eventReminders = true,
    this.inviteAlerts = true,
    this.rsvpUpdates = true,
    this.eventChanges = true,
    this.marketingEmails = false,
  });

  factory NotificationPrefsModel.defaults() => NotificationPrefsModel();

  factory NotificationPrefsModel.fromJson(Map<String, dynamic> json) =>
      NotificationPrefsModel(
        eventReminders: json["eventReminders"] ?? true,
        inviteAlerts: json["inviteAlerts"] ?? true,
        rsvpUpdates: json["rsvpUpdates"] ?? true,
        eventChanges: json["eventChanges"] ?? true,
        marketingEmails: json["marketingEmails"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "eventReminders": eventReminders,
        "inviteAlerts": inviteAlerts,
        "rsvpUpdates": rsvpUpdates,
        "eventChanges": eventChanges,
        "marketingEmails": marketingEmails,
      };

  NotificationPrefsModel copyWith({
    bool? eventReminders,
    bool? inviteAlerts,
    bool? rsvpUpdates,
    bool? eventChanges,
    bool? marketingEmails,
  }) =>
      NotificationPrefsModel(
        eventReminders: eventReminders ?? this.eventReminders,
        inviteAlerts: inviteAlerts ?? this.inviteAlerts,
        rsvpUpdates: rsvpUpdates ?? this.rsvpUpdates,
        eventChanges: eventChanges ?? this.eventChanges,
        marketingEmails: marketingEmails ?? this.marketingEmails,
      );
}
