///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	String get ok => 'Ok';
	late final TranslationsAddPodcastDialogEn addPodcastDialog = TranslationsAddPodcastDialogEn._(_root);
	late final TranslationsImportListenedEpisodesDialogEn importListenedEpisodesDialog = TranslationsImportListenedEpisodesDialogEn._(_root);
	late final TranslationsErrorScreenEn errorScreen = TranslationsErrorScreenEn._(_root);
	late final TranslationsLogOutDialogEn logOutDialog = TranslationsLogOutDialogEn._(_root);
	late final TranslationsEpisodeDetailsScreenEn episodeDetailsScreen = TranslationsEpisodeDetailsScreenEn._(_root);
	late final TranslationsPodcastDetailsScreenEn podcastDetailsScreen = TranslationsPodcastDetailsScreenEn._(_root);
	late final TranslationsPodcastSearchScreenEn podcastSearchScreen = TranslationsPodcastSearchScreenEn._(_root);
	late final TranslationsEpisodePlayerModalEn episodePlayerModal = TranslationsEpisodePlayerModalEn._(_root);
	late final TranslationsCurrentlyPlayingInformationEn currentlyPlayingInformation = TranslationsCurrentlyPlayingInformationEn._(_root);
	late final TranslationsFilterEpisodesPopupEn filterEpisodesPopup = TranslationsFilterEpisodesPopupEn._(_root);
	late final TranslationsPodcastDetailsEn podcastDetails = TranslationsPodcastDetailsEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
	late final TranslationsExitDialogEn exitDialog = TranslationsExitDialogEn._(_root);
}

// Path: addPodcastDialog
class TranslationsAddPodcastDialogEn {
	TranslationsAddPodcastDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Add podcast by RSS';
	String get textFieldHint => 'Rss url';
}

// Path: importListenedEpisodesDialog
class TranslationsImportListenedEpisodesDialogEn {
	TranslationsImportListenedEpisodesDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Import listened episodes';
	String get textFieldHint => 'Listened episodes JSON url';
}

// Path: errorScreen
class TranslationsErrorScreenEn {
	TranslationsErrorScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get somethingWentWrong => 'Something went wrong.';
	String get tryReloading => 'Try reloading the page';
}

// Path: logOutDialog
class TranslationsLogOutDialogEn {
	TranslationsLogOutDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Log out?';
	String get content => 'If you log out, you\'ll need to log in again.';
	String get stayLoggedIn => 'Stay logged in';
	String get logOut => 'Log out';
}

// Path: episodeDetailsScreen
class TranslationsEpisodeDetailsScreenEn {
	TranslationsEpisodeDetailsScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get podcastTitle => 'Podcast Title';
	String get episodeTitle => 'Episode Title';
}

// Path: podcastDetailsScreen
class TranslationsPodcastDetailsScreenEn {
	TranslationsPodcastDetailsScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get episodes => 'Episodes';
	String get markUnlistened => 'Mark unlistened';
	String get markListened => 'Mark listened';
}

// Path: podcastSearchScreen
class TranslationsPodcastSearchScreenEn {
	TranslationsPodcastSearchScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get searchForPodcasts => 'Search for podcasts';
	String get somethingWentWrong => 'Something went wrong.\nPlease send an error report to podcast@lohnn.se with your search term.';
	String get podcastArtwork => 'Podcast artwork';
}

// Path: episodePlayerModal
class TranslationsEpisodePlayerModalEn {
	TranslationsEpisodePlayerModalEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get episodeImage => 'Episode image';
}

// Path: currentlyPlayingInformation
class TranslationsCurrentlyPlayingInformationEn {
	TranslationsCurrentlyPlayingInformationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get showPlaylist => 'Show playlist';
	String get inYourQueue => 'In your queue:';
}

// Path: filterEpisodesPopup
class TranslationsFilterEpisodesPopupEn {
	TranslationsFilterEpisodesPopupEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get filterEpisodes => 'Filter episodes';
	String get clearAllFilters => 'Clear all filters';
	String get hidePlayedEpisodes => 'Hide played episodes';
	String get sortBy => 'Sort by';
	String get changeSortOrder => 'Change sort order';
	String get sortAscending => 'Sort ascending';
	String get sortDescending => 'Sort descending';
}

