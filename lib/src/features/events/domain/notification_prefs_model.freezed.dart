// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_prefs_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationPrefsModel _$NotificationPrefsModelFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationPrefsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationPrefsModel {
  bool get eventReminders => throw _privateConstructorUsedError;
  bool get inviteAlerts => throw _privateConstructorUsedError;
  bool get rsvpUpdates => throw _privateConstructorUsedError;
  bool get eventChanges => throw _privateConstructorUsedError;
  bool get marketingEmails => throw _privateConstructorUsedError;

  /// Serializes this NotificationPrefsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPrefsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPrefsModelCopyWith<NotificationPrefsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPrefsModelCopyWith<$Res> {
  factory $NotificationPrefsModelCopyWith(
    NotificationPrefsModel value,
    $Res Function(NotificationPrefsModel) then,
  ) = _$NotificationPrefsModelCopyWithImpl<$Res, NotificationPrefsModel>;
  @useResult
  $Res call({
    bool eventReminders,
    bool inviteAlerts,
    bool rsvpUpdates,
    bool eventChanges,
    bool marketingEmails,
  });
}

/// @nodoc
class _$NotificationPrefsModelCopyWithImpl<
  $Res,
  $Val extends NotificationPrefsModel
>
    implements $NotificationPrefsModelCopyWith<$Res> {
  _$NotificationPrefsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPrefsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventReminders = null,
    Object? inviteAlerts = null,
    Object? rsvpUpdates = null,
    Object? eventChanges = null,
    Object? marketingEmails = null,
  }) {
    return _then(
      _value.copyWith(
            eventReminders: null == eventReminders
                ? _value.eventReminders
                : eventReminders // ignore: cast_nullable_to_non_nullable
                      as bool,
            inviteAlerts: null == inviteAlerts
                ? _value.inviteAlerts
                : inviteAlerts // ignore: cast_nullable_to_non_nullable
                      as bool,
            rsvpUpdates: null == rsvpUpdates
                ? _value.rsvpUpdates
                : rsvpUpdates // ignore: cast_nullable_to_non_nullable
                      as bool,
            eventChanges: null == eventChanges
                ? _value.eventChanges
                : eventChanges // ignore: cast_nullable_to_non_nullable
                      as bool,
            marketingEmails: null == marketingEmails
                ? _value.marketingEmails
                : marketingEmails // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationPrefsModelImplCopyWith<$Res>
    implements $NotificationPrefsModelCopyWith<$Res> {
  factory _$$NotificationPrefsModelImplCopyWith(
    _$NotificationPrefsModelImpl value,
    $Res Function(_$NotificationPrefsModelImpl) then,
  ) = __$$NotificationPrefsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool eventReminders,
    bool inviteAlerts,
    bool rsvpUpdates,
    bool eventChanges,
    bool marketingEmails,
  });
}

/// @nodoc
class __$$NotificationPrefsModelImplCopyWithImpl<$Res>
    extends
        _$NotificationPrefsModelCopyWithImpl<$Res, _$NotificationPrefsModelImpl>
    implements _$$NotificationPrefsModelImplCopyWith<$Res> {
  __$$NotificationPrefsModelImplCopyWithImpl(
    _$NotificationPrefsModelImpl _value,
    $Res Function(_$NotificationPrefsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationPrefsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventReminders = null,
    Object? inviteAlerts = null,
    Object? rsvpUpdates = null,
    Object? eventChanges = null,
    Object? marketingEmails = null,
  }) {
    return _then(
      _$NotificationPrefsModelImpl(
        eventReminders: null == eventReminders
            ? _value.eventReminders
            : eventReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        inviteAlerts: null == inviteAlerts
            ? _value.inviteAlerts
            : inviteAlerts // ignore: cast_nullable_to_non_nullable
                  as bool,
        rsvpUpdates: null == rsvpUpdates
            ? _value.rsvpUpdates
            : rsvpUpdates // ignore: cast_nullable_to_non_nullable
                  as bool,
        eventChanges: null == eventChanges
            ? _value.eventChanges
            : eventChanges // ignore: cast_nullable_to_non_nullable
                  as bool,
        marketingEmails: null == marketingEmails
            ? _value.marketingEmails
            : marketingEmails // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPrefsModelImpl implements _NotificationPrefsModel {
  const _$NotificationPrefsModelImpl({
    this.eventReminders = true,
    this.inviteAlerts = true,
    this.rsvpUpdates = true,
    this.eventChanges = true,
    this.marketingEmails = false,
  });

  factory _$NotificationPrefsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationPrefsModelImplFromJson(json);

  @override
  @JsonKey()
  final bool eventReminders;
  @override
  @JsonKey()
  final bool inviteAlerts;
  @override
  @JsonKey()
  final bool rsvpUpdates;
  @override
  @JsonKey()
  final bool eventChanges;
  @override
  @JsonKey()
  final bool marketingEmails;

  @override
  String toString() {
    return 'NotificationPrefsModel(eventReminders: $eventReminders, inviteAlerts: $inviteAlerts, rsvpUpdates: $rsvpUpdates, eventChanges: $eventChanges, marketingEmails: $marketingEmails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPrefsModelImpl &&
            (identical(other.eventReminders, eventReminders) ||
                other.eventReminders == eventReminders) &&
            (identical(other.inviteAlerts, inviteAlerts) ||
                other.inviteAlerts == inviteAlerts) &&
            (identical(other.rsvpUpdates, rsvpUpdates) ||
                other.rsvpUpdates == rsvpUpdates) &&
            (identical(other.eventChanges, eventChanges) ||
                other.eventChanges == eventChanges) &&
            (identical(other.marketingEmails, marketingEmails) ||
                other.marketingEmails == marketingEmails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    eventReminders,
    inviteAlerts,
    rsvpUpdates,
    eventChanges,
    marketingEmails,
  );

  /// Create a copy of NotificationPrefsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPrefsModelImplCopyWith<_$NotificationPrefsModelImpl>
  get copyWith =>
      __$$NotificationPrefsModelImplCopyWithImpl<_$NotificationPrefsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPrefsModelImplToJson(this);
  }
}

abstract class _NotificationPrefsModel implements NotificationPrefsModel {
  const factory _NotificationPrefsModel({
    final bool eventReminders,
    final bool inviteAlerts,
    final bool rsvpUpdates,
    final bool eventChanges,
    final bool marketingEmails,
  }) = _$NotificationPrefsModelImpl;

  factory _NotificationPrefsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationPrefsModelImpl.fromJson;

  @override
  bool get eventReminders;
  @override
  bool get inviteAlerts;
  @override
  bool get rsvpUpdates;
  @override
  bool get eventChanges;
  @override
  bool get marketingEmails;

  /// Create a copy of NotificationPrefsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPrefsModelImplCopyWith<_$NotificationPrefsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
