class ProfilesInitial < ActiveRecord::Migration
  def up
    execute "CREATE TABLE profile_owners (
     id         INTEGER         PRIMARY KEY AUTOINCREMENT NOT NULL,
     name       VARCHAR( 100 )  COLLATE 'NOCASE',
     netmasks   VARCHAR( 100 )  COLLATE 'NOCASE',
     password   VARCHAR( 100 ),
     privileges VARCHAR( 100 )
);"
    execute "CREATE TABLE profile_meta (
      id        INTEGER         PRIMARY KEY AUTOINCREMENT NOT NULL,
      title     VARCHAR( 100 )  COLLATE 'NOCASE',
      owner     INTEGER,
      timeset   DATETIME,
      whoset    VARCHAR( 255 )  COLLATE 'NOCASE',
      FOREIGN KEY (owner) REFERENCES profile_owners(id)
);"
    execute "CREATE TABLE profile_data (
    id          INTEGER        PRIMARY KEY AUTOINCREMENT,
    profile_id  INTEGER,
    data      VARCHAR( 510 ),
    FOREIGN KEY (profile_id) REFERENCES profile_meta(id)
);"
  end

  def down
    drop_table :profile_data
    drop_table :profile_meta
    drop_table :profile_owners
  end
end
