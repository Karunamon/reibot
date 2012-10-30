require 'cinch'
require 'net/http'
require_relative '../rb_utils'
class Isup
  include Cinch::Plugin
  include RbUtils

  match(/isup.*/, :prefix => "?", method: :upcheck)

  def upcheck(m)
    m.reply ack_string
    message  = m.message.split(" ")
    response = fetch("http://isup.me/" + message[1]).body.inspect
    if /not just you/ =~ response
      m.reply "Looks like #{message[1]} is down from here!"
    else
      m.reply "Looks like #{message[1]} is up from here!"
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