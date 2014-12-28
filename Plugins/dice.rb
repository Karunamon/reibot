require 'cinch'
require 'reibot_utils'

class Dice
  include Cinch::Plugin
  include Reibot_utils
  $dice_re = /^(?:(?<rolls>\d+)#\s*)?(?<dice>\d+)d(?<sides>\d+)(?<alter>([+-\/*]\d+)*)?(?<opts> full|)?(?<name> .+)?/
  match($dice_re, :prefix => '', method: :diceroll2)


  def format_output(rollset, dicedata)
    result = String.new

    if dicedata['rolls'] == 1 || dicedata['rolls'].nil? #If we're just doing one set of rolls, use the old style output.
      @sum = rollset[0].inject(:+).to_s
      @modified_sum = dicedata['alter'].empty?  ? nil : eval( "#{@sum} #{dicedata["alter"]}" )
      #Slightly different output if a modifier was used
      if @modified_sum
        return "Result: #{rollset[0].to_s} ==> #{@sum}#{dicedata["alter"]} ===> #{@modified_sum} #{dicedata["name"] || ''}"
      else 
        return "Result: #{rollset[0].to_s} ==> #{@sum} #{dicedata["name"] || ''}"
      end

    else #Use the new "condensed" method otherwise:

      rollset.each do |roll_set| 
        modifier = dicedata['alter']
        debug "Modifier: #{modifier}"
        unmodified_total = roll_set.inject(:+)
        debug "Unmodified total for this set: #{unmodified_total}"
        modified_total = eval( "#{roll_set.inject(:+)} #{modifier}" )
        debug "Modified total for this set: #{modified_total}"
        dicedata['opts'] == 'full' ? rolls = roll_set.to_s : rolls = ''
        debug "Rolls var: #{rolls}"
        result << "#{modified_total}: #{unmodified_total.to_s + rolls}#{modifier} "
        debug "Current result: #{result}"
      end
     
      result << dicedata["name"] if dicedata["name"]
      return result

    end

  end

  def diceroll2(m)
    dicematch = $dice_re.match(m.message)
    dicedata = Hash[ dicematch.names.zip( dicematch.captures ) ]  #Convert Matchdata to Hash, since Matchdata throws exceptions if you reference a nonexistent key
    debug "diceroll2 processing on #{m.message}, which decodes to #{dicedata}"

    #Evaluate for sanity
    if dicedata["rolls"].to_i > 100
      debug "Rejected dice command from #{m.user} for too many rolls (#{dicedata["rolls"]})"
      m.reply "That's way too many rolls."
      return
    elsif dicedata["dice"].to_i > 100
      debug "Rejected dice command from #{m.user} for too many dice. (#{dicedata["dice"]})"
      m.reply "That's way too many dice."
      return
    elsif dicedata["sides"].to_i > 100
      debug "Rejected dice command from #{m.user} for too many sides. (#{dicedata["sides"]})"
      m.reply "That's way too many sides."
      return
    end

    dicedata["name"].strip! if dicedata["name"]
    dicedata["opts"].strip! if dicedata["opts"]

    outer = []
    inner = []

    dicedata['rolls'] = 1 if dicedata['rolls'].nil?
    dicedata['rolls'].to_i.times do
      dicedata['dice'].to_i.times do
        r = Random.new.rand(1..dicedata['sides'].to_i)
        debug "Rolled a #{r}"
        inner.push r
      end
      outer.push inner
      debug "Pushing roll set #{inner}"
      inner = []
    end

    result = format_output(outer, dicedata)

    debug "Final result: #{result}"
    m.reply result.strip

  end
end
