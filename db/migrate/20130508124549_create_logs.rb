class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :name
      t.string :provider
      t.string :file
      t.integer :parsed_lines, default: 0
      t.datetime :parsed_at

      t.timestamps
    end

    add_index :logs, [:name, :provider], unique: true
  end
end
