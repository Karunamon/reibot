$LOAD_PATH << '.'
require 'spec_helper'
require 'Plugins/dice.rb'

def msg_double(contents)
  return double('message', :message => contents, :user => 'JoeTestuser')
end


describe 'Dice Plugin' do

  before(:each) do 
    bot = double('bot').as_null_object
    @d = Dice.new(bot)
  end

  context "Error Checking" do

    it "replies with an error with more than 100 sides" do
      m = msg_double '1d101'
      expect(m).to receive('reply').with(/That's way too many.*/)
      @d.diceroll2(m)
    end

    it "replies with an error with more than 100 rolls" do
      m = msg_double '101#1d10'
      expect(m).to receive('reply').with(/That's way too many.*/)
      @d.diceroll2(m)
    end

    it "replies with an error with more than 100 dice" do
      m = msg_double '101d10'
      expect(m).to receive('reply').with(/That's way too many.*/)
      @d.diceroll2(m)
    end

  end

  context "Single rolls" do
    it "uses the correct formatting" do
      m = msg_double '1d10'
      expect(m).to receive('reply').with(/Result:.*/)
      @d.diceroll2(m)
    end

    it "takes modifiers into account if provided" do
      m = msg_double '2d1+42'
      expect(m).to receive('reply').with('Result: [1, 1] ==> 2+42 ===> 44')
      @d.diceroll2(m)
    end
 
    it 'displays text after a roll if provided' do
      m = msg_double '2d1 this is a test'
      expect(m).to receive('reply').with('Result: [1, 1] ==> 2 this is a test')
      @d.diceroll2(m)
    end
  end

  context "Multi rolls" do

    it "uses the new format with multiple rolls" do
      m = msg_double '2#1d1'
      expect(m).to receive('reply').with(/\d+:.*/)
      @d.diceroll2(m)
    end

    it "takes modifiers into account if provided" do
      m = msg_double '2#1d1+42'
      expect(m).to receive('reply').with('43: 1+42 43: 1+42')
      @d.diceroll2(m)
    end

    it "correctly sums the result of multiple dice" do
      m = msg_double '2#5d1'
      expect(m).to receive('reply').with('5: 5 5: 5')
      @d.diceroll2(m)
    end

    it "correctly sums multiple dice with modifiers" do
      m = msg_double '2#5d1+42'
      expect(m).to receive('reply').with('47: 5+42 47: 5+42')
      @d.diceroll2(m)
    end

    it 'displays full rolls when asked' do
      m = msg_double '2#1d1 full'
      expect(m).to receive('reply').with('1: 1[1] 1: 1[1]')
      @d.diceroll2(m)
    end

    it 'displays text after a roll if provided' do
      m = msg_double '2#1d1 this is a test'
      expect(m).to receive('reply').with('1: 1 1: 1 this is a test')
      @d.diceroll2(m)
    end

    it 'displays the full roll and the post text if both are specified' do
      m = msg_double '2#1d1 full this is a test'
      expect(m).to receive('reply').with('1: 1[1] 1: 1[1] this is a test')
      @d.diceroll2(m)
    end
  end

end

