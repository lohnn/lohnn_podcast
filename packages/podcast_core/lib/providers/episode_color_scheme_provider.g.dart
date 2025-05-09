// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_color_scheme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentPlayingEpisodeColorSchemeHash() =>
    r'6f6fa6ec031859294a953c6467a577132058435c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [currentPlayingEpisodeColorScheme].
@ProviderFor(currentPlayingEpisodeColorScheme)
const currentPlayingEpisodeColorSchemeProvider =
    CurrentPlayingEpisodeColorSchemeFamily();

/// See also [currentPlayingEpisodeColorScheme].
class CurrentPlayingEpisodeColorSchemeFamily
    extends Family<AsyncValue<ColorScheme?>> {
  /// See also [currentPlayingEpisodeColorScheme].
  const CurrentPlayingEpisodeColorSchemeFamily();

  /// See also [currentPlayingEpisodeColorScheme].
  CurrentPlayingEpisodeColorSchemeProvider call(Brightness brightness) {
    return CurrentPlayingEpisodeColorSchemeProvider(brightness);
  }

  @override
  CurrentPlayingEpisodeColorSchemeProvider getProviderOverride(
    covariant CurrentPlayingEpisodeColorSchemeProvider provider,
  ) {
    return call(provider.brightness);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'currentPlayingEpisodeColorSchemeProvider';
}

/// See also [currentPlayingEpisodeColorScheme].
class CurrentPlayingEpisodeColorSchemeProvider
    extends AutoDisposeFutureProvider<ColorScheme?> {
  /// See also [currentPlayingEpisodeColorScheme].
  CurrentPlayingEpisodeColorSchemeProvider(Brightness brightness)
    : this._internal(
        (ref) => currentPlayingEpisodeColorScheme(
          ref as CurrentPlayingEpisodeColorSchemeRef,
          brightness,
        ),
        from: currentPlayingEpisodeColorSchemeProvider,
        name: r'currentPlayingEpisodeColorSchemeProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$currentPlayingEpisodeColorSchemeHash,
        dependencies: CurrentPlayingEpisodeColorSchemeFamily._dependencies,
        allTransitiveDependencies:
            CurrentPlayingEpisodeColorSchemeFamily._allTransitiveDependencies,
        brightness: brightness,
      );

  CurrentPlayingEpisodeColorSchemeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.brightness,
  }) : super.internal();

  final Brightness brightness;

  @override
  Override overrideWith(
    FutureOr<ColorScheme?> Function(
      CurrentPlayingEpisodeColorSchemeRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentPlayingEpisodeColorSchemeProvider._internal(
        (ref) => create(ref as CurrentPlayingEpisodeColorSchemeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        brightness: brightness,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ColorScheme?> createElement() {
    return _CurrentPlayingEpisodeColorSchemeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentPlayingEpisodeColorSchemeProvider &&
        other.brightness == brightness;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, brightness.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentPlayingEpisodeColorSchemeRef
    on AutoDisposeFutureProviderRef<ColorScheme?> {
  /// The parameter `brightness` of this provider.
  Brightness get brightness;
}

class _CurrentPlayingEpisodeColorSchemeProviderElement
    extends AutoDisposeFutureProviderElement<ColorScheme?>
    with CurrentPlayingEpisodeColorSchemeRef {
  _CurrentPlayingEpisodeColorSchemeProviderElement(super.provider);

  @override
  Brightness get brightness =>
      (origin as CurrentPlayingEpisodeColorSchemeProvider).brightness;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
