require 'cinch'
require 'active_record'
puts 'Memobox loaded'
class Memobox
  include Cinch::Plugin
  ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3',
      :database => 'notes.db'
  )
  ActiveRecord::Schema.define do
    create_table :notes do |table|
      table.column :id, :integer
      table.column :timeset, :DateTime
      table.column :sender, :string
      table.column :recipient, :string
      table.column :text, :string
    end
  end

#Console spam
  def initialize(*args)
    puts "Memobox initialized"
    super
  end

  class Note < ActiveRecord::Base
  end

  match(/note.*/, :prefix => "?")

  def execute(m)
    m.reply "Got it, #{m.user.nick}!"
    msgarray= m.message.split(" ")
                          #Our message is now an array
    msgarray.delete_at(0) #Kill the first item since it'll just be the command. What remains is the recipient..
    Memobox::Note.create(
        :timeset   => (Time.new).ctime,
        :sender    => m.user.nick,
        :recipient => msgarray.shift, #Grab that first item and shift down, now we just have the message text
        :text      => msgarray.join(" ")
    )
  end
end

#TODO: A listener for any chat on channel, searches for their name in recipients, grabs the record and plays it back in channel






