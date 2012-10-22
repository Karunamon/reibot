#noinspection RubyResolve
$my_version="0.1a"
require 'cinch'
require_relative 'hello'
require_relative 'profiles'

configfile = File.read('mainbot.yml')

#Init the bot with our main config
metabot    = Cinch::Bot.new
metabot.config.load(YAML.load(configfile))

#Boot up
metabot.start