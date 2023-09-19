class MigrateToUuid < ActiveRecord::Migration[7.0]
  TABLES = [:users, :organizations, :branches, :allies]

  TABLES_WITH_FK = {
    users: [:organization_uuid],
    branches: [:organization_uuid],
    allies: [:organization_uuid],
    ally_branches: [:ally_uuid, :branch_uuid],
    user_branches: [:user_uuid, :branch_uuid]
  }

  def up
    # Add UUID columns
    TABLES.each do |table|
      add_column table, :uuid, :uuid, default: "gen_random_uuid()", null: false
    end

    # Add UUID columns for associations
    TABLES_WITH_FK.each do |table, fk_names|
      fk_names.each do |fk_name|
        add_column table, fk_name, :uuid
      end
    end

    # Populate UUID columns for associations
    TABLES_WITH_FK.each do |table, fk_names|
      fk_names.each do |fk_name|
        fk_table_singular = fk_name.to_s.split('_').first.to_sym
        fk_table = fk_table_singular.to_s.pluralize.to_sym
        execute "UPDATE #{table} SET #{fk_name} = #{fk_table}.uuid FROM #{fk_table} WHERE #{table}.#{fk_table_singular}_id = #{fk_table}.id;"
      end
    end

    # Change null
    TABLES_WITH_FK.each do |table, fk_names|
      fk_names.each do |fk_name|
        next if table == :users && fk_name == :organization_uuid
        change_column_null table, fk_name, false
      end
    end

    # Migrate UUID to ID for associations
    TABLES_WITH_FK.each do |table, fk_names|
      fk_names.each do |fk_name|
        fk_old_name = (fk_name.to_s.split('_').first + '_id').to_sym
        remove_column table, fk_old_name
        rename_column table, fk_name, fk_old_name
      end
    end

    # Add indexes for associations
    TABLES_WITH_FK.each do |table, fk_names|
      fk_names.each do |fk_name|
        fk_old_name = (fk_name.to_s.split('_').first + '_id').to_sym
        add_index table, fk_old_name
      end
    end

    # Migrate primary keys from UUIDs to IDs
    TABLES.each do |table|
      remove_column table, :id
      rename_column table, :uuid, :id
      execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
    end

    # Add foreign keys
    TABLES_WITH_FK.each do |table, fk_names|
      fk_names.each do |fk_name|
        fk_table = fk_name.to_s.split('_').first.pluralize.to_sym
        fk_old_name = (fk_name.to_s.split('_').first + '_id').to_sym
        add_foreign_key table, fk_table, column: fk_old_name
      end
    end

    # Add indexes for ordering by date
    TABLES.each do |table|
      add_index table, :created_at
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
