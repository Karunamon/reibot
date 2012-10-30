class ProfilesInitial < ActiveRecord::Migration
  def up
    execute "CREATE TABLE owners (
     id         SERIAL         PRIMARY KEY NOT NULL,
     name       VARCHAR( 100 ),
     netmasks   VARCHAR( 100 ),
     password   VARCHAR( 100 ),
     privileges VARCHAR( 100 )
);"
    execute "CREATE TABLE profiles (
      id        SERIAL         PRIMARY KEY  NOT NULL,
      title     VARCHAR( 100 ),
      owner     INTEGER,
      timeset   TIMESTAMP,
      whoset    VARCHAR( 255 ),
      FOREIGN KEY (owner) REFERENCES owners(id)
);"
    execute "CREATE TABLE lines (
    id          SERIAL        PRIMARY KEY,
    profile_id  INTEGER,
    data      VARCHAR( 510 ),
    FOREIGN KEY (profile_id) REFERENCES profiles(id)
);"
  end

  def down
    drop_table :profile_data
    drop_table :profile_meta
    drop_table :profile_owners
  end
end
