// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lifecycle_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AppLifecycleStatePod)
const appLifecycleStatePodProvider = AppLifecycleStatePodProvider._();

final class AppLifecycleStatePodProvider
    extends $NotifierProvider<AppLifecycleStatePod, ui.AppLifecycleState> {
  const AppLifecycleStatePodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLifecycleStatePodProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLifecycleStatePodHash();

  @$internal
  @override
  AppLifecycleStatePod create() => AppLifecycleStatePod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ui.AppLifecycleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ui.AppLifecycleState>(value),
    );
  }
}

String _$appLifecycleStatePodHash() =>
    r'b00d984cf0ad9affb37de99188a47df3228a8ef6';

abstract class _$AppLifecycleStatePod extends $Notifier<ui.AppLifecycleState> {
  ui.AppLifecycleState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ui.AppLifecycleState, ui.AppLifecycleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ui.AppLifecycleState, ui.AppLifecycleState>,
              ui.AppLifecycleState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
