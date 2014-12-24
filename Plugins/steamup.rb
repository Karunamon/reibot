#Yeah, this is basically a wholesale copy of isup.rb

require 'cinch'
require 'net/http'
require 'reibot_utils'

class Steamup
  include Cinch::Plugin
  include Reibot_utils

  match(/issteamup/, :prefix => '?', method: :upcheck)

  def upcheck(m)
    m.reply wait_string
    response = fetch('http://issteamdown.com/').body.inspect
    if /Steam is up./ =~ response
      m.reply 'Steam is up.'
    else
      m.reply 'Steam is down! Everybody panic!!!!11'
    end
  end

  def fetch(uri_str, limit = 10)
    raise ArgumentError, 'too many HTTP redirects' if limit == 0
    response = Net::HTTP.get_response(URI(uri_str))

    case response
      when Net::HTTPSuccess then
        response
      when Net::HTTPRedirection then
        location = response['location']
        warn "redirected to #{location}"
        fetch(location, limit - 1)
      else
        response.value
    end
  end
end