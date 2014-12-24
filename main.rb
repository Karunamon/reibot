require 'cinch'

#Bring our lib folder into the load path
$LOAD_PATH << './lib'

#Load plugins
Dir.glob(File.expand_path('../Plugins/*.rb', __FILE__)).each do |file|
  #noinspection RubyResolve
  require file
end


#Init the bot with our main config
metabot=Cinch::Bot.new
#noinspection RubyResolve,RubyResolve
metabot.config.load(YAML.load(File.read('config/reibot.yml')))
#noinspection RubyResolve
dbconfig=YAML.load(File.read('db/config.yml'))

#For production use
#metabot.loggers << Cinch::Logger::FormattedLogger.new(File.open("Logs/metabot.log", "a"))
#metabot.loggers.level = :debug
#metabot.loggers.first.level = :info

#Database link
#Use an env if its specified, otherwise default to development DB
if ENV['DATABASE_URL'] #Heroku or some other well-behaved environment
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
elsif ENV['VCAP_SERVICES'] #AppFog - yeah, this is a bit of a mess.
  require 'json'
  #noinspection RubyResolve
  service = JSON.load(ENV['VCAP_SERVICES'])[services.keys.first].first
  #noinspection RubyResolve
  raise RuntimeError 'Unable to locate database service' unless service['tags'].include('postgres')
  ActiveRecord::Base.establish_connection(service['credentials'].rename('name' => 'database').map { |k, v| [k.to_sym, v] })
else #Nope? Just use the dev environment
  ActiveRecord::Base.establish_connection(dbconfig['production'])
end

#Boot up
#metabot.loggers.first.level = :log
metabot.start
