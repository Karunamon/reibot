require 'cinch'
require_relative '../rb_utils'
class Hello
  include Cinch::Plugin
  include RbUtils
  match("hello", :prefix => "")

  def execute(m)
    m.reply "#{greeting}, #{m.user.nick}!"
  end
end
