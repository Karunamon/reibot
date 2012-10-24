class Initial < ActiveRecord::Migration
  def up
    create_table :notes do |table|
      table.column :id, :integer
      table.column :timeset, :DateTime
      table.column :sender, :string
      table.column :recipient, :string
      table.column :text, :string
    end
  end

  def down
    drop_table :notes
  end
end
