require 'cinch'
require_relative 'hello'
require_relative 'config'

#my_version="0.1a"
#my_env="dev"

metabot = Cinch::Bot.new do
  configure do |c|

    #noinspection RubyResolve
    c.server          = configatron.irc.server
    #noinspection RubyResolve,RubyLiteralArrayInspection
    c.channels        = ["#TKWare"]
    c.user            = configatron.irc.username
    c.nick            = configatron.irc.nick
    #noinspection RubyResolve
    c.plugins.plugins = [Hello]
    #Name check
    #if my_env == "dev" then c.nick = "[Rei|Dev]"
    #elsif my_env == "prod" then c.nick = "[Rei]"
    #end
  end

#Do things here
end

metabot.start


