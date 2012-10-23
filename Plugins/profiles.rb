require 'cinch'
require 'sqlite3'

class Profiles
  include Cinch::Plugin
  #db = SQLite3::Database.new configatron.profiles.dbfile
  puts 'Loaded Profiles plugin!'
end