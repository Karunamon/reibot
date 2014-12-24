require 'cinch'
require 'reibot_utils'

class Troutslap
  include Cinch::Plugin
  include Reibot_utils

  match(/slap .*/, :prefix => '?', method: :slap)

  def slap(m)
    slap_ee = without_cmd(m.message).first
    slap_ee = m.target.nick if slap_ee =~ /reibot/i
    object = slaps_string
    #BUG: Apparently m (Cinch::Message) does not have the action methods
    #available like the docs say they do. Target does, so we pull it out
    #explicitly.
    m.target.safe_action "slaps #{slap_ee} around a bit with #{object}"
  end

end
