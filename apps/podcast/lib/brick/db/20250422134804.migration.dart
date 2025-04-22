// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250422134804_up = [
  InsertTable('EpisodeImpl'),
  InsertTable('UserEpisodeStatusImpl'),
  InsertTable('EpisodeUserStatus'),
  InsertTable('PlayQueueItem'),
  InsertTable('Podcast'),
  InsertColumn('id', Column.varchar, onTable: 'EpisodeImpl', unique: true),
  InsertColumn('backing_url', Column.varchar, onTable: 'EpisodeImpl'),
  InsertColumn('title', Column.varchar, onTable: 'EpisodeImpl'),
  InsertColumn('pub_date', Column.datetime, onTable: 'EpisodeImpl'),
  InsertColumn('description', Column.varchar, onTable: 'EpisodeImpl'),
  InsertColumn('backing_image_url', Column.varchar, onTable: 'EpisodeImpl'),
  InsertColumn('backing_duration', Column.integer, onTable: 'EpisodeImpl'),
  InsertColumn('podcast_id', Column.varchar, onTable: 'EpisodeImpl'),
  InsertColumn('safe_id', Column.varchar, onTable: 'EpisodeImpl'),
  InsertColumn('safe_podcast_id', Column.varchar, onTable: 'EpisodeImpl'),
  InsertColumn('local_file_path', Column.varchar, onTable: 'EpisodeImpl'),
  InsertColumn('episode_id', Column.varchar, onTable: 'UserEpisodeStatusImpl', unique: true),
  InsertColumn('is_played', Column.boolean, onTable: 'UserEpisodeStatusImpl'),
  InsertColumn('backing_current_position', Column.integer, onTable: 'UserEpisodeStatusImpl'),
  InsertColumn('user_id', Column.varchar, onTable: 'EpisodeUserStatus', unique: true),
  InsertColumn('episode_id', Column.varchar, onTable: 'EpisodeUserStatus'),
  InsertColumn('listened', Column.boolean, onTable: 'EpisodeUserStatus'),
  InsertColumn('backing_current_position', Column.integer, onTable: 'EpisodeUserStatus'),
  InsertForeignKey('PlayQueueItem', 'EpisodeImpl', foreignKeyColumn: 'episode_EpisodeImpl_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('queue_order', Column.integer, onTable: 'PlayQueueItem'),
  InsertColumn('episode_id', Column.varchar, onTable: 'PlayQueueItem', unique: true),
  InsertColumn('id', Column.varchar, onTable: 'Podcast', unique: true),
  InsertColumn('name', Column.varchar, onTable: 'Podcast'),
  InsertColumn('link', Column.varchar, onTable: 'Podcast'),
  InsertColumn('description', Column.varchar, onTable: 'Podcast'),
  InsertColumn('backing_image_url', Column.varchar, onTable: 'Podcast'),
  InsertColumn('language', Column.varchar, onTable: 'Podcast'),
  InsertColumn('last_build_date', Column.varchar, onTable: 'Podcast'),
  InsertColumn('copyright', Column.varchar, onTable: 'Podcast'),
  InsertColumn('generator', Column.varchar, onTable: 'Podcast'),
  InsertColumn('rss_url', Column.varchar, onTable: 'Podcast'),
  InsertColumn('safe_id', Column.varchar, onTable: 'Podcast'),
  CreateIndex(columns: ['id'], onTable: 'EpisodeImpl', unique: true),
  CreateIndex(columns: ['user_id'], onTable: 'EpisodeUserStatus', unique: true),
  CreateIndex(columns: ['episode_id'], onTable: 'PlayQueueItem', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Podcast', unique: true)
];

const List<MigrationCommand> _migration_20250422134804_down = [
  DropTable('EpisodeImpl'),
  DropTable('UserEpisodeStatusImpl'),
  DropTable('EpisodeUserStatus'),
  DropTable('PlayQueueItem'),
  DropTable('Podcast'),
  DropColumn('id', onTable: 'EpisodeImpl'),
  DropColumn('backing_url', onTable: 'EpisodeImpl'),
  DropColumn('title', onTable: 'EpisodeImpl'),
  DropColumn('pub_date', onTable: 'EpisodeImpl'),
  DropColumn('description', onTable: 'EpisodeImpl'),
  DropColumn('backing_image_url', onTable: 'EpisodeImpl'),
  DropColumn('backing_duration', onTable: 'EpisodeImpl'),
  DropColumn('podcast_id', onTable: 'EpisodeImpl'),
  DropColumn('safe_id', onTable: 'EpisodeImpl'),
  DropColumn('safe_podcast_id', onTable: 'EpisodeImpl'),
  DropColumn('local_file_path', onTable: 'EpisodeImpl'),
  DropColumn('episode_id', onTable: 'UserEpisodeStatusImpl'),
  DropColumn('is_played', onTable: 'UserEpisodeStatusImpl'),
  DropColumn('backing_current_position', onTable: 'UserEpisodeStatusImpl'),
  DropColumn('user_id', onTable: 'EpisodeUserStatus'),
  DropColumn('episode_id', onTable: 'EpisodeUserStatus'),
  DropColumn('listened', onTable: 'EpisodeUserStatus'),
  DropColumn('backing_current_position', onTable: 'EpisodeUserStatus'),
  DropColumn('episode_EpisodeImpl_brick_id', onTable: 'PlayQueueItem'),
  DropColumn('queue_order', onTable: 'PlayQueueItem'),
  DropColumn('episode_id', onTable: 'PlayQueueItem'),
  DropColumn('id', onTable: 'Podcast'),
  DropColumn('name', onTable: 'Podcast'),
  DropColumn('link', onTable: 'Podcast'),
  DropColumn('description', onTable: 'Podcast'),
  DropColumn('backing_image_url', onTable: 'Podcast'),
  DropColumn('language', onTable: 'Podcast'),
  DropColumn('last_build_date', onTable: 'Podcast'),
  DropColumn('copyright', onTable: 'Podcast'),
  DropColumn('generator', onTable: 'Podcast'),
  DropColumn('rss_url', onTable: 'Podcast'),
  DropColumn('safe_id', onTable: 'Podcast'),
  DropIndex('index_EpisodeImpl_on_id'),
  DropIndex('index_EpisodeUserStatus_on_user_id'),
  DropIndex('index_PlayQueueItem_on_episode_id'),
  DropIndex('index_Podcast_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250422134804',
  up: _migration_20250422134804_up,
  down: _migration_20250422134804_down,
)
class Migration20250422134804 extends Migration {
  const Migration20250422134804()
    : super(
        version: 20250422134804,
        up: _migration_20250422134804_up,
        down: _migration_20250422134804_down,
      );
}
