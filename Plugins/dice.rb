require 'cinch'
require_relative '../rb_utils'
require 'active_support/core_ext/enumerable.rb'
require 'pry'

class Dice
  include Cinch::Plugin
  include RbUtils

  match(/roll.+/, :prefix => '?', method: :diceroll)

  def diceroll(m)
    diceroll_array = []
    msgarray = without_cmd(m.message)
    dice_re=/(\d{1,2})d(\d{1,4})((?:\d+|\W+)+)?/
    dice = dice_re.match(msgarray.shift)
    dice[1].to_i.times { diceroll_array.push Random.new.rand(1..dice[2].to_i) }
    dice_sum = diceroll_array.sum
    total = eval(dice_sum.to_s << dice[3].to_s)
    m.reply "Result: #{diceroll_array} => #{dice[3] ? dice_sum.to_s << dice[3].to_s << ' ==> ' << total.to_s : dice_sum} #{msgarray[0] ? '- ' << msgarray.join(' ') << '!' : '!'}"
  rescue StandardError => e
    #This is probably a terrible idea but makes for a really neat exception handler..
    m.reply e.to_s
  end
end
