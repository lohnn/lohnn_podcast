// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241111155229_up = [
  InsertTable('UserEpisodeStatus'),
  InsertColumn('episode_id', Column.varchar, onTable: 'UserEpisodeStatus', unique: true),
  InsertColumn('user_id', Column.varchar, onTable: 'UserEpisodeStatus', unique: true),
  InsertColumn('is_played', Column.boolean, onTable: 'UserEpisodeStatus'),
  InsertColumn('current_position', Column.integer, onTable: 'UserEpisodeStatus')
];

const List<MigrationCommand> _migration_20241111155229_down = [
  DropTable('UserEpisodeStatus'),
  DropColumn('episode_id', onTable: 'UserEpisodeStatus'),
  DropColumn('user_id', onTable: 'UserEpisodeStatus'),
  DropColumn('is_played', onTable: 'UserEpisodeStatus'),
  DropColumn('current_position', onTable: 'UserEpisodeStatus')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241111155229',
  up: _migration_20241111155229_up,
  down: _migration_20241111155229_down,
)
class Migration20241111155229 extends Migration {
  const Migration20241111155229()
    : super(
        version: 20241111155229,
        up: _migration_20241111155229_up,
        down: _migration_20241111155229_down,
      );
}
