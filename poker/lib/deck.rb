require_relative 'card.rb'

class Deck

  def self.make_deck
    deck = []
    Card.suits.each do |suit|
      Card.values.each do |value|
        deck << Card.new(suit, value)
      end
    end
    deck
  end

  def initialize(cards = Deck.make_deck)
    @cards = cards
  end

  def shuffle
    @cards.shuffle!
  end

  def take(n)
    cards = []
    n.times {cards << @cards.shift}
    cards
  end

  def count
    @cards.count
  end

  attr_reader :cards


end
