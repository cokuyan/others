require 'rspec'
require 'card.rb'

describe Card do
  subject(:card) { Card.new(:spades, :ace) }

  describe "#value" do
    it "returns the value of card" do
      expect(card.value).to eq(:ace)
    end
  end

  describe "#suit" do
    it "returns the suit of card" do
      expect(card.suit).to eq(:spades)
    end
  end

  describe "#==" do
    let(:other) {Card.new(:spades, :ace)}
    let(:different) {Card.new(:diamonds, :ace)}

    it "returns true if both cards have same suit and value" do
      expect(other).to eq(card)
    end

    it "returns false if both cards do not have same suit and value" do
      expect(different).to_not eq(card)
    end
  end
end
