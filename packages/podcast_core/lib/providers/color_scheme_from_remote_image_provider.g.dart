// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_scheme_from_remote_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$colorSchemeFromRemoteImageHash() =>
    r'de359ec8c754f411b7c5ac69c47f182302ecc0a8';

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

/// See also [colorSchemeFromRemoteImage].
@ProviderFor(colorSchemeFromRemoteImage)
const colorSchemeFromRemoteImageProvider = ColorSchemeFromRemoteImageFamily();

/// See also [colorSchemeFromRemoteImage].
class ColorSchemeFromRemoteImageFamily
    extends Family<AsyncValue<ColorScheme?>> {
  /// See also [colorSchemeFromRemoteImage].
  const ColorSchemeFromRemoteImageFamily();

  /// See also [colorSchemeFromRemoteImage].
  ColorSchemeFromRemoteImageProvider call(Uri imageUri, Brightness brightness) {
    return ColorSchemeFromRemoteImageProvider(imageUri, brightness);
  }

  @override
  ColorSchemeFromRemoteImageProvider getProviderOverride(
    covariant ColorSchemeFromRemoteImageProvider provider,
  ) {
    return call(provider.imageUri, provider.brightness);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'colorSchemeFromRemoteImageProvider';
}

/// See also [colorSchemeFromRemoteImage].
class ColorSchemeFromRemoteImageProvider
    extends AutoDisposeFutureProvider<ColorScheme?> {
  /// See also [colorSchemeFromRemoteImage].
  ColorSchemeFromRemoteImageProvider(Uri imageUri, Brightness brightness)
    : this._internal(
        (ref) => colorSchemeFromRemoteImage(
          ref as ColorSchemeFromRemoteImageRef,
          imageUri,
          brightness,
        ),
        from: colorSchemeFromRemoteImageProvider,
        name: r'colorSchemeFromRemoteImageProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$colorSchemeFromRemoteImageHash,
        dependencies: ColorSchemeFromRemoteImageFamily._dependencies,
        allTransitiveDependencies:
            ColorSchemeFromRemoteImageFamily._allTransitiveDependencies,
        imageUri: imageUri,
        brightness: brightness,
      );

  ColorSchemeFromRemoteImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.imageUri,
    required this.brightness,
  }) : super.internal();

  final Uri imageUri;
  final Brightness brightness;

  @override
  Override overrideWith(
    FutureOr<ColorScheme?> Function(ColorSchemeFromRemoteImageRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ColorSchemeFromRemoteImageProvider._internal(
        (ref) => create(ref as ColorSchemeFromRemoteImageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        imageUri: imageUri,
        brightness: brightness,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ColorScheme?> createElement() {
    return _ColorSchemeFromRemoteImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ColorSchemeFromRemoteImageProvider &&
        other.imageUri == imageUri &&
        other.brightness == brightness;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, imageUri.hashCode);
    hash = _SystemHash.combine(hash, brightness.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ColorSchemeFromRemoteImageRef
    on AutoDisposeFutureProviderRef<ColorScheme?> {
  /// The parameter `imageUri` of this provider.
  Uri get imageUri;

  /// The parameter `brightness` of this provider.
  Brightness get brightness;
}

class _ColorSchemeFromRemoteImageProviderElement
    extends AutoDisposeFutureProviderElement<ColorScheme?>
    with ColorSchemeFromRemoteImageRef {
  _ColorSchemeFromRemoteImageProviderElement(super.provider);

  @override
  Uri get imageUri => (origin as ColorSchemeFromRemoteImageProvider).imageUri;
  @override
  Brightness get brightness =>
      (origin as ColorSchemeFromRemoteImageProvider).brightness;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
