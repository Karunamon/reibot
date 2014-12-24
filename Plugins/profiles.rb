require 'cinch'
require 'active_record'
require 'reibot_utils'

class Profiles
  include Cinch::Plugin
  include Reibot_utils
  ##Listeners##

  match(/(^\?learn |^\?save |^\?remember |^\?store )/i, :prefix => '', method: :add_profile)
  match(/(^\?\? )/i, :prefix => '', method: :query_profile)
  match(/(^\?forget |^\?delete |^\?erase |^\?drop)/i, :prefix => '', method: :delete_profile)
  #match(/^\?detail /i, :prefix => "", method: :detail_profile) TODO: Add detail method


  #@PARAM [object] - The ActiveRecord object representing a user(owner) record
  #@RETURN [symbol] - The symbol of the matching object, if any.
  def has_override_rights?(user)
    CONFIGURATION[:profiles_config][:override_groups].each do |group|
      if user.privileges.index(group)
	true
      else
	false
      end
    end
  end

  def profile_exists?(title)
    Profile.find_by_title(title)
  end

  def can_modify?(owner, item)
    @items_owner_id = item.owner_id
    @owners_id = owner.id
    if @items_owner_id.eql? @owners_id #Users can modify their own profiles
      true
    elsif has_override_rights?(owner)
      true
    else
      false
    end
  end

  def add_profile(m)
    begin
    msgarray = without_cmd(m.message)
    item     = msgarray[0]
    @owner = Owner.find_or_create_by(:name => m.user.nick)
    if profile_exists?(item)
      @profile = Profile.find_by_title(msgarray.shift)
      unless can_modify?(@owner, @profile)
        m.reply "#{deny_string}, #{m.user.nick}!"
        return
      end
      @line    = @profile.lines.create(:data => msgarray.join(' ')) #Add the requested line
      m.reply "#{ack_string}, #{m.user.nick}! I've updated #{item}."
    else
      @profile = @owner.profiles.create(:title => msgarray.shift, :whoset => m.user.nick) #Ok, it doesn't exist, make a new one
      @line    = @profile.lines.create(:data => msgarray.join(' '))                             #Add the requested line
      m.reply "#{ack_string}, #{m.user.nick}! I've stored #{item}."
    end
    ensure
    ActiveRecord::Base.clear_active_connections!
    end
  end


  def query_profile(m)
    msgarray   = without_cmd(m.message)
    gotprofile = Profile.find_by_title(msgarray[0])
    #binding.pry
    begin
      raise NameError 'No profile found' unless gotprofile
      Line.where(:profile_id => gotprofile.id).each do |item|
        m.reply item.data
      end
    rescue NameError
      m.reply "#{cantfind_string}, #{m.user.nick}."
    ensure
      ActiveRecord::Base.clear_active_connections!
    end
  end

  def delete_profile(m)
    msgarray   = without_cmd(m.message)
    @profile = Profile.find_by_title(msgarray[0])
    @owner = Owner.find_by(:name => m.user.nick)
    begin
      raise NameError 'No profile found' unless @profile
      unless can_modify?(@owner, @profile)
        m.reply "#{deny_string}, #{m.user.nick}!"
        return
      end
      @profile.destroy
      m.reply "Deleted #{msgarray[0]}."
    rescue NameError
      m.reply "#{cantfind_string}, #{m.user.nick}."
    ensure
    ActiveRecord::Base.clear_active_connections!
    end
  end
end
