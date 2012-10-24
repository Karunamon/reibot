require 'cinch'
require 'active_record'
require_relative '../rb_utils'
require 'pry'

class Memobox
  @my_ver="v0.4c"
  include Cinch::Plugin
  include RbUtils

  #Set up some listeners for common events
  #listen_to :connect, method: :on_connect
  listen_to :online, method: :on_online
  listen_to :offline, method: :on_offline

  #Init our database
  ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3',
      :database => 'db/development.db3'
  )

  class Note < ActiveRecord::Base
  end

  match(/note.*/, :prefix => "?", method: :leave_message)

  def leave_message(m)
    m.reply "#{acknowledgement}, #{m.user.nick}!"
    msgarray= m.message.split(" ") #Our message is now an array
    msgarray.delete_at(0)          #Kill the first item since it'll just be the command. What remains is the recipient..
    Memobox::Note.create(
        :timeset   => (Time.new).ctime,
        :sender    => m.user.nick,
        :recipient => msgarray.shift, #Grab that first item and shift down, now we just have the message text
        :text      => msgarray.join(" ")
    )
  end

  def has_messages(nick)
    Note.count(:conditions => "recipient = '#{nick}'")
  end

  def playback_messages(nick)

  end

  #Register a handler to check for notes standing by
  def on_online(nick)
    if has_messages("nick") > 0
      playback_messages("nick")
    else
      nil
    end
  end
  #Debugging method to drop to a shell
  #match(/debugshell.*/, :prefix => "?", method: :debug_shell)
  #def debug_shell(m)
  #  m.reply "IRB shell launched on console."
  #  binding.pry
  #end
end


#TODO: A listener for any chat on channel, searches for their name in recipients, grabs the record and plays it back in channel