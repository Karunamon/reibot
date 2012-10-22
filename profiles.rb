require 'sqlite3'
require 'cinch'
class Profiles
  include Cinch::Plugin
  #db = SQLite3::Database.new configatron.profiles.dbfile
  puts 'It works!'
end