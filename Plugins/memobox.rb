require 'cinch'
require 'reibot_utils'
require 'redis'
require 'json'
require 'yaml'

$memobox_config = YAML.load(File.read('config/plugins.yml'))[:memobox]

class Memobox
  include Reibot_utils
  include Cinch::Plugin
  @@redis = Redis.new(:db => $memobox_config[:redis_db_id])

  ##Listeners##

  match(/note.*/, :prefix => '?', method: :leave_message)
  match(/resync-memos/, :prefix => '?!', method: :d_resync_memos)
  match(/show-pending-memos/, :prefix => '?!', method: :d_list_pending_memos)
  match(/delete-memos/, :prefix => '?!', method: :d_delete_memos)

  listen_to :message, method: :check_notes 
  #########


  #Methods#

  def leave_message(m)
    msgarray = without_cmd(m.message)
    sender = m.user.nick.downcase
    recipient = msgarray.shift.downcase
    text = msgarray.join(' ')
    newnote = {
        :timestamp => Time.new.to_s,
        :sender    => sender,
        :text      => text,
        :delivery  => m.channel? ? 'public' : 'private' #Symbols would be faster but they won't survive conversion to JSON
    }

    #Silently return without queueing the note if the recipient ignored the sender
    if m.user.is_ignored_by?(recipient)
      sleep 1
      debug "Discarding memo by #{m.user} since #{recipient} has ignored them"
      m.reply "#{ack_string}, #{m.user.nick}!"
      return
    end

    @@redis.lpush recipient, newnote.to_json
    debug "Queueing note for #{recipient} from #{m.user}"
    @@redis.expire recipient, 5184000 #2 months, in seconds
    m.reply "#{ack_string}, #{m.user.nick}!"
  end


  def check_notes(m)
    @notecount = @@redis.llen m.user.nick.downcase
    if @notecount > 0
        debug "Retrieving #{@notecount} notes for #{m.user.nick}"
        m.reply "I have #{@notecount} #{@notecount==1 ? 'message' : 'messages'} for you, #{m.user.nick}!"
        retrieve_notes(m, @notecount, m.user.nick.downcase)
    end
  end


  def retrieve_notes(m, count, name)
    count.times do
      note = JSON.load(@@redis.lpop(name))
      #The JSON converstion stringifies our symbols. Not a big deal..
      formatted_reply = "#{note['sender']} // #{note['timestamp']} // #{note['text']}"
      if note['delivery'] == 'private'
        User(m.user.nick.downcase).send formatted_reply
        debug "Delivered note to #{name} from #{m.user.nick} in private"
      else 
        m.reply formatted_reply
        debug "Delivered note to #{name} from #{m.user.nick}"
      end
    end
    #Trash the key if there's nothing else there
    @@redis.del name if @@redis.llen name == 0
  end


  def d_list_pending_memos(m)
    #if has_rights?(m.user.nick, 'Owner')
      m.reply 'Debug Function: Showing pending memos'
      @@redis.keys.each {|name| m.reply "#{@@redis.llen(name)} memos for #{name}"}
    #else m.reply deny_string
    #end
  end

  def d_delete_memos(m)
    names = without_cmd(m.message).split(' ')
    #if has_rights?(m.user.nick, 'Owner')
      m.reply "Debug Function: Erasing memos for: #{names.to_s}"
      names.each do |name|
        @@redis.multi
        @@redis.del name
      end
      m.reply "Erased notes for #{@@redis.exec} people"
    #else m.reply deny_string
    #end
    ensure @@redis.exec #Don't want the connection hung if something borks
  end

end
