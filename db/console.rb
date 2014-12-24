$LOAD_PATH << '../'
require 'pry'
require 'active_record'
require_relative '../lib/reibot_utils'

class Dbconsole
  #noinspection RubyResolve
  dbconfig=YAML.load(File.read('db/config.yml'))
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
  include Reibot_utils
  binding.pry
end
