require 'cinch'
class Hello
  include Cinch::Plugin
  puts "Hello plugin initialized"

  @greetings=["Hello", "Guten tag", "Hola", "Moshimoshi", "Sup", "How's it hangin?", "Word", "Top o' the day to ya", "Namaste"]

  def self.random_hello
    @greetings.sample
  end

  match("hello", :prefix => "")

  def execute(m)
    m.reply "#{Hello.random_hello}, #{m.user.nick}!"
  end

end