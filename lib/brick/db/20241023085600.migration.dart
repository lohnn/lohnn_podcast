// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241023085600_up = [
  InsertTable('EpisodeSupabase'),
  InsertColumn('id', Column.varchar, onTable: 'EpisodeSupabase', unique: true),
  InsertColumn('url', Column.varchar, onTable: 'EpisodeSupabase'),
  InsertColumn('title', Column.varchar, onTable: 'EpisodeSupabase'),
  InsertColumn('pub_date', Column.datetime, onTable: 'EpisodeSupabase'),
  InsertColumn('description', Column.varchar, onTable: 'EpisodeSupabase'),
  InsertColumn('image_url', Column.varchar, onTable: 'EpisodeSupabase'),
  InsertColumn('duration', Column.integer, onTable: 'EpisodeSupabase'),
  CreateIndex(columns: ['id'], onTable: 'EpisodeSupabase', unique: true)
];

const List<MigrationCommand> _migration_20241023085600_down = [
  DropTable('EpisodeSupabase'),
  DropColumn('id', onTable: 'EpisodeSupabase'),
  DropColumn('url', onTable: 'EpisodeSupabase'),
  DropColumn('title', onTable: 'EpisodeSupabase'),
  DropColumn('pub_date', onTable: 'EpisodeSupabase'),
  DropColumn('description', onTable: 'EpisodeSupabase'),
  DropColumn('image_url', onTable: 'EpisodeSupabase'),
  DropColumn('duration', onTable: 'EpisodeSupabase'),
  DropIndex('index_EpisodeSupabase_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241023085600',
  up: _migration_20241023085600_up,
  down: _migration_20241023085600_down,
)
class Migration20241023085600 extends Migration {
  const Migration20241023085600()
    : super(
        version: 20241023085600,
        up: _migration_20241023085600_up,
        down: _migration_20241023085600_down,
      );
}
