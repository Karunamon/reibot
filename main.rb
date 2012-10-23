#my_version="0.1a"
require 'cinch'
#Load plugins
Dir.glob(File.expand_path("../Plugins/*.rb", __FILE__)).each do |file|
  require file
end

configfile = File.read('mainbot.yml')

#Init the bot with our main config
metabot    = Cinch::Bot.new
metabot.config.load(YAML.load(configfile))

#Boot up
metabot.start