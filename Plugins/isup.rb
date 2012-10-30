require 'cinch'
require 'net/http'
require_relative '../rb_utils'
class Isup
  include Cinch::Plugin
  include RbUtils

  match(/isup .*/, :prefix => "?", method: :upcheck)

  def upcheck(m)
    msgarray = without_cmd(m.message)
    page     =Net::HTTP.get('isup.me', msgarray[0])
    if /not just you/ =~ page
      m.reply "Looks like #{msgarray[0]} is down from here!"
    else
      m.reply "Looks like #{msgarray[0]} is up from here!"
    end
  end

end