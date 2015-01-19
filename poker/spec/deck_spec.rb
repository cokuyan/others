require 'rspec'
require 'deck.rb'

describe Deck do
  let(:cards) do
    cards = [
      Card.new(:spades, :king),
      Card.new(:spades, :queen),
      Card.new(:spades, :jack),
      Card.new(:spades, :ten),
      Card.new(:spades, :nine)
    ]
  end

  describe "#initialize" do
    it "initializes a deck with 52 cards by default" do
      deck = Deck.new
      expect(deck.count).to eq(52)
    end

    it "initializes a deck given certain cards" do
      deck = Deck.new(cards)
      expect(deck.cards).to eq(cards)
    end
  end

  describe "#take" do
    let(:deck){Deck.new(cards.dup)}
    it "takes 5 cards off the deck" do
      expect(deck.take(5)).to eq(cards)
    end

    it "removes cards from deck" do
      deck.take(2)
      expect(deck.count).to eq(3)
    end
  end


  describe "#shuffle" do
    let(:deck) { Deck.new(cards.dup) }
    before(:each) { deck.shuffle }

    it "alters the order of the cards" do
      expect(deck.cards).to_not eq(cards)
    end

    it "does not change the cards" do
      expect(deck.cards).to match_array(cards)
    end

    it "does not change the number of cards" do
      expect(deck.cards.count).to eq(cards.count)
    end
  end

end
