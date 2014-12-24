require 'cinch'
require 'reibot_utils'
class Hello
  include Cinch::Plugin
  include Reibot_utils
  match('hello', :prefix => '')

  def execute(m)
    m.reply "#{greet_string}, #{m.user.nick}!"
  end
end
