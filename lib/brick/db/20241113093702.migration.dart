// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241113093702_up = [
  InsertTable('PlayQueueItem'),
  InsertTable('Podcast'),
  InsertTable('UserEpisodeStatus'),
  InsertTable('Episode'),
  InsertTable('EpisodeUserStatus'),
  InsertForeignKey('PlayQueueItem', 'Episode', foreignKeyColumn: 'episode_Episode_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('queue_order', Column.integer, onTable: 'PlayQueueItem'),
  InsertColumn('episode_id', Column.varchar, onTable: 'PlayQueueItem', unique: true),
  InsertColumn('id', Column.varchar, onTable: 'Podcast', unique: true),
  InsertColumn('name', Column.varchar, onTable: 'Podcast'),
  InsertColumn('link', Column.varchar, onTable: 'Podcast'),
  InsertColumn('description', Column.varchar, onTable: 'Podcast'),
  InsertColumn('image_url', Column.varchar, onTable: 'Podcast'),
  InsertColumn('language', Column.varchar, onTable: 'Podcast'),
  InsertColumn('last_build_date', Column.varchar, onTable: 'Podcast'),
  InsertColumn('copyright', Column.varchar, onTable: 'Podcast'),
  InsertColumn('generator', Column.varchar, onTable: 'Podcast'),
  InsertColumn('rss_url', Column.varchar, onTable: 'Podcast'),
  InsertColumn('safe_id', Column.varchar, onTable: 'Podcast'),
  InsertColumn('episode_id', Column.varchar, onTable: 'UserEpisodeStatus', unique: true),
  InsertColumn('is_played', Column.boolean, onTable: 'UserEpisodeStatus'),
  InsertColumn('current_position', Column.integer, onTable: 'UserEpisodeStatus'),
  InsertColumn('id', Column.varchar, onTable: 'Episode', unique: true),
  InsertColumn('url', Column.varchar, onTable: 'Episode'),
  InsertColumn('title', Column.varchar, onTable: 'Episode'),
  InsertColumn('pub_date', Column.datetime, onTable: 'Episode'),
  InsertColumn('description', Column.varchar, onTable: 'Episode'),
  InsertColumn('image_url', Column.varchar, onTable: 'Episode'),
  InsertColumn('duration', Column.integer, onTable: 'Episode'),
  InsertColumn('podcast_id', Column.varchar, onTable: 'Episode'),
  InsertColumn('user_id', Column.varchar, onTable: 'EpisodeUserStatus', unique: true),
  InsertColumn('episode_id', Column.varchar, onTable: 'EpisodeUserStatus'),
  InsertColumn('listened', Column.boolean, onTable: 'EpisodeUserStatus'),
  InsertColumn('current_position', Column.integer, onTable: 'EpisodeUserStatus'),
  CreateIndex(columns: ['episode_id'], onTable: 'PlayQueueItem', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Podcast', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Episode', unique: true),
  CreateIndex(columns: ['user_id'], onTable: 'EpisodeUserStatus', unique: true)
];

const List<MigrationCommand> _migration_20241113093702_down = [
  DropTable('PlayQueueItem'),
  DropTable('Podcast'),
  DropTable('UserEpisodeStatus'),
  DropTable('Episode'),
  DropTable('EpisodeUserStatus'),
  DropColumn('episode_Episode_brick_id', onTable: 'PlayQueueItem'),
  DropColumn('queue_order', onTable: 'PlayQueueItem'),
  DropColumn('episode_id', onTable: 'PlayQueueItem'),
  DropColumn('id', onTable: 'Podcast'),
  DropColumn('name', onTable: 'Podcast'),
  DropColumn('link', onTable: 'Podcast'),
  DropColumn('description', onTable: 'Podcast'),
  DropColumn('image_url', onTable: 'Podcast'),
  DropColumn('language', onTable: 'Podcast'),
  DropColumn('last_build_date', onTable: 'Podcast'),
  DropColumn('copyright', onTable: 'Podcast'),
  DropColumn('generator', onTable: 'Podcast'),
  DropColumn('rss_url', onTable: 'Podcast'),
  DropColumn('safe_id', onTable: 'Podcast'),
  DropColumn('episode_id', onTable: 'UserEpisodeStatus'),
  DropColumn('is_played', onTable: 'UserEpisodeStatus'),
  DropColumn('current_position', onTable: 'UserEpisodeStatus'),
  DropColumn('id', onTable: 'Episode'),
  DropColumn('url', onTable: 'Episode'),
  DropColumn('title', onTable: 'Episode'),
  DropColumn('pub_date', onTable: 'Episode'),
  DropColumn('description', onTable: 'Episode'),
  DropColumn('image_url', onTable: 'Episode'),
  DropColumn('duration', onTable: 'Episode'),
  DropColumn('podcast_id', onTable: 'Episode'),
  DropColumn('user_id', onTable: 'EpisodeUserStatus'),
  DropColumn('episode_id', onTable: 'EpisodeUserStatus'),
  DropColumn('listened', onTable: 'EpisodeUserStatus'),
  DropColumn('current_position', onTable: 'EpisodeUserStatus'),
  DropIndex('index_PlayQueueItem_on_episode_id'),
  DropIndex('index_Podcast_on_id'),
  DropIndex('index_Episode_on_id'),
  DropIndex('index_EpisodeUserStatus_on_user_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241113093702',
  up: _migration_20241113093702_up,
  down: _migration_20241113093702_down,
)
class Migration20241113093702 extends Migration {
  const Migration20241113093702()
    : super(
        version: 20241113093702,
        up: _migration_20241113093702_up,
        down: _migration_20241113093702_down,
      );
}
