#my_version="0.1a"
require 'cinch'
#Load plugins
Dir.glob(File.expand_path("../Plugins/*.rb", __FILE__)).each do |file|
  require file
end


#Init the bot with our main config
metabot=Cinch::Bot.new
metabot.config.load(YAML.load(File.read('main.yml')))
dbconfig=YAML.load(File.read('config/database.yml'))
#For production use
#metabot.loggers << Cinch::Logger::FormattedLogger.new(File.open("Logs/metabot.log", "a"))
#metabot.loggers.level = :debug
#metabot.loggers.first.level = :info

#Database link
ActiveRecord::Base.establish_connection(
    dbconfig
)
#Boot up
metabot.start