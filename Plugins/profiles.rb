require 'cinch'
require 'active_record'
#require 'bcrypt'
require_relative '../rb_utils'

class Profiles
  include Cinch::Plugin
  include RbUtils
  ##Listeners##

  match(/(^\?learn |^\?save |^\?remember |^\?store )/i, :prefix => "", method: :add_profile)
  match(/(^\?\? |^who is |^what is )/i, :prefix => "", method: :query_profile)
  match(/(^\?forget |^\?delete |^\?erase |^\?drop)/i, :prefix => "", method: :delete_profile)
  match(/^\?detail /i, :prefix => "", method: :detail_profile)


  #Models#
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

  #Methods#

  def has_owner?(nick)
    Owner.find_all_by_name(nick).any?
  end

  def profile_exists?(title)
    Profile.find_all_by_title(title).any?
  end

  def can_modify?(user)
    if Owner.find_all_by_name(user).any? #If they created the profile, they can modify it.
      true
    elsif Owner.find(:all, :conditions => "name = '#{user}' AND privileges LIKE '%Admin%' OR privileges LIKE '%Master%'").any? #Check for admin or master privs TODO: Centralize this
      true
    else
      false
    end
  end

  def add_profile(m)
    msgarray = without_cmd(m.message)
    item     = msgarray[0]
    if has_owner?(m.user.nick)
      @owner = Owner.find_all_by_name(m.user.nick)[0]
    else
      @owner = Owner.create(:name => m.user.nick)
    end
    if profile_exists?(msgarray[0]) #Check to see if a profile already exists
      m.reply "#{deny_string}, #{m.user.nick}!" unless can_modify?(m.user.nick) #Bail out with an error if they don't have rights
      return unless can_modify?(m.user.nick)
      @profile = Profile.find_all_by_title(msgarray.shift)[0]                   #It exists, so set @Profile to be the target profile
      @line    = @profile.lines.create(:data => msgarray.join(" "))             #Add the requested line
      m.reply "#{ack_string}, #{m.user.nick}! I've updated #{item}."
    else
      @profile = @owner.profiles.create(:timeset => (Time).new.ctime, :title => msgarray.shift) #Ok, it doesn't exist, make a new one
      @line    = @profile.lines.create(:data => msgarray.join(" "))                             #Add the requested line
      m.reply "#{ack_string}, #{m.user.nick}! I've stored #{item}."
    end
  end


  def query_profile(m)
    msgarray   = without_cmd(m.message)
    gotprofile = Profile.find_all_by_title(msgarray[0])
    begin
      unless gotprofile.any?
        raise "No profile found"
      end
      #m.reply "#{msgarray[0]}:"  #Removed by request
      Line.find_all_by_profile_id(gotprofile[0].id).each do |item|
        m.reply item.data
      end
    rescue
      m.reply "Got nothing, #{m.user.nick}."
    end
  end

  def delete_profile(m)
    msgarray   = without_cmd(m.message)
    gotprofile = Profile.find_all_by_title(msgarray[0])
    begin
      unless gotprofile.any?
        raise "No profile found"
      end
      m.reply "#{deny_string}, #{m.user.nick}!" unless can_modify?(m.user.nick)
      return unless can_modify?(m.user.nick)
      gotprofile[0].destroy
      m.reply "Deleted #{msgarray[0]}."
    rescue
      m.reply "That doesn't exist, #{m.user.nick}."
    end
  end
end
