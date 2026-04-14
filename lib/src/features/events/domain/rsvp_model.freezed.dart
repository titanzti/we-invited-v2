// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rsvp_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RSVPModel _$RSVPModelFromJson(Map<String, dynamic> json) {
  return _RSVPModel.fromJson(json);
}

/// @nodoc
mixin _$RSVPModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  @RSVPStatusConverter()
  RSVPStatus get status => throw _privateConstructorUsedError;
  int get guestCount => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  RSVPUserModel? get user => throw _privateConstructorUsedError;
  RSVPEventModel? get event => throw _privateConstructorUsedError;

  /// Serializes this RSVPModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RSVPModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RSVPModelCopyWith<RSVPModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RSVPModelCopyWith<$Res> {
  factory $RSVPModelCopyWith(RSVPModel value, $Res Function(RSVPModel) then) =
      _$RSVPModelCopyWithImpl<$Res, RSVPModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String userId,
    @RSVPStatusConverter() RSVPStatus status,
    int guestCount,
    String? note,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    RSVPUserModel? user,
    RSVPEventModel? event,
  });

  $RSVPUserModelCopyWith<$Res>? get user;
  $RSVPEventModelCopyWith<$Res>? get event;
}

/// @nodoc
class _$RSVPModelCopyWithImpl<$Res, $Val extends RSVPModel>
    implements $RSVPModelCopyWith<$Res> {
  _$RSVPModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RSVPModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? status = null,
    Object? guestCount = null,
    Object? note = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? user = freezed,
    Object? event = freezed,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RSVPStatus,
            guestCount: null == guestCount
                ? _value.guestCount
                : guestCount // ignore: cast_nullable_to_non_nullable
                      as int,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as RSVPUserModel?,
            event: freezed == event
                ? _value.event
                : event // ignore: cast_nullable_to_non_nullable
                      as RSVPEventModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of RSVPModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RSVPUserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $RSVPUserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of RSVPModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RSVPEventModelCopyWith<$Res>? get event {
    if (_value.event == null) {
      return null;
    }

    return $RSVPEventModelCopyWith<$Res>(_value.event!, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RSVPModelImplCopyWith<$Res>
    implements $RSVPModelCopyWith<$Res> {
  factory _$$RSVPModelImplCopyWith(
    _$RSVPModelImpl value,
    $Res Function(_$RSVPModelImpl) then,
  ) = __$$RSVPModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String userId,
    @RSVPStatusConverter() RSVPStatus status,
    int guestCount,
    String? note,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    RSVPUserModel? user,
    RSVPEventModel? event,
  });

  @override
  $RSVPUserModelCopyWith<$Res>? get user;
  @override
  $RSVPEventModelCopyWith<$Res>? get event;
}

/// @nodoc
class __$$RSVPModelImplCopyWithImpl<$Res>
    extends _$RSVPModelCopyWithImpl<$Res, _$RSVPModelImpl>
    implements _$$RSVPModelImplCopyWith<$Res> {
  __$$RSVPModelImplCopyWithImpl(
    _$RSVPModelImpl _value,
    $Res Function(_$RSVPModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RSVPModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? status = null,
    Object? guestCount = null,
    Object? note = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? user = freezed,
    Object? event = freezed,
  }) {
    return _then(
      _$RSVPModelImpl(
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RSVPStatus,
        guestCount: null == guestCount
            ? _value.guestCount
            : guestCount // ignore: cast_nullable_to_non_nullable
                  as int,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as RSVPUserModel?,
        event: freezed == event
            ? _value.event
            : event // ignore: cast_nullable_to_non_nullable
                  as RSVPEventModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RSVPModelImpl implements _RSVPModel {
  const _$RSVPModelImpl({
    required this.id,
    required this.eventId,
    required this.userId,
    @RSVPStatusConverter() required this.status,
    this.guestCount = 0,
    this.note,
    @JsonKey(name: 'createdAt') this.createdAt,
    @JsonKey(name: 'updatedAt') this.updatedAt,
    this.user,
    this.event,
  });

  factory _$RSVPModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RSVPModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String userId;
  @override
  @RSVPStatusConverter()
  final RSVPStatus status;
  @override
  @JsonKey()
  final int guestCount;
  @override
  final String? note;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  @override
  final RSVPUserModel? user;
  @override
  final RSVPEventModel? event;

  @override
  String toString() {
    return 'RSVPModel(id: $id, eventId: $eventId, userId: $userId, status: $status, guestCount: $guestCount, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RSVPModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.guestCount, guestCount) ||
                other.guestCount == guestCount) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.event, event) || other.event == event));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    userId,
    status,
    guestCount,
    note,
    createdAt,
    updatedAt,
    user,
    event,
  );

  /// Create a copy of RSVPModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RSVPModelImplCopyWith<_$RSVPModelImpl> get copyWith =>
      __$$RSVPModelImplCopyWithImpl<_$RSVPModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RSVPModelImplToJson(this);
  }
}

