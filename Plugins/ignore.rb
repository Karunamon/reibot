require 'cinch'
require 'reibot_utils'
require 'redis'
require 'json'
require 'yaml'


class Ignorelist
  include Reibot_utils
  include Cinch::Plugin
  @@redis = Redis.new(:db => 0)

  ##Listeners##

  match(/ignore .*/, :prefix => '?', method: :ignore)
  match(/unignore .*/, :prefix => '?', method: :unignore)
  match(/ignorelist$/, :prefix => '?', method: :ignorelist)
  #########


  #Methods#

  def ignore(m)
    if m.channel?
      m.user.msg 'All ignore functions must be done in private message.'
      return
    end
    target = without_cmd(m.message).first.downcase
    @@redis.lpush(m.user.nick.downcase, target)
    m.reply "#{target} is now on your ignore list."
  end


  def unignore(m)
    if m.channel?
      m.user.msg 'All ignore functions must be done in private message.'
      return
    end
    target = without_cmd(m.message).first.downcase
    returnval = @@redis.lrem(m.user.nick.downcase, 1, target)
    if returnval == 0
      m.reply "#{target} was not on your ignore list."
      return
    else
      m.reply "#{target} has been removed from your ignore list."
      return
    end
  end

 def ignorelist(m)
  if m.channel?
      m.user.msg 'All ignore functions must be done in private message.'
      return
  end
  list = @@redis.lrange(m.user.nick.downcase, 0, -1)
  m.reply "Your ignore list contains the following: #{list}"
 end

end
