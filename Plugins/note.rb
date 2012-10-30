require 'cinch'
require 'active_record'
require 'pry'
require_relative '../rb_utils'


class Memobox
  include RbUtils
  include Cinch::Plugin


  ##Listeners##

  match(/note.*/, :prefix => "?", method: :leave_message)
  listen_to :connect, method: :on_connect
  listen_to :message, method: :check_notes


  #########

  #Set up the database access object
  class Note < ActiveRecord::Base
  end


  def leave_message(m)
    msgarray = without_cmd(m.message)
    @notes_waiting.push(msgarray[0])
    Memobox::Note.create(#TODO: Need a way to make this case insensitive so a db besides SQLIte can be used
        :timeset   => (Time.new).ctime,
        :sender    => m.user.nick,
        :recipient => msgarray.shift, #Grab that first item and shift down, now we just have the message text
        :text      => msgarray.join(" ")
    )
    m.reply "#{ack_string}, #{m.user.nick}!"
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
      m.reply "#{item[:sender]} // #{item[:text]}"
      Note.delete(item[:id])
    end
  end

  def on_connect(m)
    @notes_waiting = Array.new
  end
end