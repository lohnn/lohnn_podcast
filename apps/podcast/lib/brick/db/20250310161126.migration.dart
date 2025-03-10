// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250310161126_up = [
  InsertColumn('current_position', Column.integer, onTable: 'EpisodeUserStatus'),
  InsertColumn('image_url', Column.varchar, onTable: 'Podcast'),
  InsertColumn('current_position', Column.integer, onTable: 'UserEpisodeStatus'),
  InsertColumn('url', Column.varchar, onTable: 'Episode'),
  InsertColumn('image_url', Column.varchar, onTable: 'Episode'),
  InsertColumn('duration', Column.integer, onTable: 'Episode')
];

const List<MigrationCommand> _migration_20250310161126_down = [
  DropColumn('current_position', onTable: 'EpisodeUserStatus'),
  DropColumn('image_url', onTable: 'Podcast'),
  DropColumn('current_position', onTable: 'UserEpisodeStatus'),
  DropColumn('url', onTable: 'Episode'),
  DropColumn('image_url', onTable: 'Episode'),
  DropColumn('duration', onTable: 'Episode')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250310161126',
  up: _migration_20250310161126_up,
  down: _migration_20250310161126_down,
)
class Migration20250310161126 extends Migration {
  const Migration20250310161126()
    : super(
        version: 20250310161126,
        up: _migration_20250310161126_up,
        down: _migration_20250310161126_down,
      );
}
