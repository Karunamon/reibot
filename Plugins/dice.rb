require 'cinch'
require 'reibot_utils'

class Dice
  include Cinch::Plugin
  include Reibot_utils

  match(/^(?:(?<rolls>\d+)#\s*)?(?<dice>\d+)d(?<sides>\d+)(?<alter>([+-\/*]\d+)*)?(?<opts> \w+)?(?<name> .+)?/, :prefix => '', method: :diceroll2)

  def diceroll2(m)
   dicematch =  /^(?:(?<rolls>\d+)#\s*)?(?<dice>\d+)d(?<sides>\d+)(?<alter>([+-\/*]\d+)*)?(?<opts> \w+)?(?<name> .+)?/.match(m.message)
   dicedata = Hash[ dicematch.names.zip( dicematch.captures ) ]  #Convert Matchdata to Hash, since Matchdata throws exceptions if you reference a nonexistent key
   debug "diceroll2 processing on #{m.message}, which decodes to #{dicedata}"
   dicedata["name"].strip! if dicedata["name"]
   dicedata["opts"].strip! if dicedata["opts"]

   outer = []
   inner = []
   result = String.new

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

   #We now have an array of arrays, each inner array containing the set of rolls

   outer.each do |rollset|
     modifier = dicedata['alter']
     debug "Modifier: #{modifier}"
     unmodified_total = rollset.inject(:+)
     debug "Unmodified total for this set: #{unmodified_total}"
     modified_total = eval( "#{rollset.inject(:+)} #{modifier}" )
     debug "Modified total for this set: #{modified_total}"
     dicedata['opts'] == 'full' ? rolls = rollset.to_s : rolls = ''
     debug "Rolls var: #{rolls}"
    result << "#{modified_total}: #{unmodified_total.to_s + rolls}#{modifier} "
    debug "Current result: #{result}"
   end

   debug "Final result: #{result}"
   result << dicedata["name"] if dicedata["name"]
   m.reply result

  end
end