abstract class _RSVPModel implements RSVPModel {
  const factory _RSVPModel({
    required final String id,
    required final String eventId,
    required final String userId,
    @RSVPStatusConverter() required final RSVPStatus status,
    final int guestCount,
    final String? note,
    @JsonKey(name: 'createdAt') final DateTime? createdAt,
    @JsonKey(name: 'updatedAt') final DateTime? updatedAt,
    final RSVPUserModel? user,
    final RSVPEventModel? event,
  }) = _$RSVPModelImpl;

  factory _RSVPModel.fromJson(Map<String, dynamic> json) =
      _$RSVPModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get userId;
  @override
  @RSVPStatusConverter()
  RSVPStatus get status;
  @override
  int get guestCount;
  @override
  String? get note;
  @override
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt;
  @override
  RSVPUserModel? get user;
  @override
  RSVPEventModel? get event;

  /// Create a copy of RSVPModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RSVPModelImplCopyWith<_$RSVPModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RSVPUserModel _$RSVPUserModelFromJson(Map<String, dynamic> json) {
  return _RSVPUserModel.fromJson(json);
}

/// @nodoc
mixin _$RSVPUserModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  /// Serializes this RSVPUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RSVPUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RSVPUserModelCopyWith<RSVPUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RSVPUserModelCopyWith<$Res> {
  factory $RSVPUserModelCopyWith(
    RSVPUserModel value,
    $Res Function(RSVPUserModel) then,
  ) = _$RSVPUserModelCopyWithImpl<$Res, RSVPUserModel>;
  @useResult
  $Res call({String id, String name, String email, String? image});
}

/// @nodoc
class _$RSVPUserModelCopyWithImpl<$Res, $Val extends RSVPUserModel>
    implements $RSVPUserModelCopyWith<$Res> {
  _$RSVPUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RSVPUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? image = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RSVPUserModelImplCopyWith<$Res>
    implements $RSVPUserModelCopyWith<$Res> {
  factory _$$RSVPUserModelImplCopyWith(
    _$RSVPUserModelImpl value,
    $Res Function(_$RSVPUserModelImpl) then,
  ) = __$$RSVPUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String email, String? image});
}

