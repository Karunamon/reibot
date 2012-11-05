require 'cinch'
require 'active_record'
require 'pry'
require './rb_utils'
require 'IniParse'
require 'yaml'

dbconfig=YAML.load(File.read('db/config.yml'))

ActiveRecord::Base.establish_connection(
    dbconfig["development"]
)

class Owner < ActiveRecord::Base
  has_many :profiles
end

class Profile < ActiveRecord::Base
  has_many :lines
  belongs_to :owner
end

class Line < ActiveRecord::Base
  belongs_to :profiles
end

class InsertProfile
end
myfile       = File.read('profiles.ini')
profile_file = IniParse.parse(myfile)

#binding.pry
profile_file.each do |section|
  # binding.pry
  @owner     = Owner.find_or_create_by_name(profile_file[section.key]['SetBy'])
  @profile   = @owner.profiles.create(:title => section.key, :whoset => profile_file[section.key]['SetBy'], :timeset => Time.parse(profile_file[section.key]['SetTime']))
  profilekey = 1
  #binding.pry
  while profile_file[section.key][profilekey] do
    puts "I'm inserting #{profile_file[section.key][profilekey]} inside of #{section.key}"
    @profile.lines.create(:data => profile_file[section.key][profilekey])
    profilekey+=1
  end
end