require_relative 'deck.rb'

class Hand

  POKER_HANDS = [
    :straight_flush,
    :four_of_a_kind,
    :full_house,
    :flush,
    :straight,
    :three_of_a_kind,
    :two_pair,
    :one_pair,
    :high_card
    ]

  def self.deal_hand(deck)
    hand = Hand.new(deck)
    hand.draw_cards
    hand
  end

  attr_accessor :cards

  def initialize(deck)
    @deck = deck
    @cards = []
  end

  def draw_cards
    until @cards.count == 5
      @cards += @deck.take(1)
    end
  end

  def discard_cards(*indices)
    indices.each do |index|
      @cards[index] = nil
    end

    @cards.compact!
  end

  def render
    "#{rank}\n#{@cards.map(&:render).join(", ")}"
  end

  def rank
    sort
    POKER_HANDS.each do |hand|
      return hand if hand == :high_card
      return hand if self.send("#{hand}?")
    end
  end

  def sort
    @cards.sort! {|card1, card2| card1.order <=> card2.order}
  end

  def beats?(other_hand)
    case POKER_HANDS.index(self.rank) <=> POKER_HANDS.index(other_hand.rank)
    when -1 then return true
    when 1 then return false
    end

    my_hand_freq = Hash.new{|h,k| h[k] = []}
    other_hand_freq = Hash.new{|h,k| h[k] = []}
    self.cards.each { |card| my_hand_freq[card.value] << card }
    other_hand.cards.each { |card| other_hand_freq[card.value] << card }

    4.downto(1) do |freq|

      my_hand_most_freq = my_hand_freq.select {|value, cards| cards.count == freq}.values
      next if my_hand_most_freq.empty?
      other_hand_most_freq = other_hand_freq.select {|value, cards| cards.count == freq}.values
      my_hand_most_freq.flatten!.sort! {|card1, card2| card2.order <=> card1.order}
      other_hand_most_freq.flatten!.sort! {|card1, card2| card2.order <=> card1.order}

      case my_hand_most_freq.map(&:order) <=> other_hand_most_freq.map(&:order)
      when -1 then return false
      when 1 then return true
      end
    end
    nil
  end

  def straight_flush?
    flush? && straight?
  end

  def flush?
    @cards.all? {|card| card.suit == @cards.first.suit}
  end

  def straight?
    #check if all cards are different
    return false unless @cards.map(&:value).uniq.count == 5
    return true if @cards.map(&:value) == [:deuce, :three, :four, :five, :ace]

    (1...@cards.size).each do |i|
      return false unless (@cards[i].order - @cards[i - 1].order) == 1
    end

    true
  end

  def four_of_a_kind?
    @cards.any? {|card| @cards.map(&:value).count(card.value) == 4}
  end

  def full_house?
    return false if four_of_a_kind?
    @cards.map(&:value).uniq.count == 2
  end

  def three_of_a_kind?
    return false if full_house?
    @cards.any? {|card| @cards.map(&:value).count(card.value) == 3}
  end

  def two_pair?
    @cards.select {|card| @cards.map(&:value).count(card.value) == 2}.count == 4
  end

  def one_pair?
    return false if full_house?
    @cards.select {|card| @cards.map(&:value).count(card.value) == 2}.count == 2
  end

end
