class ProfilesInitial < ActiveRecord::Migration
  def up
    create_table :profile_owners do |t|
      execute "CREATE TABLE profile_owners (
     id         INTEGER         PRIMARY KEY AUTOINCREMENT NOT NULL,
     name       VARCHAR( 100 )  COLLATE 'NOCASE',
     netmasks   VARCHAR( 100 )  COLLATE 'NOCASE',
     password   VARCHAR( 100 )
     privileges VARCHAR( 100 )
);"
    end
    create_table :profile_meta do |t|
      execute "CREATE TABLE profile_meta (
      id        INTEGER         PRIMARY KEY AUTOINCREMENT NOT NULL,
      title     VARCHAR( 100 )  COLLATE 'NOCASE',
      owner     INTEGER,
      FOREIGN KEY (owner) REFERENCES profile_owners(id),
      timeset   DATETIME,
      whoset    VARCHAR( 255 )  COLLATE 'NOCASE'
);"
    end
    create_table :profile_data do |t|
      execute "CREATE TABLE profile_data (
    id          INTEGER        PRIMARY KEY AUTOINCREMENT,
    profile_id  INTEGER,
    FOREIGN KEY (profile_id) REFERENCES profile_meta(id),
    data      VARCHAR( 510 )
);"
    end

  end

  def down
    drop_table :profile_data
    drop_table :profile_meta
    drop_table :profile_owners
  end
end