/// @nodoc
class __$$RSVPUserModelImplCopyWithImpl<$Res>
    extends _$RSVPUserModelCopyWithImpl<$Res, _$RSVPUserModelImpl>
    implements _$$RSVPUserModelImplCopyWith<$Res> {
  __$$RSVPUserModelImplCopyWithImpl(
    _$RSVPUserModelImpl _value,
    $Res Function(_$RSVPUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RSVPUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? image = freezed,
  }) {
    return _then(
      _$RSVPUserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RSVPUserModelImpl implements _RSVPUserModel {
  const _$RSVPUserModelImpl({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory _$RSVPUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RSVPUserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String? image;

  @override
  String toString() {
    return 'RSVPUserModel(id: $id, name: $name, email: $email, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RSVPUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, image);

  /// Create a copy of RSVPUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RSVPUserModelImplCopyWith<_$RSVPUserModelImpl> get copyWith =>
      __$$RSVPUserModelImplCopyWithImpl<_$RSVPUserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RSVPUserModelImplToJson(this);
  }
}

abstract class _RSVPUserModel implements RSVPUserModel {
  const factory _RSVPUserModel({
    required final String id,
    required final String name,
    required final String email,
    final String? image,
  }) = _$RSVPUserModelImpl;

  factory _RSVPUserModel.fromJson(Map<String, dynamic> json) =
      _$RSVPUserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String? get image;

  /// Create a copy of RSVPUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RSVPUserModelImplCopyWith<_$RSVPUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RSVPEventModel _$RSVPEventModelFromJson(Map<String, dynamic> json) {
  return _RSVPEventModel.fromJson(json);
}

/// @nodoc
mixin _$RSVPEventModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'startDate')
  DateTime? get startDate => throw _privateConstructorUsedError;

  /// Serializes this RSVPEventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RSVPEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RSVPEventModelCopyWith<RSVPEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RSVPEventModelCopyWith<$Res> {
  factory $RSVPEventModelCopyWith(
    RSVPEventModel value,
    $Res Function(RSVPEventModel) then,
  ) = _$RSVPEventModelCopyWithImpl<$Res, RSVPEventModel>;
  @useResult
  $Res call({
    String id,
    String title,
    @JsonKey(name: 'startDate') DateTime? startDate,
  });
}

/// @nodoc
class _$RSVPEventModelCopyWithImpl<$Res, $Val extends RSVPEventModel>
    implements $RSVPEventModelCopyWith<$Res> {
  _$RSVPEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RSVPEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? startDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RSVPEventModelImplCopyWith<$Res>
    implements $RSVPEventModelCopyWith<$Res> {
  factory _$$RSVPEventModelImplCopyWith(
    _$RSVPEventModelImpl value,
    $Res Function(_$RSVPEventModelImpl) then,
  ) = __$$RSVPEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    @JsonKey(name: 'startDate') DateTime? startDate,
  });
}

/// @nodoc
class __$$RSVPEventModelImplCopyWithImpl<$Res>
    extends _$RSVPEventModelCopyWithImpl<$Res, _$RSVPEventModelImpl>
    implements _$$RSVPEventModelImplCopyWith<$Res> {
  __$$RSVPEventModelImplCopyWithImpl(
    _$RSVPEventModelImpl _value,
    $Res Function(_$RSVPEventModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RSVPEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? startDate = freezed,
  }) {
    return _then(
      _$RSVPEventModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RSVPEventModelImpl implements _RSVPEventModel {
  const _$RSVPEventModelImpl({
    required this.id,
    required this.title,
    @JsonKey(name: 'startDate') this.startDate,
  });

  factory _$RSVPEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RSVPEventModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey(name: 'startDate')
  final DateTime? startDate;

  @override
  String toString() {
    return 'RSVPEventModel(id: $id, title: $title, startDate: $startDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RSVPEventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, startDate);

  /// Create a copy of RSVPEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RSVPEventModelImplCopyWith<_$RSVPEventModelImpl> get copyWith =>
      __$$RSVPEventModelImplCopyWithImpl<_$RSVPEventModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RSVPEventModelImplToJson(this);
  }
}

abstract class _RSVPEventModel implements RSVPEventModel {
  const factory _RSVPEventModel({
    required final String id,
    required final String title,
    @JsonKey(name: 'startDate') final DateTime? startDate,
  }) = _$RSVPEventModelImpl;

  factory _RSVPEventModel.fromJson(Map<String, dynamic> json) =
      _$RSVPEventModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'startDate')
  DateTime? get startDate;

  /// Create a copy of RSVPEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RSVPEventModelImplCopyWith<_$RSVPEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RSVPStats _$RSVPStatsFromJson(Map<String, dynamic> json) {
  return _RSVPStats.fromJson(json);
}

/// @nodoc
mixin _$RSVPStats {
  int get going => throw _privateConstructorUsedError;
  int get maybe => throw _privateConstructorUsedError;
  int get notGoing => throw _privateConstructorUsedError;
  int get totalGuests => throw _privateConstructorUsedError;
  int get totalResponses => throw _privateConstructorUsedError;

  /// Serializes this RSVPStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RSVPStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RSVPStatsCopyWith<RSVPStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RSVPStatsCopyWith<$Res> {
  factory $RSVPStatsCopyWith(RSVPStats value, $Res Function(RSVPStats) then) =
      _$RSVPStatsCopyWithImpl<$Res, RSVPStats>;
  @useResult
  $Res call({
    int going,
    int maybe,
    int notGoing,
    int totalGuests,
    int totalResponses,
  });
}

/// @nodoc
class _$RSVPStatsCopyWithImpl<$Res, $Val extends RSVPStats>
    implements $RSVPStatsCopyWith<$Res> {
  _$RSVPStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RSVPStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? going = null,
    Object? maybe = null,
    Object? notGoing = null,
    Object? totalGuests = null,
    Object? totalResponses = null,
  }) {
    return _then(
      _value.copyWith(
            going: null == going
                ? _value.going
                : going // ignore: cast_nullable_to_non_nullable
                      as int,
            maybe: null == maybe
                ? _value.maybe
                : maybe // ignore: cast_nullable_to_non_nullable
                      as int,
            notGoing: null == notGoing
                ? _value.notGoing
                : notGoing // ignore: cast_nullable_to_non_nullable
                      as int,
            totalGuests: null == totalGuests
                ? _value.totalGuests
                : totalGuests // ignore: cast_nullable_to_non_nullable
                      as int,
            totalResponses: null == totalResponses
                ? _value.totalResponses
                : totalResponses // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RSVPStatsImplCopyWith<$Res>
    implements $RSVPStatsCopyWith<$Res> {
  factory _$$RSVPStatsImplCopyWith(
    _$RSVPStatsImpl value,
    $Res Function(_$RSVPStatsImpl) then,
  ) = __$$RSVPStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int going,
    int maybe,
    int notGoing,
    int totalGuests,
    int totalResponses,
  });
}

/// @nodoc
class __$$RSVPStatsImplCopyWithImpl<$Res>
    extends _$RSVPStatsCopyWithImpl<$Res, _$RSVPStatsImpl>
    implements _$$RSVPStatsImplCopyWith<$Res> {
  __$$RSVPStatsImplCopyWithImpl(
    _$RSVPStatsImpl _value,
    $Res Function(_$RSVPStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RSVPStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? going = null,
    Object? maybe = null,
    Object? notGoing = null,
    Object? totalGuests = null,
    Object? totalResponses = null,
  }) {
    return _then(
      _$RSVPStatsImpl(
        going: null == going
            ? _value.going
            : going // ignore: cast_nullable_to_non_nullable
                  as int,
        maybe: null == maybe
            ? _value.maybe
            : maybe // ignore: cast_nullable_to_non_nullable
                  as int,
        notGoing: null == notGoing
            ? _value.notGoing
            : notGoing // ignore: cast_nullable_to_non_nullable
                  as int,
        totalGuests: null == totalGuests
            ? _value.totalGuests
            : totalGuests // ignore: cast_nullable_to_non_nullable
                  as int,
        totalResponses: null == totalResponses
            ? _value.totalResponses
            : totalResponses // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RSVPStatsImpl implements _RSVPStats {
  const _$RSVPStatsImpl({
    this.going = 0,
    this.maybe = 0,
    this.notGoing = 0,
    this.totalGuests = 0,
    this.totalResponses = 0,
  });

  factory _$RSVPStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RSVPStatsImplFromJson(json);

  @override
  @JsonKey()
  final int going;
  @override
  @JsonKey()
  final int maybe;
  @override
  @JsonKey()
  final int notGoing;
  @override
  @JsonKey()
  final int totalGuests;
  @override
  @JsonKey()
  final int totalResponses;

  @override
  String toString() {
    return 'RSVPStats(going: $going, maybe: $maybe, notGoing: $notGoing, totalGuests: $totalGuests, totalResponses: $totalResponses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RSVPStatsImpl &&
            (identical(other.going, going) || other.going == going) &&
            (identical(other.maybe, maybe) || other.maybe == maybe) &&
            (identical(other.notGoing, notGoing) ||
                other.notGoing == notGoing) &&
            (identical(other.totalGuests, totalGuests) ||
                other.totalGuests == totalGuests) &&
            (identical(other.totalResponses, totalResponses) ||
                other.totalResponses == totalResponses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    going,
    maybe,
    notGoing,
    totalGuests,
    totalResponses,
  );

  /// Create a copy of RSVPStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RSVPStatsImplCopyWith<_$RSVPStatsImpl> get copyWith =>
      __$$RSVPStatsImplCopyWithImpl<_$RSVPStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RSVPStatsImplToJson(this);
  }
}

abstract class _RSVPStats implements RSVPStats {
  const factory _RSVPStats({
    final int going,
    final int maybe,
    final int notGoing,
    final int totalGuests,
    final int totalResponses,
  }) = _$RSVPStatsImpl;

  factory _RSVPStats.fromJson(Map<String, dynamic> json) =
      _$RSVPStatsImpl.fromJson;

  @override
  int get going;
  @override
  int get maybe;
  @override
  int get notGoing;
  @override
  int get totalGuests;
  @override
  int get totalResponses;

  /// Create a copy of RSVPStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RSVPStatsImplCopyWith<_$RSVPStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
