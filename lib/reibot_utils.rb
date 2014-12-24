require 'yaml'
require 'active_record'
require 'pry'
require 'yaml'
require 'redis'

module Reibot_utils
  CONFIGURATION = YAML.load(File.read('config/plugins.yml'))
  $ignore_db = Redis.new(:db => 0)

  def self.included(*)
    Dir.glob(File.expand_path('app/models/*.rb')).each { |f| require f }
  end

  #noinspection RubyResolve
  STRINGS=(YAML.load(File.read('strings.yml')))

  def greet_string
    STRINGS.fetch('greetings').to_a.sample
  end

  def ack_string
    STRINGS.fetch('acknowledgements').to_a.sample
  end

  def deny_string
    STRINGS.fetch('denials').to_a.sample
  end

  def kick_string
    STRINGS.fetch('kicks').to_a.sample
  end

  def wait_string
    STRINGS.fetch('waits').to_a.sample
  end

  def cantfind_string
    STRINGS.fetch('cantfind').to_a.sample
  end

  def slaps_string
    STRINGS.fetch('slaps').to_a.sample
  end

  #We're going to need to strip the first item from a line of text rather often
  def without_cmd(incoming)
    reply = incoming.split(' ')
    reply.delete_at(0)
    reply
  end
  
  class Cinch::User
    def ignores?(name)
      ignorelist = $ignore_db.lrange(self.nick.downcase, 0, -1) #Returns array
      ignorelist.include?(name) ? true : false
    end    

    def is_ignored_by?(name)
      ignorelist = $ignore_db.lrange(name.downcase, 0, -1)
      ignorelist.include?(self.nick.downcase) ? true : false
   end
  end

  #TODO: A function to parse privileges? Standard:
  #Owners table contains a priveleges column which contains an array
  #Global permissions are first, any sub-arrays are taken to mean per-channel
  #permissions, with the first item in the sub array meaning the channel.
  #Permissions arrays only are nested 2 deep, first level global, second level channel.

end
