class Game

  attr_reader :deck, :players, :pot

  def initialize(starting_bank_roll, *players)
    @pot = Pot.new(0)
    @players = players.map do |name|
      Player.new(name, starting_bank_roll, @pot)
    end
  end

  def run
    until players.reject { |player| player.bankroll.zero? }.count == 1
      deal_hands
      get_bets
      prompt_hand_changes
      get_bets
      display_winning_hand
      give_payout
      # also need to display each players' bankroll, etc.
    end

    # winning message
  end

  def deal_hands
    @deck = Deck.new
    deck.shuffle
    players.each { |player| player.receive_hand(Hand.deal_hand(deck)) }
  end

  # I know this ignores raising and calling, I'll get to that some other time\
  # This also ignores folding....
  def get_bets
    players.each do |player|
      puts player.hand.render
      puts "#{player.name}, how much would you like to bet?"
      bet = Integer(gets.chomp)
      player.place_bet(bet)
    end
  end

  def prompt_hand_changes
    players.each do |player|
      puts player.hand.render
      puts "#{player.name}, which cards would you like to discard?"
      to_delete = gets.chomp.split(",").map { |card| Integer(card) }
      player.hand.discard_cards(*to_delete)
      player.hand.draw_cards
      puts player.hand.render
    end
  end

  def display_winning_hand
    @winner = players.select do |player|
      players.each do |other|
        next if player == other
        player.hand.beats?(other.hand)
      end
    end
    puts winner.first.hand.render
  end

  def give_payout
    @winner.receive_pay_out(pot.value)
    pot.value = 0
  end


end



class Pot

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def increase(bet)
    @value += bet
  end

  def reduce(pay_out)
    @value -= pay_out
  end

end
