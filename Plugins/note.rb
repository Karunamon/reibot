require 'cinch'
require 'active_record'
require 'pry'
require_relative '../rb_utils'


class Memobox
  include RbUtils
  include Cinch::Plugin


  ##Listeners##

  match(/note.*/, :prefix => "?", method: :leave_message)

  listen_to :message, method: :check_notes
  listen_to :connect, method: :on_connect

  #########

  ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3',
      :database => 'db/reibot.db3'
  )

  #Set up the database access object
  class Note < ActiveRecord::Base
  end


  def leave_message(m)
    msgarray= m.message.split(" ") #Our message is now an array
                                   #?note Person Some things!
    msgarray.delete_at(0)          #Kill the first item since it'll just be the command. What remains is the recipient..
    @notes_waiting.push(msgarray[0].downcase)
    Memobox::Note.create(
        :timeset   => (Time.new).ctime,
        :sender    => m.user.nick,
        :recipient => msgarray.shift, #Grab that first item and shift down, now we just have the message text
        :text      => msgarray.join(" ")
    )
    m.reply "#{acknowledgement}, #{m.user.nick}!"
  end

  def check_notes(m)
    if @notes_waiting.grep(/^#{m.user.nick}/i).count > 0
      notescount= Note.find_all_by_recipient("#{m.user.nick}").count
      if notescount > 1 then
        msgword="messages"
      else
        msgword="message"
      end
      m.reply "I have #{notescount} #{msgword} for you, #{m.user.nick}!"
      retrieve_notes(m)
    end
  end

  def retrieve_notes(m)
    @notes_waiting.delete("#{m.user.nick.downcase}")
    Note.find_all_by_recipient("#{m.user.nick}").each do |item|
      m.reply "(#{item[:sender]}) // #{item[:text]}"
      Note.delete(item[:id])
    end
  end

  def on_connect(m)
    @notes_waiting = Array.new
  end
end