class Initial < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :sender
      t.string :recipient
      t.string :text
      t.timestamps
    end
  end
end
