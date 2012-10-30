class Initial < ActiveRecord::Migration
  def up
    #Create the table by hand because standard AR doesn't seem to have a way to do column collation
    execute "CREATE TABLE notes (
    id        SERIAL         PRIMARY KEY NOT NULL,
    timeset   TIMESTAMP,
    sender    VARCHAR( 255 ),
    recipient VARCHAR( 255 ),
    text      VARCHAR( 255 )
);"
  end

  def down
    drop_table :notes
  end
end