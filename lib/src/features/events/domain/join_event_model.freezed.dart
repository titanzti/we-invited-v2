// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JoinEventModel _$JoinEventModelFromJson(Map<String, dynamic> json) {
  return _JoinEventModel.fromJson(json);
}

/// @nodoc
mixin _$JoinEventModel {
  String get joinid => throw _privateConstructorUsedError;
  String get postid => throw _privateConstructorUsedError;
  String get ownerID => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  String get senderAvatar => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get senderUid => throw _privateConstructorUsedError;
  String get receiverUidjoin => throw _privateConstructorUsedError;
  String get requestpostid => throw _privateConstructorUsedError;
  String get senderEmail => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this JoinEventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JoinEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JoinEventModelCopyWith<JoinEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinEventModelCopyWith<$Res> {
  factory $JoinEventModelCopyWith(
    JoinEventModel value,
    $Res Function(JoinEventModel) then,
  ) = _$JoinEventModelCopyWithImpl<$Res, JoinEventModel>;
  @useResult
  $Res call({
    String joinid,
    String postid,
    String ownerID,
    String ownerName,
    String senderAvatar,
    String senderName,
    String senderUid,
    String receiverUidjoin,
    String requestpostid,
    String senderEmail,
    String status,
    String type,
    String title,
    @DateTimeConverter() DateTime? createdAt,
  });
}

/// @nodoc
class _$JoinEventModelCopyWithImpl<$Res, $Val extends JoinEventModel>
    implements $JoinEventModelCopyWith<$Res> {
  _$JoinEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoinEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? joinid = null,
    Object? postid = null,
    Object? ownerID = null,
    Object? ownerName = null,
    Object? senderAvatar = null,
    Object? senderName = null,
    Object? senderUid = null,
    Object? receiverUidjoin = null,
    Object? requestpostid = null,
    Object? senderEmail = null,
    Object? status = null,
    Object? type = null,
    Object? title = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            joinid: null == joinid
                ? _value.joinid
                : joinid // ignore: cast_nullable_to_non_nullable
                      as String,
            postid: null == postid
                ? _value.postid
                : postid // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerID: null == ownerID
                ? _value.ownerID
                : ownerID // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerName: null == ownerName
                ? _value.ownerName
                : ownerName // ignore: cast_nullable_to_non_nullable
                      as String,
            senderAvatar: null == senderAvatar
                ? _value.senderAvatar
                : senderAvatar // ignore: cast_nullable_to_non_nullable
                      as String,
            senderName: null == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String,
            senderUid: null == senderUid
                ? _value.senderUid
                : senderUid // ignore: cast_nullable_to_non_nullable
                      as String,
            receiverUidjoin: null == receiverUidjoin
                ? _value.receiverUidjoin
                : receiverUidjoin // ignore: cast_nullable_to_non_nullable
                      as String,
            requestpostid: null == requestpostid
                ? _value.requestpostid
                : requestpostid // ignore: cast_nullable_to_non_nullable
                      as String,
            senderEmail: null == senderEmail
                ? _value.senderEmail
                : senderEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
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
abstract class _$$JoinEventModelImplCopyWith<$Res>
    implements $JoinEventModelCopyWith<$Res> {
  factory _$$JoinEventModelImplCopyWith(
    _$JoinEventModelImpl value,
    $Res Function(_$JoinEventModelImpl) then,
  ) = __$$JoinEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String joinid,
    String postid,
    String ownerID,
    String ownerName,
    String senderAvatar,
    String senderName,
    String senderUid,
    String receiverUidjoin,
    String requestpostid,
    String senderEmail,
    String status,
    String type,
    String title,
    @DateTimeConverter() DateTime? createdAt,
  });
}

