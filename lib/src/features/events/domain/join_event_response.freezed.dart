// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_event_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JoinEventResponse _$JoinEventResponseFromJson(Map<String, dynamic> json) {
  return _JoinEventResponse.fromJson(json);
}

/// @nodoc
mixin _$JoinEventResponse {
  String get status => throw _privateConstructorUsedError;

  /// Serializes this JoinEventResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JoinEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JoinEventResponseCopyWith<JoinEventResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinEventResponseCopyWith<$Res> {
  factory $JoinEventResponseCopyWith(
    JoinEventResponse value,
    $Res Function(JoinEventResponse) then,
  ) = _$JoinEventResponseCopyWithImpl<$Res, JoinEventResponse>;
  @useResult
  $Res call({String status});
}

/// @nodoc
class _$JoinEventResponseCopyWithImpl<$Res, $Val extends JoinEventResponse>
    implements $JoinEventResponseCopyWith<$Res> {
  _$JoinEventResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoinEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JoinEventResponseImplCopyWith<$Res>
    implements $JoinEventResponseCopyWith<$Res> {
  factory _$$JoinEventResponseImplCopyWith(
    _$JoinEventResponseImpl value,
    $Res Function(_$JoinEventResponseImpl) then,
  ) = __$$JoinEventResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status});
}

/// @nodoc
class __$$JoinEventResponseImplCopyWithImpl<$Res>
    extends _$JoinEventResponseCopyWithImpl<$Res, _$JoinEventResponseImpl>
    implements _$$JoinEventResponseImplCopyWith<$Res> {
  __$$JoinEventResponseImplCopyWithImpl(
    _$JoinEventResponseImpl _value,
    $Res Function(_$JoinEventResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoinEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _$JoinEventResponseImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JoinEventResponseImpl implements _JoinEventResponse {
  const _$JoinEventResponseImpl({this.status = ''});

  factory _$JoinEventResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$JoinEventResponseImplFromJson(json);

  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'JoinEventResponse(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinEventResponseImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of JoinEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinEventResponseImplCopyWith<_$JoinEventResponseImpl> get copyWith =>
      __$$JoinEventResponseImplCopyWithImpl<_$JoinEventResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JoinEventResponseImplToJson(this);
  }
}

abstract class _JoinEventResponse implements JoinEventResponse {
  const factory _JoinEventResponse({final String status}) =
      _$JoinEventResponseImpl;

  factory _JoinEventResponse.fromJson(Map<String, dynamic> json) =
      _$JoinEventResponseImpl.fromJson;

  @override
  String get status;

  /// Create a copy of JoinEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinEventResponseImplCopyWith<_$JoinEventResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
