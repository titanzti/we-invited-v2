// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JoinRequestModel _$JoinRequestModelFromJson(Map<String, dynamic> json) {
  return _JoinRequestModel.fromJson(json);
}

/// @nodoc
mixin _$JoinRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this JoinRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JoinRequestModelCopyWith<JoinRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinRequestModelCopyWith<$Res> {
  factory $JoinRequestModelCopyWith(
    JoinRequestModel value,
    $Res Function(JoinRequestModel) then,
  ) = _$JoinRequestModelCopyWithImpl<$Res, JoinRequestModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String userId,
    String name,
    String email,
    String status,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$JoinRequestModelCopyWithImpl<$Res, $Val extends JoinRequestModel>
    implements $JoinRequestModelCopyWith<$Res> {
  _$JoinRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? name = null,
    Object? email = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            eventId: null == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JoinRequestModelImplCopyWith<$Res>
    implements $JoinRequestModelCopyWith<$Res> {
  factory _$$JoinRequestModelImplCopyWith(
    _$JoinRequestModelImpl value,
    $Res Function(_$JoinRequestModelImpl) then,
  ) = __$$JoinRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String userId,
    String name,
    String email,
    String status,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$JoinRequestModelImplCopyWithImpl<$Res>
    extends _$JoinRequestModelCopyWithImpl<$Res, _$JoinRequestModelImpl>
    implements _$$JoinRequestModelImplCopyWith<$Res> {
  __$$JoinRequestModelImplCopyWithImpl(
    _$JoinRequestModelImpl _value,
    $Res Function(_$JoinRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? name = null,
    Object? email = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$JoinRequestModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JoinRequestModelImpl implements _JoinRequestModel {
  const _$JoinRequestModelImpl({
    this.id = '',
    this.eventId = '',
    this.userId = '',
    this.name = '',
    this.email = '',
    this.status = 'pending',
    this.createdAt,
  });

  factory _$JoinRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JoinRequestModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String eventId;
  @override
  @JsonKey()
  final String userId;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'JoinRequestModel(id: $id, eventId: $eventId, userId: $userId, name: $name, email: $email, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    userId,
    name,
    email,
    status,
    createdAt,
  );

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinRequestModelImplCopyWith<_$JoinRequestModelImpl> get copyWith =>
      __$$JoinRequestModelImplCopyWithImpl<_$JoinRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JoinRequestModelImplToJson(this);
  }
}

abstract class _JoinRequestModel implements JoinRequestModel {
  const factory _JoinRequestModel({
    final String id,
    final String eventId,
    final String userId,
    final String name,
    final String email,
    final String status,
    final DateTime? createdAt,
  }) = _$JoinRequestModelImpl;

  factory _JoinRequestModel.fromJson(Map<String, dynamic> json) =
      _$JoinRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get userId;
  @override
  String get name;
  @override
  String get email;
  @override
  String get status;
  @override
  DateTime? get createdAt;

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinRequestModelImplCopyWith<_$JoinRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
