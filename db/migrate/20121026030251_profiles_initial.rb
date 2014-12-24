class ProfilesInitial < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :name
      t.string :netmasks
      t.string :password
      t.string :privileges
      t.timestamps
    end

    create_table :profiles do |t|
      t.integer :owner_id
      t.string :title
      t.string :whoset
      t.timestamps
    end

    create_table :lines do |t|
      t.integer :profile_id
      t.string :data
    end
  end
end