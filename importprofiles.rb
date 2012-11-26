#importprofiles.rb
#Quick script to load mIRC Reibot profiles.ini to your database of choice
require 'cinch'
require 'active_record'
require 'pry'
require './rb_utils'
require 'iniparse'
require 'yaml'

#Populate database config from the YML
dbconfig=YAML.load(File.read('db/config.yml'))

#If there's an environment variable set (ala Heroku), use that instead.
if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  ActiveRecord::Base.establish_connection(dbconfig['development'])
end

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


myfile       = File.read('profiles.ini')
profile_file = IniParse.parse(myfile)
profile_file.each do |section|
  @owner     = Owner.find_or_create_by_name(profile_file[section.key]['SetBy'])
  @profile   = @owner.profiles.create(
      :title => section.key,
      :whoset => profile_file[section.key]['SetBy'],
      :timeset => Time.parse(profile_file[section.key]['SetTime'])
  )
  profilekey = 1
  while profile_file[section.key][profilekey] do
    puts "I'm inserting #{profile_file[section.key][profilekey]} inside of #{section.key}"
    @profile.lines.create(:data => profile_file[section.key][profilekey])
    profilekey+=1
  end
end