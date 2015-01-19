require_relative 'hand.rb'

class Player
  attr_reader :hand, :bankroll, :pot, :last_bet

  def initialize(name, bankroll, pot)
    @name, @bankroll, @pot = name, bankroll, pot
    @last_bet = 0
  end

  def receive_hand(hand)
    @hand = hand
  end

  def fold
    @hand = nil
    @last_bet = 0
  end

  def place_bet(bet_amount)
    raise "exceeds bankroll" if @bankroll < bet_amount
    @last_bet += bet_amount
    @bankroll -= bet_amount
    @pot.increase(bet_amount)
  end

  def call_bet(bet_amount)
    diff = bet_amount - @last_bet
    place_bet(diff)
  end

  def raise_bet(bet_amount, raise_amount)
    diff = bet_amount - @last_bet
    place_bet(diff + raise_amount)
  end

  def receive_pay_out(pay_out)
    @bankroll += pay_out
  end


end
