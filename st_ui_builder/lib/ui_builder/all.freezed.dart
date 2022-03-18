// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of StUiController;

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ActiveGameDetailsTearOff {
  const _$ActiveGameDetailsTearOff();

  _ActiveGameDetails call(String competitionKey, DateTime scheduledStartDtTm,
      {CompetitionStatus gameStatus = CompetitionStatus.compUninitialized,
      String roundName = '',
      String regionOrConference = '',
      String location = '',
      List<String> participantAssetIds = const [],
      List<String> ownedAssetIds = const [],
      List<String> watchedAssetIds = const []}) {
    return _ActiveGameDetails(
      competitionKey,
      scheduledStartDtTm,
      gameStatus: gameStatus,
      roundName: roundName,
      regionOrConference: regionOrConference,
      location: location,
      participantAssetIds: participantAssetIds,
      ownedAssetIds: ownedAssetIds,
      watchedAssetIds: watchedAssetIds,
    );
  }
}

/// @nodoc
const $ActiveGameDetails = _$ActiveGameDetailsTearOff();

/// @nodoc
mixin _$ActiveGameDetails {
  String get competitionKey => throw _privateConstructorUsedError;
  DateTime get scheduledStartDtTm => throw _privateConstructorUsedError;
  CompetitionStatus get gameStatus => throw _privateConstructorUsedError;
  String get roundName => throw _privateConstructorUsedError;
  String get regionOrConference => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  List<String> get participantAssetIds => throw _privateConstructorUsedError;
  List<String> get ownedAssetIds => throw _privateConstructorUsedError;
  List<String> get watchedAssetIds => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ActiveGameDetailsCopyWith<ActiveGameDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveGameDetailsCopyWith<$Res> {
  factory $ActiveGameDetailsCopyWith(
          ActiveGameDetails value, $Res Function(ActiveGameDetails) then) =
      _$ActiveGameDetailsCopyWithImpl<$Res>;
  $Res call(
      {String competitionKey,
      DateTime scheduledStartDtTm,
      CompetitionStatus gameStatus,
      String roundName,
      String regionOrConference,
      String location,
      List<String> participantAssetIds,
      List<String> ownedAssetIds,
      List<String> watchedAssetIds});
}

/// @nodoc
class _$ActiveGameDetailsCopyWithImpl<$Res>
    implements $ActiveGameDetailsCopyWith<$Res> {
  _$ActiveGameDetailsCopyWithImpl(this._value, this._then);

  final ActiveGameDetails _value;
  // ignore: unused_field
  final $Res Function(ActiveGameDetails) _then;

  @override
  $Res call({
    Object? competitionKey = freezed,
    Object? scheduledStartDtTm = freezed,
    Object? gameStatus = freezed,
    Object? roundName = freezed,
    Object? regionOrConference = freezed,
    Object? location = freezed,
    Object? participantAssetIds = freezed,
    Object? ownedAssetIds = freezed,
    Object? watchedAssetIds = freezed,
  }) {
    return _then(_value.copyWith(
      competitionKey: competitionKey == freezed
          ? _value.competitionKey
          : competitionKey // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledStartDtTm: scheduledStartDtTm == freezed
          ? _value.scheduledStartDtTm
          : scheduledStartDtTm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gameStatus: gameStatus == freezed
          ? _value.gameStatus
          : gameStatus // ignore: cast_nullable_to_non_nullable
              as CompetitionStatus,
      roundName: roundName == freezed
          ? _value.roundName
          : roundName // ignore: cast_nullable_to_non_nullable
              as String,
      regionOrConference: regionOrConference == freezed
          ? _value.regionOrConference
          : regionOrConference // ignore: cast_nullable_to_non_nullable
              as String,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      participantAssetIds: participantAssetIds == freezed
          ? _value.participantAssetIds
          : participantAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ownedAssetIds: ownedAssetIds == freezed
          ? _value.ownedAssetIds
          : ownedAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      watchedAssetIds: watchedAssetIds == freezed
          ? _value.watchedAssetIds
          : watchedAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$ActiveGameDetailsCopyWith<$Res>
    implements $ActiveGameDetailsCopyWith<$Res> {
  factory _$ActiveGameDetailsCopyWith(
          _ActiveGameDetails value, $Res Function(_ActiveGameDetails) then) =
      __$ActiveGameDetailsCopyWithImpl<$Res>;
  @override
  $Res call(
      {String competitionKey,
      DateTime scheduledStartDtTm,
      CompetitionStatus gameStatus,
      String roundName,
      String regionOrConference,
      String location,
      List<String> participantAssetIds,
      List<String> ownedAssetIds,
      List<String> watchedAssetIds});
}

/// @nodoc
class __$ActiveGameDetailsCopyWithImpl<$Res>
    extends _$ActiveGameDetailsCopyWithImpl<$Res>
    implements _$ActiveGameDetailsCopyWith<$Res> {
  __$ActiveGameDetailsCopyWithImpl(
      _ActiveGameDetails _value, $Res Function(_ActiveGameDetails) _then)
      : super(_value, (v) => _then(v as _ActiveGameDetails));

  @override
  _ActiveGameDetails get _value => super._value as _ActiveGameDetails;

  @override
  $Res call({
    Object? competitionKey = freezed,
    Object? scheduledStartDtTm = freezed,
    Object? gameStatus = freezed,
    Object? roundName = freezed,
    Object? regionOrConference = freezed,
    Object? location = freezed,
    Object? participantAssetIds = freezed,
    Object? ownedAssetIds = freezed,
    Object? watchedAssetIds = freezed,
  }) {
    return _then(_ActiveGameDetails(
      competitionKey == freezed
          ? _value.competitionKey
          : competitionKey // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledStartDtTm == freezed
          ? _value.scheduledStartDtTm
          : scheduledStartDtTm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gameStatus: gameStatus == freezed
          ? _value.gameStatus
          : gameStatus // ignore: cast_nullable_to_non_nullable
              as CompetitionStatus,
      roundName: roundName == freezed
          ? _value.roundName
          : roundName // ignore: cast_nullable_to_non_nullable
              as String,
      regionOrConference: regionOrConference == freezed
          ? _value.regionOrConference
          : regionOrConference // ignore: cast_nullable_to_non_nullable
              as String,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      participantAssetIds: participantAssetIds == freezed
          ? _value.participantAssetIds
          : participantAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ownedAssetIds: ownedAssetIds == freezed
          ? _value.ownedAssetIds
          : ownedAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      watchedAssetIds: watchedAssetIds == freezed
          ? _value.watchedAssetIds
          : watchedAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$_ActiveGameDetails extends _ActiveGameDetails
    with DiagnosticableTreeMixin {
  const _$_ActiveGameDetails(this.competitionKey, this.scheduledStartDtTm,
      {this.gameStatus = CompetitionStatus.compUninitialized,
      this.roundName = '',
      this.regionOrConference = '',
      this.location = '',
      this.participantAssetIds = const [],
      this.ownedAssetIds = const [],
      this.watchedAssetIds = const []})
      : super._();

  @override
  final String competitionKey;
  @override
  final DateTime scheduledStartDtTm;
  @JsonKey()
  @override
  final CompetitionStatus gameStatus;
  @JsonKey()
  @override
  final String roundName;
  @JsonKey()
  @override
  final String regionOrConference;
  @JsonKey()
  @override
  final String location;
  @JsonKey()
  @override
  final List<String> participantAssetIds;
  @JsonKey()
  @override
  final List<String> ownedAssetIds;
  @JsonKey()
  @override
  final List<String> watchedAssetIds;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ActiveGameDetails(competitionKey: $competitionKey, scheduledStartDtTm: $scheduledStartDtTm, gameStatus: $gameStatus, roundName: $roundName, regionOrConference: $regionOrConference, location: $location, participantAssetIds: $participantAssetIds, ownedAssetIds: $ownedAssetIds, watchedAssetIds: $watchedAssetIds)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ActiveGameDetails'))
      ..add(DiagnosticsProperty('competitionKey', competitionKey))
      ..add(DiagnosticsProperty('scheduledStartDtTm', scheduledStartDtTm))
      ..add(DiagnosticsProperty('gameStatus', gameStatus))
      ..add(DiagnosticsProperty('roundName', roundName))
      ..add(DiagnosticsProperty('regionOrConference', regionOrConference))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('participantAssetIds', participantAssetIds))
      ..add(DiagnosticsProperty('ownedAssetIds', ownedAssetIds))
      ..add(DiagnosticsProperty('watchedAssetIds', watchedAssetIds));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActiveGameDetails &&
            const DeepCollectionEquality()
                .equals(other.competitionKey, competitionKey) &&
            const DeepCollectionEquality()
                .equals(other.scheduledStartDtTm, scheduledStartDtTm) &&
            const DeepCollectionEquality()
                .equals(other.gameStatus, gameStatus) &&
            const DeepCollectionEquality().equals(other.roundName, roundName) &&
            const DeepCollectionEquality()
                .equals(other.regionOrConference, regionOrConference) &&
            const DeepCollectionEquality().equals(other.location, location) &&
            const DeepCollectionEquality()
                .equals(other.participantAssetIds, participantAssetIds) &&
            const DeepCollectionEquality()
                .equals(other.ownedAssetIds, ownedAssetIds) &&
            const DeepCollectionEquality()
                .equals(other.watchedAssetIds, watchedAssetIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(competitionKey),
      const DeepCollectionEquality().hash(scheduledStartDtTm),
      const DeepCollectionEquality().hash(gameStatus),
      const DeepCollectionEquality().hash(roundName),
      const DeepCollectionEquality().hash(regionOrConference),
      const DeepCollectionEquality().hash(location),
      const DeepCollectionEquality().hash(participantAssetIds),
      const DeepCollectionEquality().hash(ownedAssetIds),
      const DeepCollectionEquality().hash(watchedAssetIds));

  @JsonKey(ignore: true)
  @override
  _$ActiveGameDetailsCopyWith<_ActiveGameDetails> get copyWith =>
      __$ActiveGameDetailsCopyWithImpl<_ActiveGameDetails>(this, _$identity);
}

abstract class _ActiveGameDetails extends ActiveGameDetails {
  const factory _ActiveGameDetails(
      String competitionKey, DateTime scheduledStartDtTm,
      {CompetitionStatus gameStatus,
      String roundName,
      String regionOrConference,
      String location,
      List<String> participantAssetIds,
      List<String> ownedAssetIds,
      List<String> watchedAssetIds}) = _$_ActiveGameDetails;
  const _ActiveGameDetails._() : super._();

  @override
  String get competitionKey;
  @override
  DateTime get scheduledStartDtTm;
  @override
  CompetitionStatus get gameStatus;
  @override
  String get roundName;
  @override
  String get regionOrConference;
  @override
  String get location;
  @override
  List<String> get participantAssetIds;
  @override
  List<String> get ownedAssetIds;
  @override
  List<String> get watchedAssetIds;
  @override
  @JsonKey(ignore: true)
  _$ActiveGameDetailsCopyWith<_ActiveGameDetails> get copyWith =>
      throw _privateConstructorUsedError;
}
