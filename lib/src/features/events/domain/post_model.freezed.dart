// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  String get postid => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get place => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get startdateTime => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get entdateTime => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get updatedAt => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String get emailuser => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String get postbyname => throw _privateConstructorUsedError;
  String get postbyimage => throw _privateConstructorUsedError;
  @JsonKey(name: 'Numpeople')
  String get numpeople => throw _privateConstructorUsedError;
  String get agerange => throw _privateConstructorUsedError;

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call({
    String postid,
    String uid,
    String name,
    String place,
    @TimestampConverter() Timestamp? startdateTime,
    @TimestampConverter() Timestamp? entdateTime,
    @TimestampConverter() Timestamp? createdAt,
    @TimestampConverter() Timestamp? updatedAt,
    String image,
    String emailuser,
    String address,
    String description,
    String category,
    String gender,
    String postbyname,
    String postbyimage,
    @JsonKey(name: 'Numpeople') String numpeople,
    String agerange,
  });
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postid = null,
    Object? uid = null,
    Object? name = null,
    Object? place = null,
    Object? startdateTime = freezed,
    Object? entdateTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? image = null,
    Object? emailuser = null,
    Object? address = null,
    Object? description = null,
    Object? category = null,
    Object? gender = null,
    Object? postbyname = null,
    Object? postbyimage = null,
    Object? numpeople = null,
    Object? agerange = null,
  }) {
    return _then(
      _value.copyWith(
            postid: null == postid
                ? _value.postid
                : postid // ignore: cast_nullable_to_non_nullable
                      as String,
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            place: null == place
                ? _value.place
                : place // ignore: cast_nullable_to_non_nullable
                      as String,
            startdateTime: freezed == startdateTime
                ? _value.startdateTime
                : startdateTime // ignore: cast_nullable_to_non_nullable
                      as Timestamp?,
            entdateTime: freezed == entdateTime
                ? _value.entdateTime
                : entdateTime // ignore: cast_nullable_to_non_nullable
                      as Timestamp?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as Timestamp?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as Timestamp?,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String,
            emailuser: null == emailuser
                ? _value.emailuser
                : emailuser // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String,
            postbyname: null == postbyname
                ? _value.postbyname
                : postbyname // ignore: cast_nullable_to_non_nullable
                      as String,
            postbyimage: null == postbyimage
                ? _value.postbyimage
                : postbyimage // ignore: cast_nullable_to_non_nullable
                      as String,
            numpeople: null == numpeople
                ? _value.numpeople
                : numpeople // ignore: cast_nullable_to_non_nullable
                      as String,
            agerange: null == agerange
                ? _value.agerange
                : agerange // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
    _$PostModelImpl value,
    $Res Function(_$PostModelImpl) then,
  ) = __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String postid,
    String uid,
    String name,
    String place,
    @TimestampConverter() Timestamp? startdateTime,
    @TimestampConverter() Timestamp? entdateTime,
    @TimestampConverter() Timestamp? createdAt,
    @TimestampConverter() Timestamp? updatedAt,
    String image,
    String emailuser,
    String address,
    String description,
    String category,
    String gender,
    String postbyname,
    String postbyimage,
    @JsonKey(name: 'Numpeople') String numpeople,
    String agerange,
  });
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
    _$PostModelImpl _value,
    $Res Function(_$PostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postid = null,
    Object? uid = null,
    Object? name = null,
    Object? place = null,
    Object? startdateTime = freezed,
    Object? entdateTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? image = null,
    Object? emailuser = null,
    Object? address = null,
    Object? description = null,
    Object? category = null,
    Object? gender = null,
    Object? postbyname = null,
    Object? postbyimage = null,
    Object? numpeople = null,
    Object? agerange = null,
  }) {
    return _then(
      _$PostModelImpl(
        postid: null == postid
            ? _value.postid
            : postid // ignore: cast_nullable_to_non_nullable
                  as String,
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        place: null == place
            ? _value.place
            : place // ignore: cast_nullable_to_non_nullable
                  as String,
        startdateTime: freezed == startdateTime
            ? _value.startdateTime
            : startdateTime // ignore: cast_nullable_to_non_nullable
                  as Timestamp?,
        entdateTime: freezed == entdateTime
            ? _value.entdateTime
            : entdateTime // ignore: cast_nullable_to_non_nullable
                  as Timestamp?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as Timestamp?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as Timestamp?,
        image: null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String,
        emailuser: null == emailuser
            ? _value.emailuser
            : emailuser // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String,
        postbyname: null == postbyname
            ? _value.postbyname
            : postbyname // ignore: cast_nullable_to_non_nullable
                  as String,
        postbyimage: null == postbyimage
            ? _value.postbyimage
            : postbyimage // ignore: cast_nullable_to_non_nullable
                  as String,
        numpeople: null == numpeople
            ? _value.numpeople
            : numpeople // ignore: cast_nullable_to_non_nullable
                  as String,
        agerange: null == agerange
            ? _value.agerange
            : agerange // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl implements _PostModel {
  const _$PostModelImpl({
    required this.postid,
    required this.uid,
    this.name = '',
    this.place = '',
    @TimestampConverter() this.startdateTime,
    @TimestampConverter() this.entdateTime,
    @TimestampConverter() this.createdAt,
    @TimestampConverter() this.updatedAt,
    this.image = '',
    this.emailuser = '',
    this.address = '',
    this.description = '',
    this.category = '',
    this.gender = '',
    this.postbyname = '',
    this.postbyimage = '',
    @JsonKey(name: 'Numpeople') this.numpeople = '',
    this.agerange = '',
  });

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String postid;
  @override
  final String uid;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String place;
  @override
  @TimestampConverter()
  final Timestamp? startdateTime;
  @override
  @TimestampConverter()
  final Timestamp? entdateTime;
  @override
  @TimestampConverter()
  final Timestamp? createdAt;
  @override
  @TimestampConverter()
  final Timestamp? updatedAt;
  @override
  @JsonKey()
  final String image;
  @override
  @JsonKey()
  final String emailuser;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final String gender;
  @override
  @JsonKey()
  final String postbyname;
  @override
  @JsonKey()
  final String postbyimage;
  @override
  @JsonKey(name: 'Numpeople')
  final String numpeople;
  @override
  @JsonKey()
  final String agerange;

  @override
  String toString() {
    return 'PostModel(postid: $postid, uid: $uid, name: $name, place: $place, startdateTime: $startdateTime, entdateTime: $entdateTime, createdAt: $createdAt, updatedAt: $updatedAt, image: $image, emailuser: $emailuser, address: $address, description: $description, category: $category, gender: $gender, postbyname: $postbyname, postbyimage: $postbyimage, numpeople: $numpeople, agerange: $agerange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.postid, postid) || other.postid == postid) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.startdateTime, startdateTime) ||
                other.startdateTime == startdateTime) &&
            (identical(other.entdateTime, entdateTime) ||
                other.entdateTime == entdateTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.emailuser, emailuser) ||
                other.emailuser == emailuser) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.postbyname, postbyname) ||
                other.postbyname == postbyname) &&
            (identical(other.postbyimage, postbyimage) ||
                other.postbyimage == postbyimage) &&
            (identical(other.numpeople, numpeople) ||
                other.numpeople == numpeople) &&
            (identical(other.agerange, agerange) ||
                other.agerange == agerange));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    postid,
    uid,
    name,
    place,
    startdateTime,
    entdateTime,
    createdAt,
    updatedAt,
    image,
    emailuser,
    address,
    description,
    category,
    gender,
    postbyname,
    postbyimage,
    numpeople,
    agerange,
  );

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(this);
  }
}

