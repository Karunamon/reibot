require 'cinch'
require_relative '../rb_utils'
class Hello
  include Cinch::Plugin
  include RbUtils
  match("hello", :prefix => "")

  def execute(m)
    m.reply "#{greet_string}, #{m.user.nick}!"
  end
end
