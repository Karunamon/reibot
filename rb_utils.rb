require 'yaml'
require 'active_record'
module RbUtils
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

  #We're going to need to strip the first item from a line of text rather often
  def without_cmd(incoming)
    incoming.split(" ").delete_at(0)
  end
end