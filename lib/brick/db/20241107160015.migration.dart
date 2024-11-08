// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241107160015_up = [
  InsertTable('PodcastSupabase'),
  InsertTable('EpisodeUserStatusSupabase'),
  InsertTable('EpisodeSupabase'),
  InsertColumn('id', Column.varchar, onTable: 'PodcastSupabase', unique: true),
  InsertColumn('name', Column.varchar, onTable: 'PodcastSupabase'),
  InsertColumn('link', Column.varchar, onTable: 'PodcastSupabase'),
  InsertColumn('description', Column.varchar, onTable: 'PodcastSupabase'),
  InsertColumn('image_url', Column.varchar, onTable: 'PodcastSupabase'),
  InsertColumn('language', Column.varchar, onTable: 'PodcastSupabase'),
  InsertColumn('last_build_date', Column.varchar, onTable: 'PodcastSupabase'),
  InsertColumn('copyright', Column.varchar, onTable: 'PodcastSupabase'),
  InsertColumn('generator', Column.varchar, onTable: 'PodcastSupabase'),
  InsertColumn('rss_url', Column.varchar, onTable: 'PodcastSupabase'),
  InsertColumn('safe_id', Column.varchar, onTable: 'PodcastSupabase'),
  InsertColumn('user_id', Column.varchar, onTable: 'EpisodeUserStatusSupabase', unique: true),
  InsertColumn('episode_id', Column.varchar, onTable: 'EpisodeUserStatusSupabase'),
  InsertColumn('listened', Column.boolean, onTable: 'EpisodeUserStatusSupabase'),
  InsertColumn('current_position', Column.integer, onTable: 'EpisodeUserStatusSupabase'),
  InsertColumn('id', Column.varchar, onTable: 'EpisodeSupabase', unique: true),
  InsertColumn('url', Column.varchar, onTable: 'EpisodeSupabase'),
  InsertColumn('title', Column.varchar, onTable: 'EpisodeSupabase'),
  InsertColumn('pub_date', Column.datetime, onTable: 'EpisodeSupabase'),
  InsertColumn('description', Column.varchar, onTable: 'EpisodeSupabase'),
  InsertColumn('image_url', Column.varchar, onTable: 'EpisodeSupabase'),
  InsertColumn('duration', Column.integer, onTable: 'EpisodeSupabase'),
  InsertColumn('podcast_id', Column.varchar, onTable: 'EpisodeSupabase'),
  CreateIndex(columns: ['id'], onTable: 'PodcastSupabase', unique: true),
  CreateIndex(columns: ['user_id'], onTable: 'EpisodeUserStatusSupabase', unique: true),
  CreateIndex(columns: ['id'], onTable: 'EpisodeSupabase', unique: true)
];

const List<MigrationCommand> _migration_20241107160015_down = [
  DropTable('PodcastSupabase'),
  DropTable('EpisodeUserStatusSupabase'),
  DropTable('EpisodeSupabase'),
  DropColumn('id', onTable: 'PodcastSupabase'),
  DropColumn('name', onTable: 'PodcastSupabase'),
  DropColumn('link', onTable: 'PodcastSupabase'),
  DropColumn('description', onTable: 'PodcastSupabase'),
  DropColumn('image_url', onTable: 'PodcastSupabase'),
  DropColumn('language', onTable: 'PodcastSupabase'),
  DropColumn('last_build_date', onTable: 'PodcastSupabase'),
  DropColumn('copyright', onTable: 'PodcastSupabase'),
  DropColumn('generator', onTable: 'PodcastSupabase'),
  DropColumn('rss_url', onTable: 'PodcastSupabase'),
  DropColumn('safe_id', onTable: 'PodcastSupabase'),
  DropColumn('user_id', onTable: 'EpisodeUserStatusSupabase'),
  DropColumn('episode_id', onTable: 'EpisodeUserStatusSupabase'),
  DropColumn('listened', onTable: 'EpisodeUserStatusSupabase'),
  DropColumn('current_position', onTable: 'EpisodeUserStatusSupabase'),
  DropColumn('id', onTable: 'EpisodeSupabase'),
  DropColumn('url', onTable: 'EpisodeSupabase'),
  DropColumn('title', onTable: 'EpisodeSupabase'),
  DropColumn('pub_date', onTable: 'EpisodeSupabase'),
  DropColumn('description', onTable: 'EpisodeSupabase'),
  DropColumn('image_url', onTable: 'EpisodeSupabase'),
  DropColumn('duration', onTable: 'EpisodeSupabase'),
  DropColumn('podcast_id', onTable: 'EpisodeSupabase'),
  DropIndex('index_PodcastSupabase_on_id'),
  DropIndex('index_EpisodeUserStatusSupabase_on_user_id'),
  DropIndex('index_EpisodeSupabase_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241107160015',
  up: _migration_20241107160015_up,
  down: _migration_20241107160015_down,
)
class Migration20241107160015 extends Migration {
  const Migration20241107160015()
    : super(
        version: 20241107160015,
        up: _migration_20241107160015_up,
        down: _migration_20241107160015_down,
      );
}
