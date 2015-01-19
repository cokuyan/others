require 'rspec'
require 'player.rb'

describe Player do
  let(:pot) { double("pot", value: 1_000_000) }
  subject(:player) { Player.new("Louie", 10_000, pot) }

  describe "#initialize" do
    it "initializes with a pot" do
      expect(player.pot.value).to eq(1_000_000)
    end

    it "initializes with a bankroll" do
      expect(player.bankroll).to eq(10_000)
    end
  end

  describe "#receive_hand" do
    it "gets a new hand" do
      hand = double("hand")
      player.receive_hand(hand)
      expect(player.hand).to_not be_nil
    end
  end

  describe "#fold" do
    it "discards hand" do
      player.fold
      expect(player.hand).to be_nil
    end

    it "resets player's bet" do
      allow(pot).to receive(:increase).with(5_000)
      player.place_bet(5_000)
      player.fold
      expect(player.last_bet).to be_zero
    end
  end

  describe "#place_bet" do
    it "raises error if bet exceeds bankroll" do
      allow(pot).to receive(:increase).with(20_000)
      expect{player.place_bet(20_000)}.to raise_error("exceeds bankroll")
    end

    it "decreases bankroll by bet amount" do
      allow(pot).to receive(:increase).with(7_500)
      player.place_bet(7_500)
      expect(player.bankroll).to eq(2_500)
    end

    it "increases pot by bet amount" do
      allow(pot).to receive(:increase).with(5_000)
      allow(pot).to receive(:value).and_return(1_005_000)
      player.place_bet(5_000)
      expect(player.pot.value).to eq(1_005_000)
    end

    it "records bet amount" do
      allow(pot).to receive(:increase).with(10_000)
      player.place_bet(10_000)
      expect(player.last_bet).to eq(10_000)
    end
  end

  describe "#call_bet" do
    it "places the last bet" do
      allow(pot).to receive(:increase).with(5_000)
      player.call_bet(5_000)
      expect(player.last_bet).to eq(5_000)
    end

    it "matches the last bet" do
      allow(pot).to receive(:increase).with(2_500)
      allow(pot).to receive(:increase).with(500)
      player.place_bet(2_500)
      player.call_bet(3_000)
      expect(player.last_bet).to eq(3_000)
    end
  end

  describe "#raise_bet" do
    it "places a bet" do
      allow(pot).to receive(:increase).with(500)
      player.raise_bet(500, 0)
      expect(player.last_bet).to eq(500)
    end

    it "raises a bet by an amount" do
      allow(pot).to receive(:increase).with(1_000)
      player.raise_bet(500, 500)
      expect(player.last_bet).to eq(1_000)
    end
  end

end
