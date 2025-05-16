// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_scheme_from_remote_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(colorSchemeFromRemoteImage)
const colorSchemeFromRemoteImageProvider = ColorSchemeFromRemoteImageFamily._();

final class ColorSchemeFromRemoteImageProvider
    extends
        $FunctionalProvider<AsyncValue<ColorScheme?>, FutureOr<ColorScheme?>>
    with $FutureModifier<ColorScheme?>, $FutureProvider<ColorScheme?> {
  const ColorSchemeFromRemoteImageProvider._({
    required ColorSchemeFromRemoteImageFamily super.from,
    required (Uri, Brightness) super.argument,
  }) : super(
         retry: null,
         name: r'colorSchemeFromRemoteImageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$colorSchemeFromRemoteImageHash();

  @override
  String toString() {
    return r'colorSchemeFromRemoteImageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ColorScheme?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ColorScheme?> create(Ref ref) {
    final argument = this.argument as (Uri, Brightness);
    return colorSchemeFromRemoteImage(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ColorSchemeFromRemoteImageProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$colorSchemeFromRemoteImageHash() =>
    r'de359ec8c754f411b7c5ac69c47f182302ecc0a8';

final class ColorSchemeFromRemoteImageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ColorScheme?>, (Uri, Brightness)> {
  const ColorSchemeFromRemoteImageFamily._()
    : super(
        retry: null,
        name: r'colorSchemeFromRemoteImageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ColorSchemeFromRemoteImageProvider call(
    Uri imageUri,
    Brightness brightness,
  ) => ColorSchemeFromRemoteImageProvider._(
    argument: (imageUri, brightness),
    from: this,
  );

  @override
  String toString() => r'colorSchemeFromRemoteImageProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