/// @nodoc
class __$$JoinEventModelImplCopyWithImpl<$Res>
    extends _$JoinEventModelCopyWithImpl<$Res, _$JoinEventModelImpl>
    implements _$$JoinEventModelImplCopyWith<$Res> {
  __$$JoinEventModelImplCopyWithImpl(
    _$JoinEventModelImpl _value,
    $Res Function(_$JoinEventModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoinEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? joinid = null,
    Object? postid = null,
    Object? ownerID = null,
    Object? ownerName = null,
    Object? senderAvatar = null,
    Object? senderName = null,
    Object? senderUid = null,
    Object? receiverUidjoin = null,
    Object? requestpostid = null,
    Object? senderEmail = null,
    Object? status = null,
    Object? type = null,
    Object? title = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$JoinEventModelImpl(
        joinid: null == joinid
            ? _value.joinid
            : joinid // ignore: cast_nullable_to_non_nullable
                  as String,
        postid: null == postid
            ? _value.postid
            : postid // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerID: null == ownerID
            ? _value.ownerID
            : ownerID // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerName: null == ownerName
            ? _value.ownerName
            : ownerName // ignore: cast_nullable_to_non_nullable
                  as String,
        senderAvatar: null == senderAvatar
            ? _value.senderAvatar
            : senderAvatar // ignore: cast_nullable_to_non_nullable
                  as String,
        senderName: null == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String,
        senderUid: null == senderUid
            ? _value.senderUid
            : senderUid // ignore: cast_nullable_to_non_nullable
                  as String,
        receiverUidjoin: null == receiverUidjoin
            ? _value.receiverUidjoin
            : receiverUidjoin // ignore: cast_nullable_to_non_nullable
                  as String,
        requestpostid: null == requestpostid
            ? _value.requestpostid
            : requestpostid // ignore: cast_nullable_to_non_nullable
                  as String,
        senderEmail: null == senderEmail
            ? _value.senderEmail
            : senderEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
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
class _$JoinEventModelImpl implements _JoinEventModel {
  const _$JoinEventModelImpl({
    required this.joinid,
    required this.postid,
    this.ownerID = '',
    this.ownerName = '',
    this.senderAvatar = '',
    this.senderName = '',
    this.senderUid = '',
    this.receiverUidjoin = '',
    this.requestpostid = '',
    this.senderEmail = '',
    this.status = '',
    this.type = '',
    this.title = '',
    @DateTimeConverter() this.createdAt,
  });

  factory _$JoinEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JoinEventModelImplFromJson(json);

  @override
  final String joinid;
  @override
  final String postid;
  @override
  @JsonKey()
  final String ownerID;
  @override
  @JsonKey()
  final String ownerName;
  @override
  @JsonKey()
  final String senderAvatar;
  @override
  @JsonKey()
  final String senderName;
  @override
  @JsonKey()
  final String senderUid;
  @override
  @JsonKey()
  final String receiverUidjoin;
  @override
  @JsonKey()
  final String requestpostid;
  @override
  @JsonKey()
  final String senderEmail;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String title;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;

  @override
  String toString() {
    return 'JoinEventModel(joinid: $joinid, postid: $postid, ownerID: $ownerID, ownerName: $ownerName, senderAvatar: $senderAvatar, senderName: $senderName, senderUid: $senderUid, receiverUidjoin: $receiverUidjoin, requestpostid: $requestpostid, senderEmail: $senderEmail, status: $status, type: $type, title: $title, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinEventModelImpl &&
            (identical(other.joinid, joinid) || other.joinid == joinid) &&
            (identical(other.postid, postid) || other.postid == postid) &&
            (identical(other.ownerID, ownerID) || other.ownerID == ownerID) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.senderAvatar, senderAvatar) ||
                other.senderAvatar == senderAvatar) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderUid, senderUid) ||
                other.senderUid == senderUid) &&
            (identical(other.receiverUidjoin, receiverUidjoin) ||
                other.receiverUidjoin == receiverUidjoin) &&
            (identical(other.requestpostid, requestpostid) ||
                other.requestpostid == requestpostid) &&
            (identical(other.senderEmail, senderEmail) ||
                other.senderEmail == senderEmail) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    joinid,
    postid,
    ownerID,
    ownerName,
    senderAvatar,
    senderName,
    senderUid,
    receiverUidjoin,
    requestpostid,
    senderEmail,
    status,
    type,
    title,
    createdAt,
  );

  /// Create a copy of JoinEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinEventModelImplCopyWith<_$JoinEventModelImpl> get copyWith =>
      __$$JoinEventModelImplCopyWithImpl<_$JoinEventModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JoinEventModelImplToJson(this);
  }
}

abstract class _JoinEventModel implements JoinEventModel {
  const factory _JoinEventModel({
    required final String joinid,
    required final String postid,
    final String ownerID,
    final String ownerName,
    final String senderAvatar,
    final String senderName,
    final String senderUid,
    final String receiverUidjoin,
    final String requestpostid,
    final String senderEmail,
    final String status,
    final String type,
    final String title,
    @DateTimeConverter() final DateTime? createdAt,
  }) = _$JoinEventModelImpl;

  factory _JoinEventModel.fromJson(Map<String, dynamic> json) =
      _$JoinEventModelImpl.fromJson;

  @override
  String get joinid;
  @override
  String get postid;
  @override
  String get ownerID;
  @override
  String get ownerName;
  @override
  String get senderAvatar;
  @override
  String get senderName;
  @override
  String get senderUid;
  @override
  String get receiverUidjoin;
  @override
  String get requestpostid;
  @override
  String get senderEmail;
  @override
  String get status;
  @override
  String get type;
  @override
  String get title;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;

  /// Create a copy of JoinEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinEventModelImplCopyWith<_$JoinEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
