class CreateOrgUnits < ActiveRecord::Migration[5.1]
  def up
    create_table :org_units do |t|
      t.string :code
      t.string :name
      t.integer :level
      t.string :level_2
      t.string :level_3
      t.string :level_4
      t.string :level_5
      t.string :level_6

      t.timestamps
    end

    add_index :org_units, :code, unique: true

  end

  def down
    drop_table :org_units
  end
end
