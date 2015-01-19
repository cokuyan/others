require 'rspec'
require 'hand.rb'

describe Hand do

  let(:deck) { double("deck") }

  let(:cards) do cards = [
    Card.new(:diamonds, :king),
    Card.new(:spades, :queen),
    Card.new(:spades, :jack),
    Card.new(:spades, :ten),
    Card.new(:spades, :nine)
  ]
  end

  describe ".deal_hand" do
    it "deals a hand of 5 cards" do
      allow(deck).to receive(:take).with(1).and_return(cards)
      hand = Hand.deal_hand(deck)
      expect(hand.cards.count).to eq(5)
    end
  end

  describe "#draw_cards" do
    it "draws cards from deck" do
      allow(deck).to receive(:take).with(1).and_return(cards)
      hand = Hand.new(deck)
      hand.draw_cards
      expect(hand.cards).to match_array(cards)
    end
  end

  describe "#discard_cards" do
    it "deletes a card at a given index" do
      allow(deck).to receive(:take).with(1).and_return(cards.dup)
      hand = Hand.deal_hand(deck)
      hand.discard_cards(4)
      expect(hand.cards).to_not include(cards[4])
    end

    it "deletes multiple cards" do
      allow(deck).to receive(:take).with(1).and_return(cards.dup)
      hand = Hand.deal_hand(deck)
      hand.discard_cards(2, 3, 4)
      expect(hand.cards).to match_array(cards[0..1])
    end
  end

  describe "#beats?" do

    let(:flush) { double("Flush", rank: :flush) }
    let(:two_pair) { double("Two Pair", rank: :two_pair) }

    it "returns true if it beats another hand" do
      allow(deck).to receive(:take).with(1).and_return(cards)
      hand = Hand.deal_hand(deck)
      expect(hand.beats?(two_pair)).to be true
    end

    it "returns false if it loses to another hand" do
      allow(deck).to receive(:take).with(1).and_return(cards)
      hand = Hand.deal_hand(deck)
      expect(hand.beats?(flush)).to be false
    end

    context "when checking high cards" do
      let(:other_deck){ double("Other Deck") }
      let(:higher_straight) do [
        Card.new(:diamonds, :king),
        Card.new(:spades, :queen),
        Card.new(:spades, :jack),
        Card.new(:spades, :ten),
        Card.new(:spades, :ace)
      ]
      end
      let(:lower_straight) do [
        Card.new(:diamonds, :eight),
        Card.new(:spades, :queen),
        Card.new(:spades, :jack),
        Card.new(:spades, :ten),
        Card.new(:spades, :nine)
      ]
      end

      it "returns false if it loses to another hand" do
        allow(deck).to receive(:take).with(1).and_return(cards)
        allow(other_deck).to receive(:take).with(1).and_return(higher_straight)
        hand = Hand.deal_hand(deck)
        other_hand = Hand.deal_hand(other_deck)
        expect(hand.beats?(other_hand)).to be false
      end

      it "returns true if it beats another hand" do
        allow(deck).to receive(:take).with(1).and_return(cards)
        allow(other_deck).to receive(:take).with(1).and_return(lower_straight)
        hand = Hand.deal_hand(deck)
        other_hand = Hand.deal_hand(other_deck)
        expect(hand.beats?(other_hand)).to be true
      end

    end

  end

end
