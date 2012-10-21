require 'cinch'
class Hello
  include Cinch::Plugin

  $greetings=["Hello", "Guten tag", "Hola", "Moshimoshi", "Sup", "How's it hangin?", "Word"]

  #So this is how you assign a hash...
  match("hello", :prefix => "")


  def execute(m)
    m.reply "#{$greetings.sample}, #{m.user.nick}!"
  end

end