// Path: podcastDetails
class TranslationsPodcastDetailsEn {
	TranslationsPodcastDetailsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get podcastImage => 'Podcast image';
	String get rssFeed => 'Rss feed';
	String get expandDescription => 'Expand description';
	String get showLess => 'Show less';
	String get showMore => 'Show more';
	String get loading => 'Loading...';
	String get areYouSureToUnsubscribe => 'Are you sure you want to unsubscribe?';
	String get yes => 'Yes';
	String get no => 'No';
	String get unsubscribe => 'Unsubscribe';
	String get addPodcast => 'Add podcast';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
}

// Path: exitDialog
class TranslationsExitDialogEn {
	TranslationsExitDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Are you sure you want to exit?';
	String get yes => 'Yes';
	String get no => 'No';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'ok': return 'Ok';
			case 'addPodcastDialog.title': return 'Add podcast by RSS';
			case 'addPodcastDialog.textFieldHint': return 'Rss url';
			case 'importListenedEpisodesDialog.title': return 'Import listened episodes';
			case 'importListenedEpisodesDialog.textFieldHint': return 'Listened episodes JSON url';
			case 'errorScreen.somethingWentWrong': return 'Something went wrong.';
			case 'errorScreen.tryReloading': return 'Try reloading the page';
			case 'logOutDialog.title': return 'Log out?';
			case 'logOutDialog.content': return 'If you log out, you\'ll need to log in again.';
			case 'logOutDialog.stayLoggedIn': return 'Stay logged in';
			case 'logOutDialog.logOut': return 'Log out';
			case 'episodeDetailsScreen.podcastTitle': return 'Podcast Title';
			case 'episodeDetailsScreen.episodeTitle': return 'Episode Title';
			case 'podcastDetailsScreen.episodes': return 'Episodes';
			case 'podcastDetailsScreen.markUnlistened': return 'Mark unlistened';
			case 'podcastDetailsScreen.markListened': return 'Mark listened';
			case 'podcastSearchScreen.searchForPodcasts': return 'Search for podcasts';
			case 'podcastSearchScreen.somethingWentWrong': return 'Something went wrong.\nPlease send an error report to podcast@lohnn.se with your search term.';
			case 'podcastSearchScreen.podcastArtwork': return 'Podcast artwork';
			case 'episodePlayerModal.episodeImage': return 'Episode image';
			case 'currentlyPlayingInformation.showPlaylist': return 'Show playlist';
			case 'currentlyPlayingInformation.inYourQueue': return 'In your queue:';
			case 'filterEpisodesPopup.filterEpisodes': return 'Filter episodes';
			case 'filterEpisodesPopup.clearAllFilters': return 'Clear all filters';
			case 'filterEpisodesPopup.hidePlayedEpisodes': return 'Hide played episodes';
			case 'filterEpisodesPopup.sortBy': return 'Sort by';
			case 'filterEpisodesPopup.changeSortOrder': return 'Change sort order';
			case 'filterEpisodesPopup.sortAscending': return 'Sort ascending';
			case 'filterEpisodesPopup.sortDescending': return 'Sort descending';
			case 'podcastDetails.podcastImage': return 'Podcast image';
			case 'podcastDetails.rssFeed': return 'Rss feed';
			case 'podcastDetails.expandDescription': return 'Expand description';
			case 'podcastDetails.showLess': return 'Show less';
			case 'podcastDetails.showMore': return 'Show more';
			case 'podcastDetails.loading': return 'Loading...';
			case 'podcastDetails.areYouSureToUnsubscribe': return 'Are you sure you want to unsubscribe?';
			case 'podcastDetails.yes': return 'Yes';
			case 'podcastDetails.no': return 'No';
			case 'podcastDetails.unsubscribe': return 'Unsubscribe';
			case 'podcastDetails.addPodcast': return 'Add podcast';
			case 'settings.title': return 'Settings';
			case 'exitDialog.title': return 'Are you sure you want to exit?';
			case 'exitDialog.yes': return 'Yes';
			case 'exitDialog.no': return 'No';
			default: return null;
		}
	}
}

