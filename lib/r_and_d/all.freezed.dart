// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of RandDee;

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$QIntentCfgTearOff {
  const _$QIntentCfgTearOff();

  _QIntentCfg call(QIntentWrapper intentWrapper, QTargetLevel tLevel) {
    return _QIntentCfg(
      intentWrapper,
      tLevel,
    );
  }
}

/// @nodoc
const $QIntentCfg = _$QIntentCfgTearOff();

/// @nodoc
mixin _$QIntentCfg {
  QIntentWrapper get intentWrapper => throw _privateConstructorUsedError;
  QTargetLevel get tLevel => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QIntentCfgCopyWith<QIntentCfg> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QIntentCfgCopyWith<$Res> {
  factory $QIntentCfgCopyWith(
          QIntentCfg value, $Res Function(QIntentCfg) then) =
      _$QIntentCfgCopyWithImpl<$Res>;
  $Res call({QIntentWrapper intentWrapper, QTargetLevel tLevel});
}

/// @nodoc
class _$QIntentCfgCopyWithImpl<$Res> implements $QIntentCfgCopyWith<$Res> {
  _$QIntentCfgCopyWithImpl(this._value, this._then);

  final QIntentCfg _value;
  // ignore: unused_field
  final $Res Function(QIntentCfg) _then;

  @override
  $Res call({
    Object? intentWrapper = freezed,
    Object? tLevel = freezed,
  }) {
    return _then(_value.copyWith(
      intentWrapper: intentWrapper == freezed
          ? _value.intentWrapper
          : intentWrapper // ignore: cast_nullable_to_non_nullable
              as QIntentWrapper,
      tLevel: tLevel == freezed
          ? _value.tLevel
          : tLevel // ignore: cast_nullable_to_non_nullable
              as QTargetLevel,
    ));
  }
}

/// @nodoc
abstract class _$QIntentCfgCopyWith<$Res> implements $QIntentCfgCopyWith<$Res> {
  factory _$QIntentCfgCopyWith(
          _QIntentCfg value, $Res Function(_QIntentCfg) then) =
      __$QIntentCfgCopyWithImpl<$Res>;
  @override
  $Res call({QIntentWrapper intentWrapper, QTargetLevel tLevel});
}

/// @nodoc
class __$QIntentCfgCopyWithImpl<$Res> extends _$QIntentCfgCopyWithImpl<$Res>
    implements _$QIntentCfgCopyWith<$Res> {
  __$QIntentCfgCopyWithImpl(
      _QIntentCfg _value, $Res Function(_QIntentCfg) _then)
      : super(_value, (v) => _then(v as _QIntentCfg));

  @override
  _QIntentCfg get _value => super._value as _QIntentCfg;

  @override
  $Res call({
    Object? intentWrapper = freezed,
    Object? tLevel = freezed,
  }) {
    return _then(_QIntentCfg(
      intentWrapper == freezed
          ? _value.intentWrapper
          : intentWrapper // ignore: cast_nullable_to_non_nullable
              as QIntentWrapper,
      tLevel == freezed
          ? _value.tLevel
          : tLevel // ignore: cast_nullable_to_non_nullable
              as QTargetLevel,
    ));
  }
}

/// @nodoc

class _$_QIntentCfg extends _QIntentCfg {
  _$_QIntentCfg(this.intentWrapper, this.tLevel) : super._();

  @override
  final QIntentWrapper intentWrapper;
  @override
  final QTargetLevel tLevel;

  @override
  String toString() {
    return 'QIntentCfg(intentWrapper: $intentWrapper, tLevel: $tLevel)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QIntentCfg &&
            const DeepCollectionEquality()
                .equals(other.intentWrapper, intentWrapper) &&
            const DeepCollectionEquality().equals(other.tLevel, tLevel));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(intentWrapper),
      const DeepCollectionEquality().hash(tLevel));

  @JsonKey(ignore: true)
  @override
  _$QIntentCfgCopyWith<_QIntentCfg> get copyWith =>
      __$QIntentCfgCopyWithImpl<_QIntentCfg>(this, _$identity);
}

abstract class _QIntentCfg extends QIntentCfg {
  factory _QIntentCfg(QIntentWrapper intentWrapper, QTargetLevel tLevel) =
      _$_QIntentCfg;
  _QIntentCfg._() : super._();

  @override
  QIntentWrapper get intentWrapper;
  @override
  QTargetLevel get tLevel;
  @override
  @JsonKey(ignore: true)
  _$QIntentCfgCopyWith<_QIntentCfg> get copyWith =>
      throw _privateConstructorUsedError;
}
