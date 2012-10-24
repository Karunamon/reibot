require 'yaml'
module RbUtils
  STRINGS=(YAML.load(File.read('strings.yml')))

  def greeting
    STRINGS.fetch('greetings').to_a.sample
  end

  def acknowledgement
    STRINGS.fetch('acknowledgements').to_a.sample
  end

  def denial
    STRINGS.fetch('denials').to_a.sample
  end

  def kick
    STRINGS.fetch('kicks').to_a.sample
  end
end