abstract class _PostModel implements PostModel {
  const factory _PostModel({
    required final String postid,
    required final String uid,
    final String name,
    final String place,
    @TimestampConverter() final Timestamp? startdateTime,
    @TimestampConverter() final Timestamp? entdateTime,
    @TimestampConverter() final Timestamp? createdAt,
    @TimestampConverter() final Timestamp? updatedAt,
    final String image,
    final String emailuser,
    final String address,
    final String description,
    final String category,
    final String gender,
    final String postbyname,
    final String postbyimage,
    @JsonKey(name: 'Numpeople') final String numpeople,
    final String agerange,
  }) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String get postid;
  @override
  String get uid;
  @override
  String get name;
  @override
  String get place;
  @override
  @TimestampConverter()
  Timestamp? get startdateTime;
  @override
  @TimestampConverter()
  Timestamp? get entdateTime;
  @override
  @TimestampConverter()
  Timestamp? get createdAt;
  @override
  @TimestampConverter()
  Timestamp? get updatedAt;
  @override
  String get image;
  @override
  String get emailuser;
  @override
  String get address;
  @override
  String get description;
  @override
  String get category;
  @override
  String get gender;
  @override
  String get postbyname;
  @override
  String get postbyimage;
  @override
  @JsonKey(name: 'Numpeople')
  String get numpeople;
  @override
  String get agerange;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
