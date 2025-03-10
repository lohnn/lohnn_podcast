// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250203154019_up = [
  InsertColumn('local_file_path', Column.varchar, onTable: 'Episode')
];

const List<MigrationCommand> _migration_20250203154019_down = [
  DropColumn('local_file_path', onTable: 'Episode')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250203154019',
  up: _migration_20250203154019_up,
  down: _migration_20250203154019_down,
)
class Migration20250203154019 extends Migration {
  const Migration20250203154019()
    : super(
        version: 20250203154019,
        up: _migration_20250203154019_up,
        down: _migration_20250203154019_down,
      );
}
