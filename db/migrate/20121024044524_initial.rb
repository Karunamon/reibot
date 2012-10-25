class Initial < ActiveRecord::Migration
  def up
    #Create the table by hand because standard AR doesn't seem to have a way to do column collation
    execute "CREATE TABLE notes (
    id        INTEGER         PRIMARY KEY AUTOINCREMENT
                              NOT NULL,
    timeset   DATETIME,
    sender    VARCHAR( 255 )  COLLATE 'NOCASE',
    recipient VARCHAR( 255 )  COLLATE 'NOCASE',
    text      VARCHAR( 255 )
);"
  end

  def down
    drop_table :notes
  end
end